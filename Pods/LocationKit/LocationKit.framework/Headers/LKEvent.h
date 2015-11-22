//
// Created by Alex Nechaev on 7/22/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LKEvent : NSObject <NSCoding>

@property(nonatomic, strong) NSString *eventId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSDate *stopTime;
@property(nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong) NSString *addressId;
@property(nonatomic, strong) NSString *venueId;

@end