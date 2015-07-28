//
//  Searches.m
//  Iron Lunch DC
//
//  Created by Dustin Hennessy on 6/18/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import "Searches.h"


@implementation Searches

+ (id)sharedSearch {
    static Searches *sharedSearch = nil;
    @synchronized(self) {
        if (sharedSearch == nil)
            sharedSearch = [[self alloc] init];
    }
    return sharedSearch;
}

- (void)searchDataForString:(NSString *)searchString inRegion:(MKCoordinateRegion)region {
    _dataArray = [[NSArray alloc] init];
    NSLog(@"Apple Search");
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchString;
    request.region = region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (response.mapItems.count == 0) {
            NSLog(@"No results");
        } else {
            NSLog(@"MapItems:%li",response.mapItems.count);
//            for (MKMapItem *item in response.mapItems) {
//                MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
//                pa.coordinate = item.placemark.location.coordinate;
//                pa.title = item.name;
//                pa.subtitle = [NSString stringWithFormat:@"Local Search: %f %f", item.placemark.location.coordinate.latitude, item.placemark.location.coordinate.longitude];
//                [_dataArray addObject:pa];
//            }
//            NSLog(@"Got %li",_dataArray.count);
            _dataArray = response.mapItems;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResultsDoneNotification" object:nil];
        }
    }];
}

@end
