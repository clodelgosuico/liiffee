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

+ (NSArray*)presetFoursquareSaladPlaces
{
    NSMutableArray *presetResult = [NSMutableArray array];

    NSArray *places = [LiiF3rdPartyEngine presetSaladPlacesNames];
//    NSDictionary *place = [places firstObject];

    [[EGOCache globalCache] clearCache];

    [places enumerateObjectsUsingBlock:^(NSDictionary * place, NSUInteger idx, BOOL *stop) {
        //basic EGOCache mechanism
        NSString *cacheKey = [[place allValues] componentsJoinedByString:@";"];
        BOOL searchForPlaceAnyway = YES;
        if ([[EGOCache globalCache] hasCacheForKey:cacheKey]){
            id object = [[EGOCache globalCache] arrayForKey:cacheKey];
            if([object isKindOfClass:[NSArray class]]){
                NSArray *venues = (NSArray *) object;
//                if(ids.count>0){
//                    searchForPlaceAnyway = NO;
//                    [ids enumerateObjectsUsingBlock:^(NSString *pid, NSUInteger idx, BOOL *stop) {
//                        NSDictionary * place = (NSDictionary *)[[EGOCache globalCache] objectForKey:pid];
//                        [presetResult addObject:place];
//                    }];
//                }
            }
        }

        if(searchForPlaceAnyway){
            [LiiF3rdPartyEngine searchFoursquarePlaceName:place[@"name"] inCityName:place[@"city"]
              callback:^(BOOL success, id result)
              {
                  NSArray *venues = (NSArray *)result;
                  if(venues.count>0){
//                      NSMutableArray *ids = [ NSMutableArray array];
//                      [venues enumerateObjectsUsingBlock:^(NSDictionary * place, NSUInteger idx, BOOL *stop) {
//                          NSString *pid = place[@"id"];
//                          [[EGOCache globalCache] setObject:place forKey:pid];
//                          [ids addObject:pid];
//                      }];
                      [[EGOCache globalCache] setArray:venues forKey:cacheKey];
//                      [[EGOCache globalCache] setObject:ids forKey:cacheKey];
                  }
                  [presetResult addObjectsFromArray:venues];
                  NSLog(@"%@ ==> %@",place, venues);
            }];
        }

    }];
    NSLog(@"preset %d", presetResult.count);
    return nil;
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
* Search for a place results
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
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/food/salad_";
                            suffix = ".png";
                        };
                        id = 4bf58dd8d48988d1bd941735;
                        name = "Salad Place";
                        pluralName = "Salad Shop";
                        primary = 1;
                        shortName = Salad;
                    }
                );
                contact =                 {
                    formattedPhone = "(415) 296-8009";
                    phone = 4152968009;
                    twitter = mixtgreens;
                };
                hereNow =                 {
                    count = 0;
                    groups =                     (
                    );
                };
                id = 4db86b2e93a0f369e859a496;
                location =                 {
                    address = "70 Mission St";
                    cc = US;
                    city = "San Francisco";
                    country = "United States";
                    crossStreet = "at Spear St";
                    lat = "37.79283179653038";
                    lng = "-122.3939154678451";
                    postalCode = 94105;
                    state = CA;
                };
                name = "Mixt Greens";
                referralId = "v-1395511022";
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 4215;
                    tipCount = 25;
                    usersCount = 979;
                };
                verified = 0;
            },
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/food/salad_";
                            suffix = ".png";
                        };
                        id = 4bf58dd8d48988d1bd941735;
                        name = "Salad Place";
                        pluralName = "Salad Shop";
                        primary = 1;
                        shortName = Salad;
                    }
                );
                contact =                 {
                    formattedPhone = "(415) 543-2505";
                    phone = 4155432505;
                    twitter = mixtgreens;
                };
                hereNow =                 {
                    count = 0;
                    groups =                     (
                    );
                };
                id = 4a03132af964a52087711fe3;
                location =                 {
                    address = "560 Mission St";
                    cc = US;
                    city = "San Francisco";
                    country = "United States";
                    crossStreet = "btwn 1st & 2nd";
                    lat = "37.78881250057032";
                    lng = "-122.3989106808852";
                    postalCode = 94105;
                    state = CA;
                };
                menu =                 {
                    anchor = "View Menu";
                    label = Menu;
                    mobileUrl = "https://foursquare.com/v/4a03132af964a52087711fe3/device_menu";
                    type = Menu;
                    url = "https://foursquare.com/v/mixt-greens/4a03132af964a52087711fe3/menu";
                };
                name = "Mixt Greens";
                referralId = "v-1395511022";
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 5541;
                    tipCount = 30;
                    usersCount = 1826;
                };
                verified = 0;
            },
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/food/vegetarian_";
                            suffix = ".png";
                        };
                        id = 4bf58dd8d48988d1d3941735;
                        name = "Vegetarian / Vegan Restaurant";
                        pluralName = "Vegetarian / Vegan Restaurants";
                        primary = 1;
                        shortName = "Vegetarian / Vegan";
                    }
                );
                contact =                 {
                    formattedPhone = "(415) 771-6222";
                    phone = 4157716222;
                };
                hereNow =                 {
                    count = 0;
                    groups =                     (
                    );
                };
                id = 4a1c397bf964a520257b1fe3;
                location =                 {
                    address = "Building A";
                    cc = US;
                    city = "San Francisco";
                    country = "United States";
                    crossStreet = "Fort Mason Center";
                    lat = "37.80666460115532";
                    lng = "-122.4322199821472";
                    postalCode = 94123;
                    state = CA;
                };
                menu =                 {
                    anchor = "View Menu";
                    label = Menu;
                    mobileUrl = "https://foursquare.com/v/4a1c397bf964a520257b1fe3/device_menu";
                    type = Menu;
                    url = "https://foursquare.com/v/greens-restaurant/4a1c397bf964a520257b1fe3/menu";
                };
                name = "Greens Restaurant";
                referralId = "v-1395511022";
                reservations =                 {
                    url = "http://www.opentable.com/single.aspx?rid=3135&ref=9601";
                };
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 4514;
                    tipCount = 58;
                    usersCount = 3335;
                };
                url = "http://www.greensrestaurant.com";
                verified = 0;
            },
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/food/salad_";
                            suffix = ".png";
                        };
                        id = 4bf58dd8d48988d1bd941735;
                        name = "Salad Place";
                        pluralName = "Salad Shop";
                        primary = 1;
                        shortName = Salad;
                    }
                );
                contact =                 {
                    formattedPhone = "(415) 296-8009";
                    phone = 4152968009;
                };
                delivery =                 {
                    provider =                     {
                        name = seamless;
                    };
                    url = "http://www.seamless.com/food-delivery/restaurant.8988.r?a=1026&utm_source=Foursquare&utm_medium=affiliate&utm_campaign=SeamlessOrderDeliveryLink";
                };
                hereNow =                 {
                    count = 0;
                    groups =                     (
                    );
                };
                id = 4a0312fff964a52086711fe3;
                location =                 {
                    address = "475 Sansome St";
                    cc = US;
                    city = "San Francisco";
                    country = "United States";
                    crossStreet = "at Commercial St.";
                    lat = "37.79439782855281";
                    lng = "-122.4017071723938";
                    postalCode = 94111;
                    state = CA;
                };
                menu =                 {
                    anchor = "View Menu";
                    label = Menu;
                    mobileUrl = "https://foursquare.com/v/4a0312fff964a52086711fe3/device_menu";
                    type = Menu;
                    url = "https://foursquare.com/v/mixt-greens/4a0312fff964a52086711fe3/menu";
                };
                name = "Mixt Greens";
                referralId = "v-1395511022";
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 5669;
                    tipCount = 33;
                    usersCount = 1515;
                };
                verified = 1;
            },
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/food/salad_";
                            suffix = ".png";
                        };
                        id = 4bf58dd8d48988d1bd941735;
                        name = "Salad Place";
                        pluralName = "Salad Shop";
                        primary = 1;
                        shortName = Salad;
                    }
                );
                contact =                 {
                    formattedPhone = "(415) 296-8009";
                    phone = 4152968009;
                };
                hereNow =                 {
                    count = 0;
                    groups =                     (
                    );
                };
                id = 4a98387af964a520132b20e3;
                location =                 {
                    address = "120 Sansome St";
                    cc = US;
                    city = "San Francisco";
                    country = "United States";
                    crossStreet = "btw Bush & Pine";
                    lat = "37.79153429934465";
                    lng = "-122.4007576704025";
                    postalCode = 94104;
                    state = CA;
                };
                menu =                 {
                    anchor = "View Menu";
                    label = Menu;
                    mobileUrl = "https://foursquare.com/v/4a98387af964a520132b20e3/device_menu";
                    type = Menu;
                    url = "https://foursquare.com/v/mixt-greens-san-francisco-ca/4a98387af964a520132b20e3/menu";
                };
                name = "Mixt Greens";
                referralId = "v-1395511022";
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 4134;
                    tipCount = 22;
                    usersCount = 1344;
                };
                verified = 1;
            },
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/parks_outdoors/neighborhood_";
                            suffix = ".png";
                        };
                        id = 4f2a25ac4b909258e854f55f;
                        name = Neighborhood;
                        pluralName = Neighborhoods;
                        primary = 1;
                        shortName = Neighborhood;
                    }
                );
                contact =                 {
                };
                hereNow =                 {
                    count = 0;
                    groups =                     (
                    );
                };
                id = 4c324eaa16adc928f5ecc19c;
                location =                 {
                    cc = US;
                    country = "United States";
                    lat = "37.78410369711909";
                    lng = "-122.4124574661255";
                };
                name = "The Tenderloin";
                referralId = "v-1395511022";
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 6669;
                    tipCount = 27;
                    usersCount = 1183;
                };
                verified = 0;
            },
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/nightlife/sportsbar_";
                            suffix = ".png";
                        };
                        id = 4bf58dd8d48988d11d941735;
                        name = "Sports Bar";
                        pluralName = "Sports Bars";
                        primary = 1;
                        shortName = "Sports Bar";
                    }
                );
                contact =                 {
                    formattedPhone = "(415) 775-4287";
                    phone = 4157754287;
                };
                hereNow =                 {
                    count = 1;
                    groups =                     (
                                                {
                            count = 1;
                            items =                             (
                            );
                            name = "Other people here";
                            type = others;
                        }
                    );
                };
                id = 43ca26fef964a520a72d1fe3;
                location =                 {
                    address = "2239 Polk St";
                    cc = US;
                    city = "San Francisco";
                    country = "United States";
                    crossStreet = "at Green";
                    lat = "37.79749226531914";
                    lng = "-122.4221777915955";
                    postalCode = 94109;
                    state = CA;
                };
                name = "Greens Sports Bar";
                referralId = "v-1395511022";
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 6573;
                    tipCount = 27;
                    usersCount = 3175;
                };
                url = "http://sfstation.com/app/redir.php?biid=7986&res=09c9f69660713a340add005c4ed46531";
                verified = 0;
            },
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/food/salad_";
                            suffix = ".png";
                        };
                        id = 4bf58dd8d48988d1bd941735;
                        name = "Salad Place";
                        pluralName = "Salad Shop";
                        primary = 1;
                        shortName = Salad;
                    }
                );
                contact =                 {
                    formattedPhone = "(415) 296-8009";
                    phone = 4152968009;
                    twitter = mixtgreens;
                };
                hereNow =                 {
                    count = 0;
                    groups =                     (
                    );
                };
                id = 5244ba1704931cdd43166244;
                location =                 {
                    address = "475 Sansome St Ste 100S";
                    cc = US;
                    city = "San Francisco";
                    country = "United States";
                    crossStreet = "California and Davis";
                    lat = "37.79372805668303";
                    lng = "-122.3979091644287";
                    postalCode = 94111;
                    state = CA;
                };
                name = "Mixt Greens";
                referralId = "v-1395511022";
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 199;
                    tipCount = 1;
                    usersCount = 82;
                };
                verified = 0;
            },
                        {
                categories =                 (
                                        {
                        icon =                         {
                            prefix = "https://ss1.4sqi.net/img/categories_v2/food/salad_";
                            suffix = ".png";
                        };
                        id = 4bf58dd8d48988d1bd941735;
                        name = "Salad Place";
                        pluralName = "Salad Shop";
                        primary = 1;
                        shortName = Salad;
                    }
                );
                contact =                 {
                };
                hereNow =                 {
                    count = 0;
                    groups =                     (
                    );
                };
                id = 5303c007498ee6c11fb8899e;
                location =                 {
                    address = "100 California Street";
                    cc = US;
                    city = "San Francisco";
                    country = "United States";
                    lat = "37.79356702610981";
                    lng = "-122.3976383899926";
                    state = CA;
                };
                name = "Mixt Greens";
                referralId = "v-1395511022";
                specials =                 {
                    count = 0;
                    items =                     (
                    );
                };
                stats =                 {
                    checkinsCount = 26;
                    tipCount = 0;
                    usersCount = 22;
                };
                verified = 0;
            }
        );
    };
}

*/
@end