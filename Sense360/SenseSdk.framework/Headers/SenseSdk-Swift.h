// Generated by Apple Swift version 2.1 (swiftlang-700.1.101.6 clang-700.1.76)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
#endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
#if defined(__has_feature) && __has_feature(modules)
@import CoreLocation;
@import ObjectiveC;
@import Foundation;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
typedef SWIFT_ENUM(NSInteger, ActivityType) {
  ActivityTypeAutomotive = 1,
  ActivityTypeCycling = 2,
  ActivityTypeRunning = 3,
  ActivityTypeStationary = 4,
  ActivityTypeWalking = 5,
  ActivityTypeUnknown = 6,
};


@interface CLLocation (SWIFT_EXTENSION(SenseSdk))
@end


SWIFT_CLASS("_TtC8SenseSdk18ConditionalElement")
@interface ConditionalElement : NSObject
@end

typedef SWIFT_ENUM(NSInteger, ConfidenceLevel) {
  ConfidenceLevelHigh = 3,
  ConfidenceLevelMedium = 2,
  ConfidenceLevelLow = 1,
  ConfidenceLevelUndetermined = 0,
};

enum CooldownTimeUnit : NSInteger;
@class SenseSdkErrorPointer;

SWIFT_CLASS("_TtC8SenseSdk8Cooldown")
@interface Cooldown : ConditionalElement
+ (Cooldown * __nonnull)defaultCooldown;
+ (Cooldown * __nullable)createWithOncePer:(NSInteger)oncePer frequency:(enum CooldownTimeUnit)frequency errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
@end

typedef SWIFT_ENUM(NSInteger, CooldownTimeUnit) {
  CooldownTimeUnitTesting = 0,
  CooldownTimeUnitMinutes = 60,
  CooldownTimeUnitHours = 3600,
  CooldownTimeUnitDays = 86400,
};

@class Location;
@class NSMutableDictionary;
enum PlaceType : NSInteger;
@protocol Region;

SWIFT_PROTOCOL("_TtP8SenseSdk5Place_")
@protocol Place <NSObject, NSCoding>
@property (nonatomic, readonly, strong) Location * __nonnull location;
@property (nonatomic, readonly) double radius;
@property (nonatomic, readonly, strong) NSMutableDictionary * __nonnull details;
@property (nonatomic, readonly, copy) NSString * __nonnull description;
@property (nonatomic, readonly) enum PlaceType type;
- (id <Region> __nonnull)getRegion;
@end

@class NSCoder;

SWIFT_CLASS("_TtC8SenseSdk14CustomGeofence")
@interface CustomGeofence : NSObject <NSCoding, Place>
@property (nonatomic, readonly, strong) Location * __nonnull location;
@property (nonatomic, readonly) double radius;
@property (nonatomic, readonly, copy) NSString * __nonnull customIdentifier;
@property (nonatomic, readonly) enum PlaceType type;
@property (nonatomic, readonly, strong) NSMutableDictionary * __nonnull details;
@property (nonatomic, readonly, copy) NSString * __nonnull description;
- (nonnull instancetype)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(double)radius customIdentifier:(NSString * __nonnull)customIdentifier;
- (nonnull instancetype)initWithLocation:(Location * __nonnull)location radius:(double)radius customIdentifier:(NSString * __nonnull)customIdentifier OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * __nonnull)acoder;
- (id <Region> __nonnull)getRegion;
@end


SWIFT_CLASS("_TtC8SenseSdk21CustomGeofenceTrigger")
@interface CustomGeofenceTrigger : NSObject
@property (nonatomic, readonly, copy) NSString * __nonnull description;
@end

enum PoiType : NSInteger;
@class Trigger;
enum PersonalizedPlaceType : NSInteger;
@class NSNumber;

