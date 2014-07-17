//
//  MapViewController.m
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#import "AppDelegate.h"
#import "MapViewController.h"
#import "ItemListViewController.h"

#import "Item.h"
#import "Shop.h"
#import "Flag.h"
#import "FlagDataController.h"
#import "URLParameters.h"

#import "MapUtil.h"
#import "ViewUtil.h"
#import "DataUtil.h"
#import "DelegateUtil.h"

#import "GoogleAnalytics.h"
#import "GTMHTTPFetcherLogging.h"
//#import "GTLFlagengine.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    CLLocation *location;

    FlagDataController *flagData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    flagData = [[FlagDataController alloc] init];
    
    [self initializeLocation];
    [self initalizeContent];
}

- (void)initalizeContent
{
    NSInteger view_type = 0;
    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        
        view_type = VIEW_FLAG_LIST;
        
        [self initializeLocation];
        [self initializeMapViewWithCurrentLocation:location];
        [self findFlagNearbyWithCurrentLocatoin:location];
        
    }else if (self.parentPage == SALE_INFO_VIEW_PAGE){
        
        view_type = VIEW_MAP_SHOP;
        
        [self initializeMapViewWithCurrentLocation:location];
        
        URLParameters *urlParams = [self urlParamsToGetFlagListByShop:self.objectIdForFlag];
        [self getFlagListByURLParams:urlParams];
        
    }else if (self.parentPage == ITEM_DETAIL_VIEW_PAGE){
        
        view_type = VIEW_MAP_ITEM;
        
        [self initializeMapViewWithCurrentLocation:location];
        
        URLParameters *urlParams = [self urlParamsToGetFlagListByItem:self.objectIdForFlag];
        [self getFlagListByURLParams:urlParams];
        
    }else if (self.parentPage == COLLECT_REWARD_SELECT_VIEW_PAGE){
        
        view_type = VIEW_MAP_REWARD;
        
        [self initializeMapViewWithCurrentLocation:[MapUtil getProximateCheckInSpotFromLocation:location]];
        
        // load check in reward flag list
        URLParameters *urlParams = [self urlParamsToGetFlagListByRewardAroundLocation:location];
        [self performSelectorInBackground:@selector(getFlagListByURLParams:) withObject:urlParams];
        
    }else if (self.parentPage == SHOP_LIST_VIEW_PAGE){
        
        view_type = VIEW_MAP_REWARD;
        
        if (self.type == MAP_TYPE_FLAG_LIST_FOR_SHOP) {
            
            DLog(@"flag list by shop");
            [self initializeMapViewWithCurrentLocation:location];
            
            URLParameters *urlParam = [self urlParamsToGetFlagListByShop:self.objectIdForFlag];
            
            [self getFlagListByURLParams:urlParam];
            
        }else if (self.type == MAP_TYPE_CHECKIN_REWARD_FLAG_LIST){
            
            [self initializeMapViewWithCurrentLocation:[MapUtil getProximateCheckInSpotFromLocation:location]];
            
            URLParameters *urlParams = [self urlParamsToGetFlagListByRewardAroundLocation:location];
            
            [self performSelectorInBackground:@selector(getFlagListByURLParams:) withObject:urlParams];
            
        }
    }
    
    // Analytics
    [DaLogClient sendDaLogWithCategory:CATEGORY_VIEW_APPEAR target:view_type value:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setUser:[DelegateUtil getUser]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Implementation
- (void)getFlagListByURLParams:(URLParameters *)urlParams
{
    NSURL *url = [urlParams getURLForRequest];
    NSString *methodName = [urlParams getMethodName];
    
    [FlagClient getDataResultWithURL:url methodName:methodName completion:^(NSDictionary *results){
        
        if (results) {
            [self setFlagDataWithJsonData:results];
        }
        
    }];
}

- (void)setFlagDataWithJsonData:(NSDictionary *)results
{
    NSArray *flags = [results objectForKey:@"flags"];
    
    if (flags) {
        
        [flagData removeAllData];
        [mapView_ clear];
        
        for(id object in flags){
            Flag *theFlag = [[Flag alloc] initWithData:object];
            [flagData addObjectWithObject:theFlag];
        }
        
        for(Flag *theFlag in flagData.masterData){
            [self fixFlagInMapWithFlag:theFlag];
        }
        
        [self.delegate performSelector:@selector(flagListOnMap:) withObject:flagData];
    }
}

- (void)showCurrentLocation
{
    // GA
    [GAUtil sendGADataWithUIAction:@"show_current_location" label:@"inside_view" value:nil];
    
    
    [self initializeLocation];
    [self moveCameraPositionToLocation:location];
    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        [self findFlagNearbyWithCurrentLocatoin:location];
    }
}

#pragma mark - GMS Delegate
- (void)initializeMapViewWithCurrentLocation:(CLLocation *)currentLocation
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude zoom:ZOOM_LEVEL];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
}

- (void)moveCameraPositionToLocation:(CLLocation *)cameraPosition
{
    GMSCameraPosition *currentPosition = [GMSCameraPosition cameraWithLatitude:cameraPosition.coordinate.latitude longitude:cameraPosition.coordinate.longitude zoom:ZOOM_LEVEL_FOR_CURRENT_LOCATION];
    [mapView_ setMyLocationEnabled:YES];
    [mapView_ setCamera:currentPosition];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    // GA
    [GAUtil sendGADataWithUIAction:@"tap_map" label:@"inside_view" value:nil];

    
    DLog(@"tapped : %f, %f", coordinate.latitude, coordinate.longitude);
    
    if (mapView.selectedMarker != nil) {
        Flag *theFlag = (Flag *)mapView.selectedMarker.userData;
        mapView.selectedMarker.icon = [UIImage imageNamed:[MapUtil getMapMarkerImageFileNameWithCategory:theFlag.shopType status:BASE]];
        mapView.selectedMarker = nil;
        [self.delegate performSelector:@selector(mapViewController:unSelectMarker:) withObject:mapView];
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    // GA
    [GAUtil sendGADataWithUIAction:@"marker_click" label:@"inside_view" value:nil];
    
    
    // check previous selected marker
    if (mapView.selectedMarker != nil) {
        Flag *theFlag = (Flag *)mapView.selectedMarker.userData;
        mapView.selectedMarker.icon = [UIImage imageNamed:[MapUtil getMapMarkerImageFileNameWithCategory:theFlag.shopType status:BASE]];
        mapView.selectedMarker = nil;
    }
    
    
    // show shop info and change marker
    Flag *selectedFlag = (Flag *)marker.userData;
    GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude longitude:marker.position.longitude zoom:ZOOM_LEVEL_FOR_SELECT_SHOP];
    
    marker.icon = [UIImage imageNamed:[MapUtil getMapMarkerImageFileNameWithCategory:selectedFlag.shopType status:SELECTED]];
    
    [mapView setSelectedMarker:marker];
    [mapView animateToCameraPosition:newCamera];
    if (marker.userData) {
        [self.delegate performSelector:@selector(mapViewController:didSelectMarker:) withObject:mapView withObject:marker];
    }
    
    return YES;
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    // GA
    [GAUtil sendGADataWithUIAction:@"move_position_map" label:@"inside_view" value:nil];

    
    if (self.parentPage == TAB_BAR_VIEW_PAGE) {
        CLLocation *changedLocation = [[CLLocation alloc] initWithLatitude:position.target.latitude longitude:position.target.longitude];
        
        if ([MapUtil isPositionOutOfBounderyAtPreviousPosition:location WithChangedPosition:changedLocation]) {
            
            location = changedLocation;
            [self findFlagNearbyWithCurrentLocatoin:changedLocation];
            
        }        
    }
}

- (void)fixFlagInMapWithFlag:(Flag *)theFlag
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([theFlag.lat floatValue], [theFlag.lon floatValue]);
    marker.icon = [UIImage imageNamed:[MapUtil getMapMarkerImageFileNameWithCategory:theFlag.shopType status:[theFlag getFlagCheckInStatus]]];
    marker.userData = theFlag;
    marker.map = mapView_;
}

#pragma mark - CLLocation
- (void)initializeLocation
{
    CLLocation *currentLocation = [DelegateUtil getCurrentLocation];
    location = currentLocation;
}

- (void)findFlagNearbyWithCurrentLocatoin:(CLLocation *)currentLocation
{
    [flagData removeAllData];
    [mapView_ clear];
    
    flagData = [DataUtil getFlagListAroundLocation:currentLocation rangeRadius:RADIUS_FLAG_LIST_THETA];
    
    for(Flag *theFlag in flagData.masterData){
        [self fixFlagInMapWithFlag:theFlag];
    }

    [self.delegate performSelector:@selector(flagListOnMap:) withObject:flagData];
}


#pragma mark - 
#pragma mark url params
- (URLParameters *)urlParamsToGetFlagListByRewardAroundLocation:(CLLocation *)theLocation
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"flag_list_byreward"];
    [urlParam addParameterWithKey:@"lat" withParameter:[NSNumber numberWithFloat:theLocation.coordinate.latitude]];
    [urlParam addParameterWithKey:@"lon" withParameter:[NSNumber numberWithFloat:theLocation.coordinate.longitude]];
    [urlParam addParameterWithUserId:self.user.userId];
    
    return urlParam;
}

- (URLParameters *)urlParamsToGetFlagListByItem:(NSNumber *)itemId
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"flag_list_byitem"];
    [urlParam addParameterWithKey:@"itemId" withParameter:itemId];
    
    return urlParam;
}

- (URLParameters *)urlParamsToGetFlagListByShop:(NSNumber *)shopId
{
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"flag_list_byshop"];
    [urlParam addParameterWithKey:@"shopId" withParameter:shopId];
    
    return urlParam;
}

@end