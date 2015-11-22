//
// Created by SocialRadar on 8/5/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LKSettingType) {
    LKSettingTypeAuto,
    LKSettingTypeLow,
    LKSettingTypeMedium,
    LKSettingTypeHigh
};

@interface LKSetting : NSObject

@property(nonatomic) CLLocationAccuracy desiredAccuracy;
@property(nonatomic) double distanceFilter;
@property(nonatomic, readonly) LKSettingType type;

- (instancetype)initWithType:(LKSettingType)type;

@end