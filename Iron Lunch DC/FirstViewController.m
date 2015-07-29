//
//  FirstViewController.m
//  Iron Lunch DC
//
//  Created by Dustin Hennessy on 6/18/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import "FirstViewController.h"
#import "Searches.h"
#import "AppDelegate.h"

@interface FirstViewController ()

@property (nonatomic, strong)         CLLocationManager *locationManager;
@property (nonatomic, weak)  IBOutlet MKMapView         *lunchMapView;
@property (nonatomic, weak)  IBOutlet UISearchBar       *locationSearchBar;
@property (nonatomic, strong)         AppDelegate       *appDelegate;
@property (nonatomic, strong)         Searches          *searchManager;


@end

@implementation FirstViewController

//Create zoom to location method. Set lat prop and lon property == the coordinates from that method.

//Make CLLocationMake and use it in the region. Turn it into a span.




#pragma mark - Location Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *lastLocation = locations.lastObject;
    NSLog(@"Location: %F %F", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude);
    [self zoomToLocationWithLat:lastLocation.coordinate.latitude andLon:lastLocation.coordinate.longitude];
    [_locationManager stopUpdatingLocation];
    
    _searchManager.searchLatitude = [NSNumber numberWithFloat:lastLocation.coordinate.latitude];
    _searchManager.searchLongitude = [NSNumber numberWithFloat:lastLocation.coordinate.longitude];
}

- (void)turnOnLocationMonitoring {
    [_locationManager startUpdatingLocation];
    _lunchMapView.showsUserLocation = true;
}

- (void)setupLocationMonitoring {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways: {
                [self turnOnLocationMonitoring];
                break;
            }
            case kCLAuthorizationStatusAuthorizedWhenInUse: {
                [self turnOnLocationMonitoring];
                break;
            }
            case kCLAuthorizationStatusDenied: {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Denied" message:@"You turned off our location access?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                break;
            }
            case kCLAuthorizationStatusNotDetermined: {
                if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [_locationManager requestWhenInUseAuthorization];
                }
                break;
            }
            default:
                break;
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services" message:@"Turn on your location services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark - Search methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Getting Data");
    [_searchManager searchDataForString:_locationSearchBar.text inRegion:[_lunchMapView region]];
    [_locationSearchBar resignFirstResponder];
}

- (void)newDataReceived {
    NSLog(@"NDR");
    NSMutableArray *locs = [[NSMutableArray alloc] init];
    for (id <MKAnnotation> annot in [_lunchMapView annotations]) {
        if ([annot isKindOfClass:[MKPointAnnotation class]]) {
            [locs addObject:annot];
        }
    }
    [_lunchMapView removeAnnotations:locs];

    for (MKMapItem *item in [_searchManager dataArray]) {
        
        MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
        pa.coordinate = item.placemark.location.coordinate;
        pa.title = item.name;
        pa.subtitle = [NSString stringWithFormat:@"Local Search: %f %f", item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude];
        [_lunchMapView addAnnotation:pa];
    }
    
}

- (void)zoomToLocationWithLat:(float)latitude andLon:(float)longitude {
    
    
    if (latitude == 0 && longitude == 0) {
        NSLog(@"Bad Coordinates");
              } else {
                  
                  CLLocationCoordinate2D zoomLocation;
                  zoomLocation.latitude = latitude;
                  zoomLocation.longitude = longitude;
                  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 18000, 18000);
                  MKCoordinateRegion adjustedRegion = [_lunchMapView regionThatFits:viewRegion];
                  [_lunchMapView setRegion:adjustedRegion animated:YES];
                  
              }
    
}



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if (annotation != mapView.userLocation) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            
            annotationView.canShowCallout = true;
            annotationView.pinColor = MKPinAnnotationColorGreen;
            annotationView.animatesDrop = true;
        }else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

#pragma mark - Map methods 

//- (void)annotateMapLocations {
//    NSMutableArray *locs = [[NSMutableArray alloc] init];
//    for (id  <MKAnnotation> annot in [_lunchMapView annotations]) { //?
//        if ([annot isKindOfClass:[MKPointAnnotation class]]) {
//            [locs addObject:annot];
//        }
//    }
//    [_lunchMapView removeAnnotations:locs];
//    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
//    MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
//    [_lunchMapView addAnnotations:annotationArray];
//}

#pragma mark - Life Cycle Methods

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocationMonitoring];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _searchManager = _appDelegate.searchManager;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDataReceived) name:@"ResultsDoneNotification" object:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
