//
// Created by SocialRadar on 6/9/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKVisitFilter.h"
#import "LKPlacemark.h"

@interface LKVisit : CLVisit <NSCoding>


@property (nonatomic, strong) LKVisitFilter *criteria;
@property (nonatomic, strong) LKPlacemark *place;

@end