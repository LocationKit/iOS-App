//
// Created by SocialRadar on 6/3/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>


@interface LKRegion : CLRegion

@property(nonatomic, strong) NSString *venueName;
@property(nonatomic, strong) NSString *venueCategory;
@property (readonly, nonatomic) CLLocationDistance radius;
@property (readonly, nonatomic, copy) NSString *identifier __OSX_AVAILABLE_STARTING(__MAC_10_7,__IPHONE_4_0);

-(LKRegion *)initWithRadius:(CLLocationDistance)radius identifier:(NSString *)identifier venueName:(NSString *)venueName venueCategory:(NSString *)venueCategory;

- (id)initWithJson:(NSDictionary *)dictionary;

@end