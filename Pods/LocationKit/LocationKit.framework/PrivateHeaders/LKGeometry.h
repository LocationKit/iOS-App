//
// Created by SocialRadar on 6/3/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKGeometryShape;


@interface LKGeometry : NSObject <NSCoding>
@property (nonatomic, strong) NSString *geometryId;
@property (nonatomic, strong) NSString *geometryClass;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDictionary *geometry;
@property (nonatomic, strong) LKGeometryShape *geometryShape;
@property (nonatomic, assign) BOOL inside;
@property(nonatomic) NSUInteger dist;

- (LKGeometry *)initWithDictionary:(id)o;

@end