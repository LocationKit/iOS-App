//
// Created by SocialRadar on 6/3/15.
// Copyright (c) 2015 SocialRadar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LKVenue.h"
#import "LKEvent.h"

@interface LKPlacemark : NSObject <NSCoding>

// Properties "inherited" from CLPlacemark
// These methods and properties are copied here in comment only for convenience. Full documentation on CLPlacemark
//   can be viewed here: http://vq.io/1IdunLv

// Note, we can't actually inherit from CLPlacemark due to a bug where any subclass will throw
//   an EXC_BAD_ACCESS and crash the app during the CLPlacemark's dealloc method. It appears
//   Apple is calling some private APIs in it which no inherited object will have access to causing
//   an app crash. Since of course that isn't acceptable but we want to get as close as possible
//   to emulating Apple's object, we are making our own with all the same named attributes.

/*
 * initWithPlacemark:
 *
 * Discussion:
 *   Initialize a newly allocated placemark from another placemark, copying its data.
 */
- (id _Nonnull)initWithPlacemark:(CLPlacemark * _Nonnull)placemark;

/*
 *  location
 *
 *  Discussion:
 *    Returns the geographic location associated with the placemark.
 */
@property (nonatomic, readonly, copy, nullable) CLLocation *location;

/*
 *  region
 *
 *  Discussion:
 *    Returns the geographic region associated with the placemark.
 */
@property (nonatomic, readonly, copy, nullable) CLRegion *region;

/*
 *  timeZone
 *
 *  Discussion:
 *		Returns the time zone associated with the placemark.
 */
@property (nonatomic, readonly, copy, nullable) NSTimeZone *timeZone NS_AVAILABLE(10_11,9_0);

/*
 *  addressDictionary
 *
 *  Discussion:
 *    This dictionary can be formatted as an address using ABCreateStringWithAddressDictionary,
 *    defined in the AddressBookUI framework.
 */
@property (nonatomic, readonly, copy, nullable) NSDictionary *addressDictionary;

// address dictionary properties
@property (nonatomic, readonly, copy, nullable) NSString *name; // eg. Apple Inc.
@property (nonatomic, readonly, copy, nullable) NSString *thoroughfare; // street name, eg. Infinite Loop
@property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare; // eg. 1
@property (nonatomic, readonly, copy, nullable) NSString *locality; // city, eg. Cupertino
@property (nonatomic, readonly, copy, nullable) NSString *subLocality; // neighborhood, common name, eg. Mission District
@property (nonatomic, readonly, copy, nullable) NSString *administrativeArea; // state, eg. CA
@property (nonatomic, readonly, copy, nullable) NSString *subAdministrativeArea; // county, eg. Santa Clara
@property (nonatomic, readonly, copy, nullable) NSString *postalCode; // zip code, eg. 95014
@property (nonatomic, readonly, copy, nullable) NSString *ISOcountryCode; // eg. US
@property (nonatomic, readonly, copy, nullable) NSString *country; // eg. United States
@property (nonatomic, readonly, copy, nullable) NSString *inlandWater; // eg. Lake Tahoe
@property (nonatomic, readonly, copy, nullable) NSString *ocean; // eg. Pacific Ocean
@property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *areasOfInterest; // eg. Golden Gate Park

// LocationKit Additions to CLPlacemark

/*
 * addressId
 *
 * Discussion:
 *     Each placemark has an address with a unique id associated with it.
 */
@property(nonatomic, readonly, copy, nullable) NSString *addressId;

/*
 * geometryId
 *
 * Discussion:
 *     Each placemark has a geometry id with a unique id associated with it.
 */
@property(nonatomic, readonly, copy, nullable) NSString *geometryId;

/*
 * venue
 *
 * Discussion:
 *     The venue associated with this placemark, if any. For private residences this will be nil, but
 *     for any place with a "venue" (restaurant, bar, museum, monument, park, etc.) this will be non-nil
 */
@property(nonatomic, readonly, strong, nullable) LKVenue *venue;

/*
 * events
 *
 * Discussion:
 *     The events taking place at this placemark, if any. This will only contain events that are currently
 *     happening, so even a place you may expect to have an event (e.g. Carnegie Hall) may not have an event
 *     at say 8am.
 */
@property(nonatomic, readonly, strong, nullable) NSArray<LKEvent *> *events;

/*
 * alternatives
 *
 * Discussion:
 *     We will do our best with LocationKit to figure out where your user is and supply it to you.
 *     However, since the GPS and location on the device is limited, our results are not infallible
 *     so we supply these alternatives which are the most likely placemarks your user may be if our
 *     primary guess is not quite correct.
 */
@property(nonatomic, readonly, strong, nullable) NSArray<LKPlacemark *> *alternatives;

/*
 * locationKitEntrance
 *
 * Discussion:
 *     Which internal process we used as the source of this venue detection -- from our
 *     proprietary entrance and storefront database, from our building polygons and parcel
 *     polygons, or from some third-party source. For diagnostic purposes only.
 */
@property(nonatomic, readonly, strong, nullable) NSString *locationKitEntranceSource;

@end