//
// Created by SocialRadar on 8/18/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface LKVisitFilter : NSObject<NSCoding>


@property(nonatomic, copy) NSString *venueCategory;
@property(nonatomic, copy) NSString *venueName;
@property(nonatomic, copy) NSString *addressId;

+ (LKVisitFilter *)anyVenue;
+ (BOOL)hasAnyValue:(NSArray *)array;

-(LKVisitFilter *)initWithVenueName:(NSString *)venueName venueCategory:(NSString *)venueCategory;
-(LKVisitFilter *)initWithVenueCategory:(NSString *)venueCategory venueName:(NSString *)venueName;
-(LKVisitFilter *)initWithVenueName:(NSString *)venueName;
-(LKVisitFilter *)initWithVenueCategory:(NSString *)venueCategory;

- (id)initWithJson:(NSDictionary *)dictionary;
@end