//
//  LiiffeeCustomAnnotation.h
//  IOSLiiffee
//
//  Created by Clodel Gosuico on 3/22/14.
//  Copyright (c) 2014 Liiffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LiiffeeBusinessAnnotation : NSObject
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;

-(id)initWithTitle:(NSString *)newTitle Location: (CLLocationCoordinate2D)location;
-(MKAnnotationView *)annotationView;
@end
