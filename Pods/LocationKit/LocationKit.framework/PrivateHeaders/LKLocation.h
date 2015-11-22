//
// Created by John Fontaine on 6/2/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface LKLocation : NSObject <NSCoding>

@property(nonatomic, copy) CLLocation *location;
@property(nonatomic, assign) double x;
@property(nonatomic, assign) double y;
@property(nonatomic, assign) double z;
@property(nonatomic, assign) double latRadians;
@property(nonatomic, assign) double lngRadians;
@property(nonatomic, assign) BOOL isVenueCoordinate;

- (instancetype)initWithLocation:(CLLocation *)location;

- (instancetype)initWithX:(double)x y:(double)y z:(double)z timestamp:(NSDate *)timestamp altitude:(CLLocationDistance)altitude course:(CLLocationDirection)course speed:(CLLocationSpeed)speed  accuracy:(CLLocationAccuracy)horizontalAccuracy;

+ (instancetype)locationWithX:(double)x y:(double)y z:(double)z timestamp:(NSDate *)timestamp altitude:(CLLocationDistance)altitude course:(CLLocationDirection)course speed:(CLLocationSpeed)speed accuracy:(CLLocationAccuracy)horizontalAccuracy;


+ (instancetype)locationWithLocation:(CLLocation *)location;

- (CLLocationDistance)distanceFromLocation:(CLLocation *)otherLocation;

@end