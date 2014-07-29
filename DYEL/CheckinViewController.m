//
//  CheckinController.m
//  DYEL
//
//  Created by Leo Martel on 6/4/14.
//  Copyright (c) 2014 leopmartel. All rights reserved.
//

#import "CheckinViewController.h"
#import <GLKit/GLKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "WorkoutViewController.h"
#import "Gym+MapAnnotation.h"
#import "CoreData.h"
#import "Routine+Fetch.h"
#import "Day+Create.h"


@interface CheckinViewController() <MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation CheckinViewController

- (void)awakeFromNib
{
    id loc = self.locationManager.location; // ask for location permissions, if not already asked for
    #pragma unused (loc)
}

// On first load, zoom to see nearby gyms (and load previously visited gyms)
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self updateNearbyGyms:YES];
    NSArray *priorGyms = [Gym allinManagedObjectContext:[CoreData context]];
    for(Gym *gym in priorGyms){
        [self.mapView addAnnotation:gym];
    }
}

// On reload, recenter but don't change zoom
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateNearbyGyms:NO];
    [self.mapView setCenterCoordinate:self.locationManager.location.coordinate animated:YES];
}

- (void)updateNearbyGyms:(BOOL)moveViewport
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"gym";
    
    // ~1km^2 radius around current location
    request.region = MKCoordinateRegionMake(self.locationManager.location.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            for (MKMapItem *mapItem in [response mapItems]) {
                [self.mapView addAnnotation:[Gym gymWithCoordinate:mapItem.placemark.coordinate
                                                          withName:[mapItem name]
                                            inManagedObjectContext:[CoreData context]]
                 ];
            }
            
            if(moveViewport){
                [self.mapView showAnnotations:self.mapView.annotations animated:YES];
            }
        } else {
            NSLog(@"[CheckinViewController viewDidLoad] Error: %@", [error localizedDescription]);
        }
    }];

}

#pragma mark Properties

- (CLLocationManager *)locationManager
{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
    }
    return _locationManager;
}

#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    // Do nothing extra
}

// On location update, check for new gyms but don't move camera
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self updateNearbyGyms:NO];
}

#define MAX_DISTANCE_FROM_GYM 100 // meters

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Day *today = [Day today];
    int routineCountToday = [[CoreData context] countForFetchRequest:[Routine fetchRequestForDay:today]
                                                               error:nil];
    if(!routineCountToday){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Should you even lift?"
                                                        message:[NSString stringWithFormat:@"You don't have any workouts scheduled for %@s. Add some lifts in the Plan tab, or enjoy the rest day.", today.name]
                                                       delegate:nil
                                              cancelButtonTitle:@"Sweatpants!"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    CLLocation *here = self.locationManager.location;
    Gym *gym = view.annotation;

    CLLocation *there = [[CLLocation alloc] initWithLatitude:[gym.latitude doubleValue] longitude:[gym.longitude doubleValue]];
    if([here distanceFromLocation:there] > MAX_DISTANCE_FROM_GYM){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you even lifting?"
                                                        message:[NSString stringWithFormat:@"You aren't close enough to %@ to check in there!", gym.name]
                                                       delegate:nil
                                              cancelButtonTitle:@"You caught me."
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self performSegueWithIdentifier:@"Checkin Segue" sender:view];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isEqual:[mapView userLocation]]) return nil; // Show user as blue dot, not red pin
 
    static NSString *reuseId = @"Checkin Annotation";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        view.canShowCallout = YES;
    }
    
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    view.annotation = annotation;
    
    return view;
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender
{
    WorkoutViewController *dest = [segue destinationViewController];
    dest.gym = sender.annotation;
    self.locationManager = nil; // deallocate location manager to save battery
}

@end
