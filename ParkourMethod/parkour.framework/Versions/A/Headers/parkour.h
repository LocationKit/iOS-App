//
//  parkour.h
//  parkour
//
//  Created by Phillip, Anthony, Emily, Jeremy, Yonis and Randall on 11/2/15.
//  Trademark and Copyright © 2015 parkour method, inc. All rights reserved.
//  www.parkourmethod.com
//
//  Use of this SDK is authorized only upon your full acceptance of Parkour Method Inc.
//  license terms and privacy policies. License terms and privacy policies are subject to change
//  without prior notice.  For details contact team@parkourmethod.com or visit www.parkourmethod.com


#import "PKConstants.h"
#define theParkourSDKVersion 2295

// For help and documentation: www.parkourmethod.com and docs.parkourmethod.com


@interface parkour : NSObject


//
// start the parkour location engine in uber low power consumption mode.
// usage: [parkour start];
///
///
+ (void)start;

//
// Track a user's latitude/longitude and describe the current motion and position type
// usage:  [parkour trackPositionWithHandler:^(CLLocation *location, PKPositionType positionType, PKMotionType motionType) { ... }
+ (void)trackPositionWithHandler:(void (^)(CLLocation *position, PKPositionType positionType, PKMotionType motionType))handler;

//
// stop receiving location updates from parkour and return sdk to uber low battery consumption mode.
// usage: [parkour stopTrackPosition];
+ (void)stopTrackPosition;

//
// track and receive nearest Point of Interest (venues, major points of interest, etc.)
// this method only returns when the equivalent of a VerifiedIndoors is detected (min. of 100 seconds at a venue)
// *** note: it's not necessary to activate trackPositionwithHandler: to receive POI updates
+ (void)trackPOIWithHandler:(void (^)(NSString *POIName, NSString *categoryOne, NSString *categoryTwo, NSString *fullAddress, NSString *city, NSString *state, NSString *zipcode, CLLocation *POIPosition, CLLocation *userPosition, double distance))handler;

//
// stop receiving POI visit updates from parkour and return sdk to uber low battery consumption mode.
// usage: [parkour stopTrackPOI];
+ (void)stopTrackPOI;

//
// Tune the location output quality and frequency for specific activities. Higher activity modes will
// increase accuracy and slightly increase the battery consumption.
// Higher activity modes increase location accuracy at a nominal increase in battery consumption.
// locationMode settings: 0= default/lowest power; 1= geofencing; 2= pedestrian; 3= fitness/cycling; 4= automotive navigation;
// 5 = Sharing (for location sharing every 45 seconds without substantially increasing energy consumption)
// *** note: trackPositionWithHandler must be activated prior to using this call.
// see PKConstansts.h for available PKMode constants
// usage: [parkour setMode:Fitness];
+ (void)setTrackPositionMode:(PKPositionTrackingMode)locationMode;

//
// Set the maximum number of seconds before guaranteeing a location point to be returned to
// trackPositionWithHandler. A low maximum update rate may return the same position data until the
// the actual device position changes, but will increase the battery consumption rate.
// Zero for either value disables this function and returns the SDK to uber low energy consumption mode.
// usage: [parkour setInterval:300 distance:20];
+ (void)setInterval:(int)seconds;

//
// stop all parkour background and foreground operations. must use [start] to restart parkour. not required unless you wish
// to force parkour to force stop; parkour will naturally go into ultra low power mode while app is in background, so
// this call is not required.
// usage: [parkour stop];
+ (void)stop;


@end