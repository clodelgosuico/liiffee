//
//  LiiffeeCustomAnnotation.m
//  IOSLiiffee
//
//  Created by Clodel Gosuico on 3/22/14.
//  Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiffeeBusinessAnnotation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@implementation LiiffeeBusinessAnnotation

-(id)initWithTitle:(NSString *)newTitle Location:(CLLocationCoordinate2D)location {
    self = [super init];
    if(self) {
        _title = newTitle;
        _coordinate = location;
    }
    return self;
}

-(MKAnnotationView *) annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"LiiffeeBusinessAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"MapGray"];
//    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self action:@selector(displayArrow:) forControlEvents:
     UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView = button;
    
    return annotationView;
}


@end
