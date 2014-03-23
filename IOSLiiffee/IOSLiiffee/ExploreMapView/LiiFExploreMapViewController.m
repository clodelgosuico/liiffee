//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFExploreMapViewController.h"
#import "LiiFMapViewModel.h"
#import "LiiFBusinessPlaceViewController.h"
#import "LiiffeeBusinessAnnotation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LiiFExploreMapViewController() <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LiiFMapViewModel *viewModel;

@property (nonatomic, strong) NSMutableDictionary *mapAnnotations;


- (void)showFoursquarePlaces;

//- (NSDictionary *)foursquarePlaceForAnnotation:(MKPointAnnotation *)annotation;
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
//            [self showBusinessPlaceViewForFoursquarePlace:[places firstObject]];
            // show pins in the map
            [self showFoursquarePlaces];
        }
    }];
}

- (void)showBusinessPlaceViewForFoursquarePlace:(NSDictionary *)foursquarePlace
{
    LiiFBusinessPlaceViewController *businessPlaceViewController = [[LiiFBusinessPlaceViewController alloc]
            initWithFoursquarePlace:foursquarePlace];
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

- (NSMutableDictionary *)mapAnnotations {
    if(!_mapAnnotations){
        _mapAnnotations = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    return _mapAnnotations;
}

#pragma mark - Pins

- (void) showFoursquarePlaces
{
    __block CLLocationCoordinate2D center ;
    __block NSNumber *hasCenter = @NO;
    [self.viewModel.foursquarePlaces enumerateObjectsUsingBlock:^(NSDictionary * fqPlace, NSUInteger idx, BOOL *stop) {
        NSString *placeId = fqPlace[@"id"];
//        NSLog(@"id %@", placeId);
        if(![self.mapAnnotations objectForKey:placeId]){
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
            [self.mapAnnotations setObject:annotation forKey:placeId];
        }
    }];
    // recenter map
    if(hasCenter)
        [self.mapView setCenterCoordinate:center animated:NO];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    //return nil;
    // XXX TODO will show the custom pin when we can show the title view, and a button, etc
    static NSString *grayPinID = @"grayPinId";
    static NSString *greenPinID = @"greenPinId";
    MKAnnotationView *annotationView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:grayPinID];
    if(!annotationView){
        annotationView =  [[MKAnnotationView alloc] initWithAnnotation:annotation
                           reuseIdentifier:@"LiiffeeBusinessAnnotation"];
                                                       //reuseIdentifier:grayPinID];
        // FAKING randomly picking a pin
        NSInteger randomNumber = arc4random() % 2;
        annotationView.image = randomNumber==0 ? [UIImage imageNamed:@"GreenPin"] : [UIImage imageNamed:@"RedPin"];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        //UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //setting button image
        //[button setImage:[UIImage imageNamed:@"RedPin"] forState:UIControlStateNormal];
        
        //[button setBackgroundImage:[UIImage imageNamed:@"Arrow"] forState:UIControlStateNormal];
        
        UIImage *image = [UIImage imageNamed:@"Arrow"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(22.0, 22.0, image.size.width, image.size.height);
        button.frame = frame;
        [button setBackgroundImage:image forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        
        annotationView.rightCalloutAccessoryView = button;

    }
    return annotationView;
}

- (NSDictionary *)foursquarePlaceForAnnotation:(MKAnnotationView *)annotationView
{
    __block NSDictionary *result = nil;
    [self.mapAnnotations enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if(obj == annotationView.annotation || [obj isEqual:annotationView.annotation]){
            NSString *placeId = (NSString *)key;
            result = [self.viewModel foursquarePlaceWithId:placeId];
            *stop = YES;
        }
    }];
    return result;
}

#pragma mark - Map delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    NSLog(@"selected ? %d", view.selected);

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"from %@", view);
    if([view.annotation isKindOfClass:[MKPointAnnotation class]]){
        NSDictionary *place = [self foursquarePlaceForAnnotation:view];
        [self showBusinessPlaceViewForFoursquarePlace:place];
//        [self.mapView deselectAnnotation:view.annotation animated:NO];
    }

}

- (void)tapInfo:(id)sender
{
    NSLog(@"from %@", sender);
}

- (void)mapView:(MKMapView *)mapView tapInfo:(MKAnnotationView *)view {
    
    //    if([view isKindOfClass:[MKPointAnnotation class]]){
    NSDictionary *place = [self foursquarePlaceForAnnotation:view];
    [self showBusinessPlaceViewForFoursquarePlace:place];
    [self.mapView deselectAnnotation:view animated:NO];
    //    }
    
}

@end