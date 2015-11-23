//
// Created by an on 10/22/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "LKVisit.h"
#import "LKRegion.h"
#import "LKSearchRequest.h"
#import "LKSetting.h"
#import "LKVisitFilter.h"
#import "LKPerson.h"
#import "LKPlacemark.h"
#import "LKSearchRequest.h"
#import "LKSetting.h"
#import "LKVisit.h"

typedef NS_OPTIONS(NSUInteger, LKActivityMode) {
    LKActivityModeUnknown,
    LKActivityModeStationary,
    LKActivityModeWalking,
    LKActivityModeRunning,
    LKActivityModeCycling,
    LKActivityModeAutomotive
};

@protocol LKLocationManagerDelegate;

@interface LKLocationManager : CLLocationManager

/*
 * Since we inherit from CLLocationManager, LKLocationManager includes all
 *   of its methods as well. Check out the full docs here http://vq.io/1N23DAE
 */

/*
 * delegate
 *
 * Discussion:
 *     An object implementing he CLLocationManagerDelegate protocol. We highly suggest switching
 *     over to using advancedDelegate to get all of the power of LocationKit, though we will call
 *     the relevant methods in this delegate, if provided, with our enhanced features to the best
 *     of our ability though of course some fidelity will be lost.
 */
@property(assign, nonatomic, nullable) id<CLLocationManagerDelegate> delegate;

/*
 * advancedDelegate
 *
 * Discussion:
 *     LocationKit's replacement for the delegate, supply an advancedDelegate implementing the
 *     LKLocationManagerDelegateProtocol to have your delegate's methods called
 */
@property(assign, nonatomic, nullable) id<LKLocationManagerDelegate> advancedDelegate;
@property(nonatomic) BOOL isRunning;

/*
 * debug
 *
 * Discussion:
 *     Debug is a boolean value which tells LocationKit whether to log some pertinent updates
 *     to the console. Intended for development purposes only, we suggest setting this during
 *     development but not deploying production code with it enabled.
 */
@property(nonatomic) BOOL debug;

/*
 * deviceId
 *
 * Discussion:
 *     The unique identifier for this user's device. If your app is using the AdSupport natively we
 *     will use the advertising identifier (IDFA). If not, we will generate a random UUID, assign
 *     that to this device, and use it as long as they keep the app installed. If they re-install
 *     the app they will get a new deviceId (as the data store we write it to will be wiped on an
 *     app uninstall/install)
 */
@property(nonatomic, readonly) NSString* _Nullable deviceId;

/*
 * version
 *
 * Discussion:
 *     The currently running version of LocationKit. We follow strict semantic versioning.
 */
@property(nonatomic, readonly) NSString* _Nullable version;

/*
 * apiToken
 *
 * Discussion:
 *     Your app's API Token, assigned to you when you register on our Developer Dashboard at
 *     https://dashboard.locationkit.io
 *
 *     Required to run LocationKit
 */
@property(nonatomic, strong) NSString* _Nullable apiToken;

/*
 * locationUpdateInterval
 *
 * Discussion:
 *     If provided, location updates will be provided on an interval. Note, the smaller the
 *     interval, the more frequently your code will run and the more noticeable effect it will
 *     have on the battery life of the device so while we support an interval as small as 1
 *     second, we suggest keeping the interval at 1 minute or more.
 */
@property(nonatomic) NSTimeInterval locationUpdateInterval;

/*
 * whenInUseOnly
 *
 * Discussion:
 *     Whether or not to run LocationKit in "whenInUse" mode, basically a mode requiring only
 *     "whenInUse" permissions.
 *
 *     When this flag is enabled, LocationKit will prompt only for whenInUse privileges when
 *     it attempts to start monitoring the user's location. For ease and simplicity of most use
 *     cases, this value is disabled by default, so LocationKit will prompt for "always" location
 *     permissions by default.
 *
 *     Notes:
 *       (1) This must be called prior to starting location updates in order to be effective
 *       (2) This requires you to have the key `NSLocationWhenInUseUsageDescription` set in your
 *           Info.plist to the text you'll display describing your intent/rationale for wanting
 *           their location. Our default getting started guide only mentions the
 *           `NSLocationAlwaysUsageDescription` since that is the default for LocationKit.
 */
@property(nonatomic) BOOL whenInUseOnly;

