//
// Created by Alex Nechaev on 6/18/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LKUserValues : NSObject <NSCoding>

@property(nonatomic, strong) NSDictionary *dictionary;

- (id)initWithDictionary:(NSDictionary *)values filtered:(BOOL)filtered;

- (NSDictionary *)toDictionary;

+ (void)saveFailedUser:(LKUserValues *)values;

- (void)updateWithNewValues:(NSDictionary *)dictionary;

+ (void)saveSentUser:(LKUserValues *)values;

- (BOOL)isEqualToUserValues:(LKUserValues *)values;

+ (LKUserValues *)getFailedUser;

- (BOOL)hasInfo;

+ (LKUserValues *)getSavedUser;

- (BOOL)isValid;

+ (LKUserValues *)getCurrentStats;

+ (void)saveStats:(LKUserValues *)values;

+ (LKUserValues *)actualStatsValues;
@end