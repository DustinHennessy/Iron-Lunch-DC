//
//  SecondViewController.m
//  Iron Lunch DC
//
//  Created by Dustin Hennessy on 6/18/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

#import "SecondViewController.h"
#import "Searches.h"
#import "AppDelegate.h"

@interface SecondViewController ()

@property (nonatomic, strong) AppDelegate          *appDelegate;
@property (nonatomic, strong) Searches             *searchManager;
@property (nonatomic, weak) IBOutlet UISearchBar   *locationSearchBar;
@property (nonatomic, strong) IBOutlet UITableView *locationTableView;


@end

@implementation SecondViewController


#pragma mark - search button methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    NSLog(@"Getting Data");
    
    CLLocationCoordinate2D region = CLLocationCoordinate2DMake([[_searchManager searchLatitude] floatValue], [[_searchManager searchLongitude] floatValue]);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(region, 10000, 10000);
    
    NSLog(@"Search For:%@ in:%f,%f",_locationSearchBar.text,[[_searchManager searchLatitude] floatValue],[[_searchManager searchLongitude] floatValue]);
    [_searchManager searchDataForString:_locationSearchBar.text inRegion:viewRegion];
    [_locationSearchBar resignFirstResponder];
}

#pragma mark - Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"rc:%li",_searchManager.dataArray.count);
    return _searchManager.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    MKMapItem *currentItem = [[_searchManager dataArray] objectAtIndex:indexPath.row];
    NSLog(@"CFR %@",currentItem.name);
    cell.textLabel.text = [currentItem name];
    
    return cell;
}

- (void)reloadTableViews {
    [_locationTableView reloadData];
}

#pragma mark - Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [_locationTableView reloadData];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _searchManager = _appDelegate.searchManager;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViews) name:@"ResultsDoneNotification" object:nil];
//    [search getData];
//    for (NSString *testString in [search dataArray]) {
//            NSLog(@"Got: %@",testString);
//        }
    }



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