SWIFT_CLASS("_TtC8SenseSdk11FireTrigger")
@interface FireTrigger : NSObject
+ (Trigger * __nullable)whenEntersPoi:(NSString * __nonnull)triggerName type:(enum PoiType)type conditions:(NSArray<ConditionalElement *> * __nullable)conditions errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
+ (Trigger * __nullable)whenExitsPoi:(NSString * __nonnull)triggerName type:(enum PoiType)type conditions:(NSArray<ConditionalElement *> * __nullable)conditions errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
+ (Trigger * __nullable)whenEntersPersonalizedPlace:(NSString * __nonnull)triggerName type:(enum PersonalizedPlaceType)type conditions:(NSArray<ConditionalElement *> * __nullable)conditions errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
+ (Trigger * __nullable)whenExitsPersonalizedPlace:(NSString * __nonnull)triggerName type:(enum PersonalizedPlaceType)type kilometers:(NSNumber * __nullable)kilometers conditions:(NSArray<ConditionalElement *> * __nonnull)conditions errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
+ (Trigger * __nullable)whenEntersGeofences:(NSString * __nonnull)triggerName geofences:(NSArray<CustomGeofence *> * __nonnull)geofences conditions:(NSArray<ConditionalElement *> * __nullable)conditions errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
+ (Trigger * __nullable)whenExitsGeofences:(NSString * __nonnull)triggerName geofences:(NSArray<CustomGeofence *> * __nonnull)geofences kilometers:(NSNumber * __nullable)kilometers conditions:(NSArray<ConditionalElement *> * __nullable)conditions errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8SenseSdk8Location")
@interface Location : NSObject
@property (nonatomic, readonly) CLLocationDegrees latitude;
@property (nonatomic, readonly) CLLocationDegrees longitude;
- (nonnull instancetype)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithLocation:(CLLocation * __nonnull)location OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * __nonnull)acoder;
- (CLLocationDistance)distanceFromLocation:(Location * __nonnull)loc;
- (CLLocationCoordinate2D)toCoordinate;
@property (nonatomic, readonly, copy) NSString * __nonnull description;
- (CLLocationDistance)getDistance:(Location * __nonnull)other;
- (Location * __nonnull)addMetersToLatitude:(CLLocationDistance)distance;
- (Location * __nullable)getClosestLatLng:(NSArray<Location *> * __nonnull)list;
@end


@interface NSArray (SWIFT_EXTENSION(SenseSdk))
@end


@interface NSDate (SWIFT_EXTENSION(SenseSdk))
@end


@interface NSFileManager (SWIFT_EXTENSION(SenseSdk))
@end


@interface NSNumber (SWIFT_EXTENSION(SenseSdk))
@end


@interface NSUserDefaults (SWIFT_EXTENSION(SenseSdk))
@end


SWIFT_CLASS("_TtC8SenseSdk17PersonalizedPlace")
@interface PersonalizedPlace : NSObject <NSCoding, Place>
@property (nonatomic, readonly, strong) Location * __nonnull location;
@property (nonatomic, readonly) double radius;
@property (nonatomic, readonly) enum PersonalizedPlaceType personalizedPlaceType;
@property (nonatomic, readonly) enum PlaceType type;
@property (nonatomic, readonly, strong) NSMutableDictionary * __nonnull details;
@property (nonatomic, readonly, copy) NSString * __nonnull description;
+ (NSString * __nonnull)getDescriptionOfPersonalizedPlaceType:(NSInteger)type;
- (nonnull instancetype)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(double)radius personalizedPlaceType:(enum PersonalizedPlaceType)personalizedPlaceType;
- (nonnull instancetype)initWithLocation:(Location * __nonnull)location radius:(double)radius personalizedPlaceType:(enum PersonalizedPlaceType)personalizedPlaceType OBJC_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * __nonnull)acoder;
- (id <Region> __nonnull)getRegion;
@end


SWIFT_CLASS("_TtC8SenseSdk24PersonalizedPlaceTrigger")
@interface PersonalizedPlaceTrigger : NSObject
@property (nonatomic, readonly, copy) NSString * __nonnull description;
@end

typedef SWIFT_ENUM(NSInteger, PersonalizedPlaceType) {
  PersonalizedPlaceTypeHome = 1,
  PersonalizedPlaceTypeWork = 2,
};


typedef SWIFT_ENUM(NSInteger, PlaceType) {
  PlaceTypePersonal = 1,
  PlaceTypeCustomGeofence = 2,
  PlaceTypePoi = 3,
};


SWIFT_CLASS("_TtC8SenseSdk8PoiPlace")
@interface PoiPlace : NSObject <NSCoding, Place>
@property (nonatomic, readonly, copy) NSString * __nonnull id;
@property (nonatomic, readonly, strong) Location * __nonnull location;
@property (nonatomic, readonly) double radius;
@property (nonatomic, readonly) enum PlaceType type;
@property (nonatomic, readonly, strong) NSMutableDictionary * __nonnull details;
@property (nonatomic, readonly, copy) NSString * __nonnull description;
- (nonnull instancetype)initWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude radius:(CLLocationDistance)radius name:(NSString * __nonnull)name id:(NSString * __nonnull)id type:(enum PoiType)type;
- (NSArray * __nonnull)getTypes;
- (CLLocationDistance)distanceFrom:(Location * __nonnull)other;
- (nullable instancetype)initWithCoder:(NSCoder * __nonnull)aDecoder;
- (void)encodeWithCoder:(NSCoder * __nonnull)acoder;
- (id <Region> __nonnull)getRegion;
@end


SWIFT_CLASS("_TtC8SenseSdk10PoiTrigger")
@interface PoiTrigger : NSObject
@property (nonatomic, readonly, copy) NSString * __nonnull description;
@end

