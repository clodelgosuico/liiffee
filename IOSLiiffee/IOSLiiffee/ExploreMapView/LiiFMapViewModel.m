//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFMapViewModel.h"
#import "LiiF3rdPartyEngine.h"


@implementation LiiFMapViewModel {

}

- (instancetype)init {
    self = [super init];
    if(!self) return nil;
    @weakify(self);

    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        [self getFoursquarePresetData];
    }];

    return self;
}

- (void)getFoursquarePresetData
{
    @weakify(self);
    [[LiiF3rdPartyEngine presetFoursquareSaladPlaces] subscribeNext:^(id x) {
        @strongify(self);
       NSArray * venues = (NSArray *) x;
        self.foursquarePlaces = venues;
    }];
}

@end