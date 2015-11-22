//
// Created by John Fontaine on 6/22/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class LKLocation;

@interface LKGeometryShape : NSObject <NSCopying, NSCoding>

@property (strong, nonatomic,readwrite) NSString *type;
@property (strong, nonatomic,readwrite) NSArray *coordinates;
-(bool)containsLocation:(LKLocation *)lkLocation;
-(double)distanceTo:(LKLocation *)lkLocation;

- (id)initWithCoder:(NSCoder *)coder;
- (instancetype)initWithShapeJSON:(NSDictionary *)shapeJSON;
- (NSArray *)parseCoordinates:(NSDictionary *)shapeJSON;
- (void)encodeWithCoder:(NSCoder *)coder;
@end