typedef SWIFT_ENUM(NSInteger, PoiType) {
  PoiTypeAll = -1,
  PoiTypeAirport = 1,
  PoiTypeBar = 2,
  PoiTypeRestaurant = 3,
  PoiTypeMall = 4,
  PoiTypeCafe = 5,
  PoiTypeGym = 6,
  PoiTypeLodging = 7,
  PoiTypePoliceDepartment = 8,
  PoiTypeBusStation = 9,
  PoiTypeDepartmentStore = 10,
  PoiTypeFireStation = 11,
  PoiTypeStadium = 12,
  PoiTypeHospital = 13,
  PoiTypeParking = 14,
  PoiTypeNightClub = 15,
  PoiTypeUniversity = 16,
  PoiTypeMovieTheater = 17,
  PoiTypeSupermarket = 18,
};


SWIFT_PROTOCOL("_TtP8SenseSdk6Region_")
@protocol Region
- (BOOL)overlaps:(Location * __nonnull)otherLocation;
- (id <Region> __nonnull)addRadiusWithRadius:(NSNumber * __nonnull)radius;
@end

@protocol TriggerFiredDelegate;

SWIFT_CLASS("_TtC8SenseSdk8SenseSdk")
@interface SenseSdk : NSObject
+ (void)enableSdkWithKey:(NSString * __nonnull)apiKey;
+ (void)unregisterAll;
+ (BOOL)registerWithTrigger:(Trigger * __nonnull)trigger delegate:(id <TriggerFiredDelegate> __nonnull)delegate errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
+ (BOOL)unregisterWithName:(NSString * __nonnull)name;
+ (Trigger * __nullable)findTriggerWithName:(NSString * __nonnull)name;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8SenseSdk13SenseSdkError")
@interface SenseSdkError : NSObject
@property (nonatomic, readonly, copy) NSString * __nonnull message;
@end


SWIFT_CLASS("_TtC8SenseSdk20SenseSdkErrorPointer")
@interface SenseSdkErrorPointer : NSObject
@property (nonatomic, readonly, strong) SenseSdkError * __null_unspecified error;
+ (SenseSdkErrorPointer * __nonnull)create;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8SenseSdk19SenseSdkTestUtility")
@interface SenseSdkTestUtility : NSObject
+ (BOOL)fireTrigger:(NSString * __nonnull)name confidenceLevel:(enum ConfidenceLevel)confidenceLevel places:(NSArray<id <Place>> * __nonnull)places errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8SenseSdk10TimeWindow")
@interface TimeWindow : ConditionalElement
@property (nonatomic, readonly) NSInteger from;
@property (nonatomic, readonly) NSInteger to;

/// Default window of the entire day
+ (TimeWindow * __nonnull)allDay;
+ (TimeWindow * __nullable)createFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
@end

typedef SWIFT_ENUM(NSInteger, TransitionType) {
  TransitionTypeEnter = 1,
  TransitionTypeExit = 2,
};

enum TriggerType : NSInteger;

SWIFT_CLASS("_TtC8SenseSdk7Trigger")
@interface Trigger : NSObject
@property (nonatomic, readonly, copy) NSString * __nonnull name;
@property (nonatomic, readonly) enum TransitionType transitionType;
@property (nonatomic, readonly) enum TriggerType triggerType;
@end


SWIFT_CLASS("_TtC8SenseSdk16TriggerFiredArgs")
@interface TriggerFiredArgs : NSObject
@property (nonatomic, readonly, strong) NSDate * __nonnull timestamp;
@property (nonatomic, readonly, strong) Trigger * __nonnull trigger;
@property (nonatomic, readonly, copy) NSArray<id <Place>> * __nonnull places;
@property (nonatomic, readonly) enum ConfidenceLevel confidenceLevel;
@end


SWIFT_PROTOCOL("_TtP8SenseSdk20TriggerFiredDelegate_")
@protocol TriggerFiredDelegate
- (void)triggerFired:(TriggerFiredArgs * __nonnull)args;
@end

typedef SWIFT_ENUM(NSInteger, TriggerType) {
  TriggerTypePersonal = 1,
  TriggerTypeCustomGeofence = 2,
  TriggerTypePoi = 3,
};


@interface UIDevice (SWIFT_EXTENSION(SenseSdk))
@end


SWIFT_CLASS("_TtC8SenseSdk13UsersActivity")
@interface UsersActivity : NSObject
+ (ConditionalElement * __nullable)arrivedBy:(enum ActivityType)type errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
+ (ConditionalElement * __nullable)departedBy:(enum ActivityType)type errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


SWIFT_CLASS("_TtC8SenseSdk13UsersLocation")
@interface UsersLocation : NSObject
+ (ConditionalElement * __nullable)isFartherThanPersonalizedPlace:(enum PersonalizedPlaceType)type kilometers:(NSNumber * __nonnull)kilometers errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
+ (ConditionalElement * __nullable)isFartherThanGeofences:(NSArray<CustomGeofence *> * __nonnull)geofences kilometers:(NSNumber * __nonnull)kilometers errorPtr:(SenseSdkErrorPointer * __nullable)errorPtr;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop