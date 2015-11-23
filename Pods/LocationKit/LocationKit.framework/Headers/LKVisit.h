//
// Created by SocialRadar on 6/9/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LKVisitFilter.h"
#import "LKPlacemark.h"

NS_ASSUME_NONNULL_BEGIN

@interface LKVisit : CLVisit <NSCoding>

/*
 *  arrivalDate
 *
 *  Discussion:
 *    The date when the visit began.  This may be equal to [NSDate
 *    distantPast] if the true arrival date isn't available.
 */
@property (nonatomic, readonly, copy) NSDate *arrivalDate;

/*
 *  departureDate
 *
 *  Discussion:
 *    The date when the visit ended.  This is equal to [NSDate
 *    distantFuture] if the device hasn't yet left.
 */
@property (nonatomic, readonly, copy) NSDate *departureDate;

/*
 *  coordinate
 *
 *  Discussion:
 *    The center of the region which the device is visiting.
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/*
 *
 *  horizontalAccuracy
 *
 *  Discussion:
 *    An estimate of the radius (in meters) of the region which the
 *    device is visiting.
 */
@property (nonatomic, readonly) CLLocationAccuracy horizontalAccuracy;

/*
 * filter
 *
 * Discussion:
 *     The filter that triggered this visit, if any. If you have no LKVisitFilter
 *     set, this will be nil for any visits. However, if you have one or more
 *     filters, this will contain a pointer to the filter which matched this visit
 */
@property (nonatomic, readonly, nullable) LKVisitFilter *filter;

/*
 * place
 *
 * Discussion:
 *     The placemark representing the location where this visit took place.
 */
@property (nonatomic, readonly) LKPlacemark *place;

@end

NS_ASSUME_NONNULL_END