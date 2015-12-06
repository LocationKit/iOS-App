//
//  PKConstants.h
//  parkour
//
//  Created by Phillip, Anthony, Emily, Jeremy, Yonis and Randall on 11/2/15.
//  Trademark and Copyright © 2015 parkour method, inc. All rights reserved.
//  www.parkourmethod.com
//
//  Use of this SDK is authorized only upon your full acceptance of Parkour Method Inc.
//  license terms and privacy policies. License terms and privacy policies are subject to change
//  without prior notice.  For details contact team@parkourmethod.com or visit www.parkourmethod.com


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AdSupport/ASIdentifierManager.h>

#define aSDKVersion 2295


// For help and documentation: www.parkourmethod.com and docs.parkourmethod.com



typedef NS_ENUM(NSInteger, PKPositionType) {
    pkIndoors = 0,
    pkOutdoors,
    pkVerifiedIndoors
};

typedef NS_ENUM(NSInteger, PKMotionType) {
    pkNotMoving = 0,
    pkWalking,
    pkRunning,
    pkCycling,
    pkDriving,
    pkFlying
};

typedef NS_ENUM(NSInteger, PKPositionTrackingMode) {
    pkLowEnergy = 0,
    pkGeofencing,
    pkPedestrian,
    pkFitness,
    pkAutomotive,
    pkShare
};

