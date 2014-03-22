//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiF3rdPartyEngine.h"
#import <EGOCache/EGOCache.h>
#import "EGOCache+NSArray.h"

@interface LiiF3rdPartyEngine ()
+ (NSArray *)presetSaladPlacesNames;
@end

@implementation LiiF3rdPartyEngine {


}

+ (NSArray*)presetSaladPlacesNames
{
    NSArray* places = @[
            @{@"name": @"Tender Greens", @"address": @"30 fremont", @"city": @"san francisco"},
//            @{@"name": @"Feed", @"address": @"215 fremont", @"city": @"san francisco"},
//            @{@"name": @"Focaccia", @"address": @"455 market", @"city": @"san francisco"},
//            @{@"name": @"Cafe Venue", @"address": @"218 montgomery", @"city": @"san francisco"},
//            @{@"name": @"Blue Barn", @"address": @"2105 Chestnut Street", @"city": @"san francisco"},
//            @{@"name": @"Mixt Greens", @"address": @"120 Sansome Street", @"city": @"san francisco"},
//            @{@"name": @"Darwin Cafe", @"address": @"212 Ritch Street", @"city": @"san francisco"},
//            @{@"name": @"Noir Lounge", @"address": @"581 hayes street", @"city": @"san francisco"},
//            @{@"name": @"Buckhorn Grill", @"address": @"4 Embarcadero", @"city": @"san francisco"},
            ];

    return places;
}

/**
* This method is fetching the preset places and cache them once. Once it's in the cache, we do not fetch them
* from Foursquare
* XXX TODO synchronize callbacks
*/
+ (RACSignal*)presetFoursquareSaladPlaces {

    // example to get the result for 1 preset place:
//    RACSignal *signal = [LiiF3rdPartyEngine searchFoursquarePlaceForPreset:places[0]];
//    [signal subscribeNext:^(id x) {
//        NSLog(@"got %@", x);
//    }];

    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        // takes the preset places
        NSArray *places = [LiiF3rdPartyEngine presetSaladPlacesNames];
        // create the signals that return a list of places from cache or from foursquare
        RACSignal *allPresetSignal = [RACSignal concat:[places.rac_sequence map:^id(id value) {
            return [LiiF3rdPartyEngine searchFoursquarePlaceForPreset:value];
        }]];
        // runs the signals, when completed is called, it means all signals have completed, and
        // results contains all of the places
        NSMutableArray *results = [NSMutableArray array];
        [allPresetSignal subscribeNext:^(id x) {
            NSLog(@"%@", x);
            RACTuple *tuple = (RACTuple *)x;
            NSArray *venues = tuple.second;
            [results addObjectsFromArray:venues];
        } completed:^{
            NSLog(@"number of places %d\n%@", results.count, results[0]);
            [subscriber sendNext:results];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

+ (RACSignal*)searchFoursquarePlaceForPreset:(NSDictionary *)presetPlace
{
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        NSString *cacheKey = [[presetPlace allValues] componentsJoinedByString:@";"];
        BOOL searchForPlaceAnyway = YES;
        if ([[EGOCache globalCache] hasCacheForKey:cacheKey]){
            id object = [[EGOCache globalCache] arrayForKey:cacheKey];
            if([object isKindOfClass:[NSArray class]]){
                NSArray *venues = (NSArray *) object;
                if(venues.count>0){
                    searchForPlaceAnyway = NO;
                    [subscriber sendNext:[RACTuple tupleWithObjects:[NSNumber numberWithBool:YES], venues, nil]];
                    [subscriber sendCompleted];
                }
            }
        }
        if(searchForPlaceAnyway){
            RACSignal *signal = [LiiF3rdPartyEngine searchFoursquarePlaceName:presetPlace[@"name"] inCityName:presetPlace[@"city"]];
            [signal subscribeNext:^(id x) {
                RACTuple *tuple = (RACTuple *) x;
                NSArray *venues = tuple.second;
                if(venues.count>0){
                      [[EGOCache globalCache] setArray:venues forKey:cacheKey];
                }
                [subscriber sendNext:x];
                [subscriber sendCompleted];
            }];
        }
        return nil;
    }];
}

+ (RACSignal *)searchFoursquarePlaceName:(NSString*)placeName inCityName:(NSString*)cityName
{
    return [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
        [LiiF3rdPartyEngine searchFoursquarePlaceName:placeName inCityName:cityName callback:^(BOOL success, id result) {
            [subscriber sendNext:[RACTuple tupleWithObjects:[NSNumber numberWithBool:success], result, nil]];
            [subscriber sendCompleted];
        }];
        return nil; // `nil` means there's no way to cancel.
    }];
}

+(NSArray*)searchFoursquarePlaceName:(NSString*)placeName inCityName:(NSString*)cityName
                            callback:(Foursquare2Callback)callback
{
    [Foursquare2 venueSearchNearLocation:cityName query:placeName
                                   limit:@10 intent:intentBrowse radius:@800 categoryId:nil
      callback:^(BOOL success, id result){
        NSMutableArray *found = [NSMutableArray array];
        if (success) {
            NSDictionary *dic = result;
            NSArray *venues = [dic valueForKeyPath:@"response.venues"];
            // filter to find the ones with the same name
            [venues enumerateObjectsUsingBlock:^(NSDictionary * venue, NSUInteger idx, BOOL *stop) {
                NSString *name = venue[@"name"];
                if([name.lowercaseString hasPrefix:placeName.lowercaseString])
                    [found addObject:venue];
            }];
        }
        if(callback){
            callback(success, found);
        }
    }];

    return nil;
}

/**
* Foursquare: Search for a place results
{
    meta =     {
        code = 200;
    };
    response =     {
        geocode =         {
            feature =             {
                cc = US;
                displayName = "San Francisco, CA, United States";
                geometry =                 {
                    bounds =                     {
                        ne =                         {
                            lat = "37.929824";
                            lng = "-122.28178";
                        };
                        sw =                         {
                            lat = "37.63983";
                            lng = "-123.173825";
                        };
                    };
                    center =                     {
                        lat = "37.77493";
                        lng = "-122.41942";
                    };
                };
                highlightedName = "<b>San Francisco</b>, CA, United States";
                id = "geonameid:5391959";
                longId = 72057594043319895;
                matchedName = "San Francisco, CA, United States";
                name = "San Francisco";
                slug = "san-francisco-california";
                woeType = 7;
            };
            parents =             (
            );
            what = "";
            where = "san francisco";
        };
        venues =         (
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/food/default_";
                            suffix = ".png";
                        };
                        id = 4bf58dd8d48988d14e941735;
                        name = "American Restaurant";
                        pluralName = "American Restaurants";
                        primary = 1;
                        shortName = American;
                    }
                );
                contact =                 {
                    facebook = 394479147344199;
                    formattedPhone = "(415) 543-5200";
                    phone = 4155435200;
                };
                hereNow =                 {
                    count = 0;
                    groups =                     (
                    );
                };
                id = 52389281498e8911159661b7;
                location =                 {
                    address = "30 Fremont St";
                    cc = US;
                    city = "San Francisco";
                    country = "United States";
                    crossStreet = "Market St.";
                    lat = "37.7907323417446";
                    lng = "-122.3974503109033";
                    postalCode = 94105;
                    state = CA;
                };
                name = "Tender Greens";
                referralId = "v-1395511022";
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 821;
                    tipCount = 13;
                    usersCount = 440;
                };
                storeId = "";
                venuePage =                 {
                    id = 76280580;
                };
                verified = 1;
            },
            [xxxx]

        );
    };
}

*/
@end