/*
 * useCMMotionActivityManager
 *
 * Discussion:
 *     Whether or not to use the motion co-processor on board the device for the activity mode
 *     changes. Doing so will generally provide better battery life, but your users will have
 *     to respond to another iOS system dialog (requesting permission to have their activity data)
 *     if your app does not already have that permission.
 *
 *     Since most apps prefer not to have an additional iOS system prompt, this feature is disabled
 *     by default and must be enabled prior to starting Visit monitoring in order for it to be effective.
 */
@property(nonatomic) BOOL useCMMotionActivityManager;

/*
 * suppressLocationPermissionDialog
 *
 * Discussion:
 *     By default, LocationKit will automatically surface the iOS permissions dialog for location
 *     permissions. We do this to make it super easy for developers new to Location to get started
 *     and not have to deal with the complexities therein.
 *
 *     However, many developers have requested that they be able to suppress that dialog and display
 *     it on their own accord. So the default is that LocationKit will automatically surface the
 *     permission dialog, but you can override that behavior by enabling this property.
 *
 *     Note, you'll have to set this immediately after instantiating LKLocationManager prior to
 *     calling anything else that will start updating the location (e.g. `startUpdatingLocation` or
 *     `startMonitoringVisits` or `startMonitoringForRegion`) as they'll trigger the auto prompt so
 *     you'll need to set this before they do their thing.
 */
@property(nonatomic) BOOL suppressLocationPermissionDialog;

/*
 * requestPlace:
 *
 * Discussion:
 *     Request the device's current place. Your supplied handler will get called with the current
 */
- (void)requestPlace:(void (^ _Nonnull)(LKPlacemark* _Nullable place, NSError* _Nullable error))handler;

/*
 * requestLocation:
 *
 * Discussion:
 *     Request the device's current location. Your supplied handler will get called with the current
 *     location of the device once we can ascertain it.
 */
- (void)requestLocation:(void (^ _Nonnull)(CLLocation* _Nullable location, NSError* _Nullable error))handler;

/*
 * requestPeopleAtCurrentPlace
 *
 * Discussion:
 *     Request other users at the same place as this device.
 */
- (void)requestPeopleAtCurrentPlace:(void (^ _Nonnull)(NSArray<LKPerson *>* _Nullable people, LKVenue* _Nullable venue, NSError* _Nullable error))handler;

/*
 * requestPeopleNearby
 *
 * Discussion:
 *     Request other users nearby this device. Nearby is around a city block but its actual geographic
 *     size may vary based on how densely populated an area is and other factors.
 */
- (void)requestPeopleNearby:(void (^ _Nonnull)(NSArray<LKPerson *>* _Nullable people, NSError* _Nullable error))handler;

/*
 * searchForPlacesWithRequest
 *
 * Discussion:
 *     Build up a LKSearchRequest which represents a location-based search. LocationKit will
 *     automatically send along the current place of the device, find all places which match
 *     your search request around that device, and send them back.
 */
- (void)searchForPlacesWithRequest:(LKSearchRequest* _Nonnull)request completionHandler:(void (^ _Nonnull)(NSArray<LKPlacemark *>* _Nullable places, NSError* _Nullable error))handler;

/*
 * requestPlaceForLocation
 *
 * Discussion:
 *     Request the LKPlacemark for an arbitrary location of your choosing. Essentially beefed up reverse
 *     geocoding into which you supply an arbitrary location (as a CLLocation object) and we will match
 *     that location with everything we know about it in the proprietary LocationKit database, including
 *     the address, any venues at that location, events happening at that location, and so on.
 */
- (void)requestPlaceForLocation:(CLLocation* _Nonnull)location completionHandler:(void (^ _Nonnull)(LKPlacemark* _Nullable place, NSError* _Nullable error))handler;

/*
 * requestPriorVisits
 *
 * Discussion:
 *     Request past visits by this user. These visits are stored and retrieved seamlessly from the
 *     LocationKit backend and deserialized into LKVisit objects for you.
 */
- (void)requestPriorVisits:(void (^ _Nonnull)(NSArray<LKVisit *>* _Nullable visits, NSError* _Nullable error))handler;

/*
 * requestHomeAddress
 *
 * Discussion:
 *     Based on the visit history of this device, LocationKit can analyze that visit history and
 *     provide a pretty good guess at this device user's home address. Note, it can take some time
 *     to gather enough history to be able to reasonably know the user's address so this may be
 *     nil for some time. And even beyond that it is just a best guess. So if your user happened
 *     to be on vacation for a week when they install your app, this method may report their hotel
 *     as their home address. Only once they return home and gather enough data to indicate that
 *     their actual home is their home will we start reporting that as their home, so this value
 *     is not guaranteed to be static either.
 */
