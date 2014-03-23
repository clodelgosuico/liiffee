//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LiiF3rdPartyEngine : NSObject


+ (RACSignal *)presetFoursquareSaladPlaces;


+ (RACSignal *)searchInstagramForFoursquarePlace:(NSDictionary *)foursquarePlace;

+ (void)testInstagram;
@end