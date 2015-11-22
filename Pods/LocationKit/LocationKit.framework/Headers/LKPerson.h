//
// Created by SocialRadar on 7/21/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


typedef struct {
    double distance;
    double bearing;
} LKRelativeLocation;

@interface LKPerson : NSObject<NSCoding>

@property(nonatomic, copy) NSString *deviceId;
@property(nonatomic, copy) NSString *venueId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *personId;
@property(nonatomic) CLLocationCoordinate2D location;
@property(nonatomic) LKRelativeLocation relativeLocation;

@end