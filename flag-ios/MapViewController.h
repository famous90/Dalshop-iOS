//
//  MapViewController.h
//  flag-ios
//
//  Created by Gyuyoung Hwang on 2014. 2. 5..
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

#import "GTMHTTPFetcherLogging.h"
//#import "GTLFlagengine.h"

@class GMSMarker;
@class MapViewController;
@class Flag;
@class FlagDataController;

@protocol MapViewControllerDelegate <NSObject>

- (void)mapViewController:(MapViewController *)mapViewController didSelectMarker:(GMSMarker *)marker;
- (void)mapViewController:(MapViewController *)mapViewController unSelectMarker:(GMSMarker *)marker;
- (void)flagListOnMap:(FlagDataController *)flagDataController;
//- (void)setCurrentLocation:(CLLocation *)location;

@end

@interface MapViewController : UIViewController<GMSMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, weak) id<MapViewControllerDelegate> delegate;

@property (nonatomic, strong) User *user;

- (void)showCurrentLocation;
//- (GTLServiceFlagengine *)flagengineService;
@end
