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

- (NSDictionary *)foursquarePlaceWithId:(NSString*)placeId
{
    __block NSDictionary* result = nil;
    [self.foursquarePlaces enumerateObjectsUsingBlock:^(NSDictionary *place, NSUInteger idx, BOOL *stop) {
        NSString *s = place[@"id"];
        if([s isEqualToString:placeId])
            result = place;
        * stop = YES;
    }];
    return result;
}

@end