//
// Created by SocialRadar on 6/3/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LKVenue : NSObject <NSCoding>

@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *subcategory;

@end