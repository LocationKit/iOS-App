//
// Created by SocialRadar on 6/3/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LKVenue : NSObject <NSCoding>

/*
 * venueId
 *
 * Discussion:
 *     The unique venueId of this place in the SocialRadar backend.
 */
@property (nonatomic, strong) NSString *venueId;

/*
 * addressId
 *
 * Discussion:
 *     The unique addressId of this place in the SocialRadar backend.
 */
@property (nonatomic, strong) NSString *addressId;

/*
 * name
 *
 * Discussion:
 *     The name of this place. (e.g. "Capitol City Brewing Company")
 */
@property (nonatomic, strong) NSString *name;

/*
 * category
 *
 * Discussion:
 *     The category of this place. (e.g. "Bars and Nightlife")
 */
@property (nonatomic, strong) NSString *category;

/*
 * subcategory
 *
 * Discussion:
 *     The subcategory of this place (e.g. "Breweries")
 */
@property (nonatomic, strong) NSString *subcategory;

@end