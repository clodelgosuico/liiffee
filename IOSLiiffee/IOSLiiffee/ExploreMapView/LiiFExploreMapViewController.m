//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFExploreMapViewController.h"
#import "LiiFMapViewModel.h"
#import "LiiFBusinessPlaceViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LiiFExploreMapViewController() <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LiiFMapViewModel *viewModel;

- (void)showFoursquarePlaces;
@end

@implementation LiiFExploreMapViewController {

}

- (instancetype)init {

    self = [super init];
    if(!self) return nil;
    self.viewModel = [[LiiFMapViewModel alloc] init];
    return self;
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.mapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Salad Places";

    [self setupLayout];
    [self setupModelViewConnections];

    @weakify(self);
    [RACObserve(self.viewModel, foursquarePlaces) subscribeNext:^(id x) {
        @strongify(self);
        // TODO show pins in  map
        if(x){
            NSArray *places = (NSArray *)x;
            // for now: show the first business place view
            [self showBusinessPlaceViewForFoursquarePlace:[places firstObject]];
            // show pins in the map
//            [self showFoursquarePlaces];
        }
    }];
}

- (void)showBusinessPlaceViewForFoursquarePlace:(NSDictionary *)foursquarePlace
{
    LiiFBusinessPlaceViewController *businessPlaceViewController = [[LiiFBusinessPlaceViewController alloc] init];
    [self.navigationController pushViewController:businessPlaceViewController animated:YES];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewModel.active = YES; // will trigger fetching data from the network / cache
}


#pragma mark -Setting up views
- (void)setupLayout
{
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(self.view);
    }];
}

- (void)setupModelViewConnections
{

}

#pragma mark - Views

- (MKMapView *)mapView {
    if(!_mapView){
        _mapView = [[MKMapView alloc] init];
        _mapView.translatesAutoresizingMaskIntoConstraints = NO;
        _mapView.backgroundColor = [UIColor redColor];
        _mapView.delegate = self;
    }
    return _mapView;
}

#pragma mark - Pins

- (void) showFoursquarePlaces
{
    __block CLLocationCoordinate2D center ;
    __block NSNumber *hasCenter = @NO;
    [self.viewModel.foursquarePlaces enumerateObjectsUsingBlock:^(NSDictionary * fqPlace, NSUInteger idx, BOOL *stop) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        CGFloat lat = [fqPlace[@"location"][@"lat"] floatValue];
        CGFloat lng = [fqPlace[@"location"][@"lng"] floatValue];
        NSString *title = fqPlace[@"name"];
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(lat, lng);
        if(!hasCenter.boolValue){
            center = coordinates;
            hasCenter = @YES;
        }
        [annotation setCoordinate:coordinates];
        [annotation setTitle:title];
        [self.mapView addAnnotation:annotation];

    }];

    [self.mapView setCenterCoordinate:center animated:YES];

}

@end