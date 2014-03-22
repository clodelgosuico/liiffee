//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVMViewModel.h"


@interface LiiFMapViewModel : RVMViewModel

@property (nonatomic, strong) NSArray *foursquarePlaces;

- (NSDictionary *)foursquarePlaceWithId:(NSString *)placeId;
@end