//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiF3rdPartyEngine.h"
#import <EGOCache/EGOCache.h>
#import "EGOCache+NSArray.h"
#import "NSMutableArray+Shuffling.h"

@interface LiiF3rdPartyEngine ()
+ (NSArray *)presetSaladPlacesNames;
@end

@implementation LiiF3rdPartyEngine {


}

#pragma mark - Foursquare

+ (NSArray*)presetSaladPlacesNames
{
    NSArray* places = @[
            @{@"name": @"Tender Greens", @"address": @"30 fremont", @"city": @"san francisco"},
            @{@"name": @"Feed", @"address": @"215 fremont", @"city": @"san francisco"},
            @{@"name": @"Focaccia", @"address": @"455 market", @"city": @"san francisco"},
            @{@"name": @"Cafe Venue", @"address": @"218 montgomery", @"city": @"san francisco"},
            @{@"name": @"Blue Barn", @"address": @"2105 Chestnut Street", @"city": @"san francisco"},
            @{@"name": @"Mixt Greens", @"address": @"120 Sansome Street", @"city": @"san francisco"},
            @{@"name": @"Darwin Cafe", @"address": @"212 Ritch Street", @"city": @"san francisco"},
            @{@"name": @"Noir Lounge", @"address": @"581 hayes street", @"city": @"san francisco"},
            @{@"name": @"Buckhorn Grill", @"address": @"4 Embarcadero", @"city": @"san francisco"},
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

+(void)searchFoursquarePlaceName:(NSString *)placeName inCityName:(NSString *)cityName
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
}

#pragma mark - Instagram pictures

+ (RACSignal *)searchInstagramForFoursquarePlace:(NSDictionary *)foursquarePlace
{
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        CGFloat lat = [[foursquarePlace valueForKeyPath:@"location.lat"] floatValue];
        CGFloat lng = [[foursquarePlace valueForKeyPath:@"location.lng"] floatValue];
        CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat, lng);
        [[InstagramEngine sharedEngine] getMediaAtLocation:coords withSuccess:^(NSArray *media) {
            [subscriber sendNext:media];
            [subscriber sendCompleted];
//            NSLog(@"media %d", media.count);
        } failure:^(NSError *error) {
            [subscriber sendError:error];
//            NSLog(@"error", error);
        }];
        return nil;
    }];
}

+ (RACSignal *)instagramForTag:(NSString*)tag
{
    return [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [[InstagramEngine sharedEngine] getMediaWithTagName:tag withSuccess:^(NSArray *feed) {

            NSMutableArray * shuffled = [feed mutableCopy];
            [shuffled shuffle];
            [subscriber sendNext:shuffled];
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

+ (void)testInstagram
{
    [[LiiF3rdPartyEngine presetFoursquareSaladPlaces] subscribeNext:^(id x) {
        NSArray *places = (NSArray *) x;
        NSDictionary *place = places[0];
        [[LiiF3rdPartyEngine searchInstagramForFoursquarePlace:place] subscribeNext:^(id x) {
            NSArray *instaMedias = (NSArray *)x;
//            NSLog(@"media %d", instaMedias.count);
        }];
    }];
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




INSTAGRAM MEDIA
{
            attribution = "<null>";
            caption =             {
                "created_time" = 1395599321;
                from =                 {
                    "full_name" = genidc;
                    id = 223267289;
                    "profile_picture" = "http://images.ak.instagram.com/profiles/profile_223267289_75sq_1389893251.jpg";
                    username = genidc;
                };
                id = 682659048719632880;
                text = "Grilled Chicken salad. #Lunchtime #GoodEats #EatWell #Healthy #Strength #Body #Strong #Fitness #Salads #ChickenSalad";
            };
            comments =             {
                count = 0;
                data =                 (
                );
            };
            "created_time" = 1395599321;
            filter = "X-Pro II";
            id = "682659047520062192_223267289";
            images =             {
                "low_resolution" =                 {
                    height = 306;
                    url = "http://distilleryimage9.s3.amazonaws.com/39ef370eb2b811e3bc6c0a0f0cfeba95_6.jpg";
                    width = 306;
                };
                "standard_resolution" =                 {
                    height = 640;
                    url = "http://distilleryimage9.s3.amazonaws.com/39ef370eb2b811e3bc6c0a0f0cfeba95_8.jpg";
                    width = 640;
                };
                thumbnail =                 {
                    height = 150;
                    url = "http://distilleryimage9.s3.amazonaws.com/39ef370eb2b811e3bc6c0a0f0cfeba95_5.jpg";
                    width = 150;
                };
            };
            likes =             {
                count = 3;
                data =                 (
                                        {
                        "full_name" = "Jonathan David Li";
                        id = 232836385;
                        "profile_picture" = "http://images.ak.instagram.com/profiles/profile_232836385_75sq_1375067605.jpg";
                        username = beastlifit;
                    },
                                        {
                        "full_name" = "Wander Morel";
                        id = 337820307;
                        "profile_picture" = "http://images.ak.instagram.com/profiles/profile_337820307_75sq_1395540788.jpg";
                        username = "monkey_king55";
                    },
                                        {
                        "full_name" = "Cyrus (Not The Great One)";
                        id = 1025165765;
                        "profile_picture" = "http://images.ak.instagram.com/profiles/profile_1025165765_75sq_1393605032.jpg";
                        username = bodyanmind;
                    }
                );
            };
            link = "http://instagram.com/p/l5SsluI8rw/";
            location =             {
                id = 238157842;
                latitude = "42.7614532";
                longitude = "-71.11859440000001";
                name = "Badaboom Boston";
            };
            tags =             (
                body,
                strength,
                healthy,
                goodeats,
                chickensalad,
                eatwell,
                lunchtime,
                fitness,
                strong,
                salads
            );
            type = image;
            user =             {
                bio = "";
                "full_name" = genidc;
                id = 223267289;
                "profile_picture" = "http://images.ak.instagram.com/profiles/profile_223267289_75sq_1389893251.jpg";
                username = genidc;
                website = "";
            };
            "users_in_photo" =             (
            );
        },
*/
@end