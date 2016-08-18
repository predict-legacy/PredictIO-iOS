//
//  PredictIO.h
//  predict.io-sdk
//
//  Created by Zee on 28/02/2013.
//  Copyright (c) 2016 predict.io by ParkTAG GmbH. All rights reserved.
//  Version 3.0

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*
 * PredictIOStatus
 * Discussion: Represents the current predict.io state.
 */
typedef NS_ENUM(int, PredictIOStatus) {
    // predict.io is in a working/active state
    PredictIOStatusActive = 0,

    // predict.io not in a working state as the location services are disabled
    PredictIOStatusLocationServicesDisabled,

    // predict.io has not been authorized by user to use location services at any time (kCLAuthorizationStatusAuthorizedAlways)
    PredictIOStatusInsufficientPermission,

    // predict.io has not been started. It is in inactive state.
    PredictIOStatusInActive
};

/*
 * TransportMode
 * Discussion: Represents the vehicle transport mode.
 */
typedef NS_ENUM(int, TransportMode) {
    // transport mode is Undetermined by the tracker
    TransportModeUndetermined = -1,

    // transport mode is Car determined by the tracker
    TransportModeCar = 0,

    // transport mode is other determined by the tracker
    TransportModeOther = 1
};

/*
 * LogLevel
 * Discussion: Represents the current predict.io logger state.
 */
typedef NS_ENUM(int, LogLevel)  {
    LogLevelNone = 0, LogLevelDebug
};

@protocol PredictIODelegate;

@interface PredictIO : NSObject

@property (nonatomic, weak) id <PredictIODelegate> delegate;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *version;

+ (PredictIO *)sharedInstance;

/*
 * Starts the predict.io Tracker if delegate and API-Key is set, otherwise returns Error
 * @param handler: The argument to the completion handler block is an error object that contains the description of the error in case an error is encountered while starting the ParkTAG tracker. If the tracker is started successfully, the error object is set to nil.
 */
- (void)startWithCompletionHandler:(void(^)(NSError *error))handler;

/*
 * Stops the predict.io Tracker
 */
- (void)stop;

/*
 * Activates GPS (if not already activated) for short period of time i.e. 90 seconds
 * Note: To use this method Tracker must have been started first.
 */
- (void)kickStartGPS;

/*
 * This method returns the status of the tracker i.e. if it is active or otherwise
 */
- (PredictIOStatus)status;

/*
 * Returns an alphanumeric string that uniquely identifies a device to the tracker
 */
- (NSString *)deviceIdentifier;

@end

@protocol PredictIODelegate <NSObject>

@optional

/*
 * This method is invoked when predict.io detects that user is about to departure from his location
 * and is approaching his vehicle
 * @param departureLocation: The Location where predict.io identified the parking spot that is about to be vacated.
 * @param transportMode: Mode of transport
*/
- (void)departingFromLocation:(CLLocation *)departureLocation
                transportMode:(TransportMode)transportMode;

/*
 * This method is invoked when predict.io detects that user has just departed
 * from his location and have started a new trip
 * @param departureLocation: The Location where predict.io identified start of the trip
 * @param departureTime: start time of the trip
 * @param transportMode: Mode of transport
 */
- (void)departedLocation:(CLLocation *)departureLocation
           departureTime:(NSDate *)departureTime
           transportMode:(TransportMode)transportMode;

/*
 * This method is invoked when predict.io is unable to validate last departure event
 */
- (void)departureCanceled;

/*
 * This method is invoked when predict.io suspects that user has just parked his vehicle
 * Most of the time it is followed by a confirmed vehicleParked event
 * If you need only confirmed parked events, use vehicleParked method (below) instead
 * @param departureLocation: The Location from where user departed
 * @param arrivalLocation: The Location where user arrived and parked his vehicle
 * @param departureTime: Start time of trip
 * @param arrivalTime: Stop time of trip
 * @param transportMode: Mode of transport
 */
- (void)arrivalSuspectedFromLocation:(CLLocation *)departureLocation
                     arrivalLocation:(CLLocation *)arrivalLocation
                       departureTime:(NSDate *)departureTime
                         arrivalTime:(NSDate *)arrivalTime
                       transportMode:(TransportMode)transportMode;

/*
 * This method is invoked when predict.io detects that user has just parked his vehicle
 * @param arrivalLocation:  The Location where vehicle is parked
 * @param departureLocation:  The Location where vehicle is vacated***
 * @param departureTime: Start time of trip
 * @param arrivalTime:  Stop time of trip
 * @param transportMode: Mode of transport
*/
- (void)arrivedAtLocation:(CLLocation *)arrivalLocation
        departureLocation:(CLLocation *)departureLocation
              arrivalTime:(NSDate *)arrivalTime
            departureTime:(NSDate *)departureTime
            transportMode:(TransportMode)transportMode;

/*
 * This method is invoked when predict.io user is looking for a free parking spot
 * @param location:  The Location where predict.io identified that user is searching for parking
 */
- (void)searchingInPerimeter:(CLLocation *)searchingLocation;

/*
 * This is invoked when new location information is received from location services
 * Implemented this method if you need raw GPS data, instead of creating new location manager
 * Since, it is not recommended to use multiple location managers in a single app
 * @param location:  New location
 */
- (void)didUpdateLocation:(CLLocation *)location;

@end

// These notifications are sent out after the equivalent delegate message is called
FOUNDATION_EXPORT NSString *const PIODepartingNotification;
FOUNDATION_EXPORT NSString *const PIODepartedNotification;
FOUNDATION_EXPORT NSString *const PIODepartureCanceledNotification;
FOUNDATION_EXPORT NSString *const PIOArrivalSuspectedNotification;
FOUNDATION_EXPORT NSString *const PIOArrivedNotification;
FOUNDATION_EXPORT NSString *const PIOSearchingParkingNotification;
