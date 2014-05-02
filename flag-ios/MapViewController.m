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
#import "CustomInfoWindow.h"

#import "Flag.h"
#import "FlagDataController.h"
#import "URLParameters.h"

#import "MapUtil.h"
#import "ViewUtil.h"

#import "GoogleAnalytics.h"
#import "GTMHTTPFetcherLogging.h"
//#import "GTLFlagengine.h"

@interface MapViewController ()

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation MapViewController{
    GMSMapView *mapView_;
    CLLocationManager *locationManager;
    CLLocation *location;
    BOOL isFirstLoad;
    FlagDataController *flagData;
    BOOL markerFirstTapped;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isFirstLoad = YES;
    flagData = [[FlagDataController alloc] init];
    
    markerFirstTapped = NO;
    
    [self initializeLocationManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Implementation
- (void)showCurrentLocation
{
    [locationManager startUpdatingLocation];
    NSLog(@"find current position");
}

#pragma mark - GMS Delegate

- (void)setMapViewWithCurrentLocation:(CLLocation *)currentLocation
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude zoom:ZOOM_LEVEL];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    [self findFlagNearbyWithCurrentLocatoin:currentLocation];
//    [self performSelectorInBackground:@selector(findFlagNearbyWithCurrentLocatoin:) withObject:currentLocation];
}

//- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
//{
//    CLLocation *changedLocation = [[CLLocation alloc] initWithLatitude:position.target.latitude longitude:position.target.longitude];
//    
//    if ([MapUtil isPositionOutOfBounderyAtPreviousPosition:location WithChangedPosition:changedLocation]) {
//        
//        location = changedLocation;
//        [self findFlagNearbyWithCurrentLocatoin:changedLocation];
//        
//    }
//    
//}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"tapped : %f, %f", coordinate.latitude, coordinate.longitude);
    
    if (mapView.selectedMarker != nil) {
        Flag *theFlag = (Flag *)mapView.selectedMarker.userData;
        mapView.selectedMarker.icon = [UIImage imageNamed:[MapUtil getMapMarkerImageFileNameWithCategory:theFlag.shopType status:BASE]];
        mapView.selectedMarker = nil;
        [self.delegate performSelector:@selector(mapViewController:unSelectMarker:) withObject:mapView];
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    // GAI event
    if (!markerFirstTapped) {
        [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"ui_delay" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:self.appDelegate.timeCriteria]] name:@"marker_click" label:nil] build]];
        markerFirstTapped = YES;
    }
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action" action:@"marker_click" label:@"inside_view" value:nil] build]];
    
    
    // check previous selected marker
    if (mapView.selectedMarker != nil) {
        Flag *theFlag = (Flag *)mapView.selectedMarker.userData;
        mapView.selectedMarker.icon = [UIImage imageNamed:[MapUtil getMapMarkerImageFileNameWithCategory:theFlag.shopType status:BASE]];
        mapView.selectedMarker = nil;
    }
    
    
    // show shop info and change marker
    Flag *selectedFlag = (Flag *)marker.userData;
    GMSCameraPosition *newCamera = [GMSCameraPosition cameraWithLatitude:marker.position.latitude longitude:marker.position.longitude zoom:ZOOM_LEVEL];
    
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
    CLLocation *changedLocation = [[CLLocation alloc] initWithLatitude:position.target.latitude longitude:position.target.longitude];

    if ([MapUtil isPositionOutOfBounderyAtPreviousPosition:location WithChangedPosition:changedLocation]) {

        location = changedLocation;
        [self findFlagNearbyWithCurrentLocatoin:changedLocation];
        
    }
}

#pragma mark - GTL
//- (GTLServiceFlagengine *)flagengineService
//{
//    static GTLServiceFlagengine *service = nil;
//    if(!service) {
//        service = [[GTLServiceFlagengine alloc] init];
//        service.retryEnabled = YES;
//        [GTMHTTPFetcher setLoggingEnabled:YES];
//    }
//
//    return service;
//}

#pragma mark - CLLocation
- (void)initializeLocationManager
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations objectAtIndex:0];
    
    if (!currentLocation){
        currentLocation = [[CLLocation alloc] initWithLatitude:BASE_LATITUDE longitude:BASE_LONGITUDE];
    }
    location = currentLocation;
//    [self.delegate performSelector:@selector(setCurrentLocation:) withObject:currentLocation];
    [self setMapViewWithCurrentLocation:currentLocation];
    isFirstLoad = NO;
    
//    if (isFirstLoad) {
//    }
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[latitude floatValue] longitude:[longitude floatValue] zoom:ZOOM_LEVEL_FOR_CURRENT_LOCATION];
//    [mapView_ animateToCameraPosition:camera];
//    self.view = mapView_;
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"fail");
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:BASE_LATITUDE longitude:BASE_LONGITUDE];
    
    if (isFirstLoad) {
        [self setMapViewWithCurrentLocation:currentLocation];
        isFirstLoad = NO;
    }
    
    [manager stopUpdatingLocation];
}

- (void)findFlagNearbyWithCurrentLocatoin:(CLLocation *)currentLocation
{
    NSDate *loadBeforeTime = [NSDate date];
    
    NSNumber *lat = [NSNumber numberWithFloat:currentLocation.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithFloat:currentLocation.coordinate.longitude];
    
    URLParameters *urlParam = [[URLParameters alloc] init];
    [urlParam setMethodName:@"flag"];
    [urlParam addParameterWithKey:@"lat" withParameter:[lat stringValue]];
    [urlParam addParameterWithKey:@"lon" withParameter:[lon stringValue]];
    [urlParam addParameterWithUserId:self.user.userId];
    NSURL *url = [urlParam getURLForRequest];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        NSDictionary *results = [FlagClient getURLResultWithURL:url];

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
            [self setFlagDataWithJsonData:results];
            
        }];
    }];
//    NSData *jsonDataString = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:Nil] dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:jsonDataString options:NSJSONReadingMutableContainers error:&error];
//    NSLog(@"data response result : %@", results);
    
    // GAI Data Load Time
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createTimingWithCategory:@"data_load" interval:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSinceDate:loadBeforeTime]] name:@"flag_list" label:nil] build]];

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
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([theFlag.lat floatValue], [theFlag.lon floatValue]);
            marker.icon = [UIImage imageNamed:[MapUtil getMapMarkerImageFileNameWithCategory:theFlag.shopType status:BASE]];
            marker.userData = theFlag;
            marker.map = mapView_;
        }

        [self.delegate performSelector:@selector(flagListOnMap:) withObject:flagData];
    }
}
@end