- (void)requestHomeAddress:(void (^ _Nonnull)(LKPlacemark* _Nullable, NSError* _Nullable))handler;

/*
 * requestWorkAddress
 *
 * Discussion:
 *     Based on the visit history of this device, LocationKit can analyze that visit history and
 *     provide a pretty good guess at this device user's work address. Just as with
 *     requestHomeAddress, this method will also have to gather a decent sample of data before it
 *     can take a reasonable guess at a work address so it may be nil for some time
 */
- (void)requestWorkAddress:(void (^ _Nonnull)(LKPlacemark* _Nullable, NSError* _Nullable))handler;

/*
 * startMonitoringVisits
 *
 * Discussion:
 *     By default, visit detection is disabled for optimal battery life. To enable it, call this
 *     method and not only will LocationKit go into a mode optimized for best battery life with
 *     maximum visit detection accuracy, but your LKLocationManagerDelegate methods `didStartVisit`
 *     and `didEndVisit` will get called whenever a visit is started or ended.
 */
- (void)startMonitoringVisits;

/*
 * stopMonitoringVisits
 *
 * Discussion:
 *     By default, visit detection is disabled for optimal battery life. To disable it once it has
 *     been enabled, call this method and LocationKit will stop monitoring for visits and go back
 *     to the settings it had prior to starting visit monitoring.
 */
- (void)stopMonitoringVisits;
- (void)startMonitoringVisitsWithFilter:(LKVisitFilter* _Nonnull)filter;
- (void)stopMonitoringVisitsWithFilter:(LKVisitFilter* _Nonnull)filter;

- (void)startMonitoringForRegion:(CLRegion* _Nonnull)region;
- (void)stopMonitoringForRegion:(CLRegion* _Nonnull)region;




/*
 *  updateUserValues:
 *
 *  Discussion:
 *      Update user values. Use LKUserValue constants as dictionary keys. These values are all
 *      optional but can be used for segmenting your data on the LocationKit dashboard, for
 *      matching your users against your own database via the LocationKit REST API or via a data
 *      export, and so on.
 */
- (void)setUserValues:(NSDictionary* _Nonnull)userValues;

/*
 * optOut
 *
 * Discussion:
 *     Opt this user out of data sharing. Calling this will result in all of this user's data
 *     being deleted in the LocationKit backend for all analytics, visit history, people nearby,
 *     and any other place this particular device has data.
 */
- (void)optOut:(void (^ _Nonnull)(NSError* _Nullable))handler;

- (void)setOperationMode:(LKSetting* _Nonnull)setting;

- (void)pause;

- (NSError* _Nullable)resume;


@end

NS_ASSUME_NONNULL_BEGIN

@protocol LKLocationManagerDelegate <NSObject>

@optional

// Methods for parity with CLLocationManagerDelegate
- (void)locationManager:(LKLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations  __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0);

- (void)locationManager:(LKLocationManager *)manager didFailWithError:(NSError *)error;
- (void)locationManager:(LKLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error;

- (void)locationManagerDidPauseLocationUpdates:(LKLocationManager *)manager;
- (void)locationManagerDidResumeLocationUpdates:(LKLocationManager *)manager;

- (void)locationManager:(LKLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading;
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(LKLocationManager *)manager;

- (void)locationManager:(LKLocationManager *)manager didEnterRegion:(CLRegion *)region;
- (void)locationManager:(LKLocationManager *)manager didExitRegion:(CLRegion *)region;
- (void)locationManager:(LKLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region;
- (void)locationManager:(LKLocationManager *)manager monitoringDidFailForRegion:(nullable CLRegion *)region withError:(NSError *)error;
- (void)locationManager:(LKLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region;

- (void)locationManager:(LKLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region;
- (void)locationManager:(LKLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error;

- (void)locationManager:(LKLocationManager *)manager didVisit:(CLVisit *)visit;

- (void)locationManager:(LKLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;

// LocationKitCore additions
- (void)locationManager:(LKLocationManager *)manager didStartVisit:(LKVisit *)visit;
- (void)locationManager:(LKLocationManager *)manager didEndVisit:(LKVisit *)visit;
- (void)locationManager:(LKLocationManager *)manager willChangeActivityMode:(LKActivityMode)mode;
- (void)locationManager:(LKLocationManager *)manager changeRegion:(NSString *)obj;




@end

NS_ASSUME_NONNULL_END
