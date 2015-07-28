//
//  Searches.h
//  Iron Lunch DC
//
//  Created by Dustin Hennessy on 6/18/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Searches : NSObject

@property (nonatomic, strong)        NSArray        *dataArray;
@property (nonatomic, strong) NSNumber              *searchLatitude;
@property (nonatomic, strong) NSNumber              *searchLongitude;

+ (id)sharedSearch;
- (void)searchDataForString:(NSString *)searchString inRegion:(MKCoordinateRegion)region;


@end
