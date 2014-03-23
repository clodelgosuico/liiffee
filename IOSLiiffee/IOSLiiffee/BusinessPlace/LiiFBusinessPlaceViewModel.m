//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFBusinessPlaceViewModel.h"
#import "LiiFTitleCellView.h"
#import "LiiFImageCellView.h"
#import "LiiFInfoCellView.h"
#import "LiiFToolbarCellView.h"
#import "LiiF3rdPartyEngine.h"

static NSString* TitleCellIdentifier = @"TitleCell";
static NSString* InfoCellIdentifier = @"InfoCell";
static NSString* ToolbarCellIdentifier = @"ToolbarCell";
static NSString* ImageCellIdentifier = @"ImageCell";


@implementation LiiFBusinessPlaceViewModel {

}

- (instancetype)initWithFoursquarePlace:(NSDictionary *)foursquarePlace {
    self = [super init];
    if(!self) return nil;


    @weakify(self);

    [RACObserve(self, foursquarePlace) subscribeNext:^(id x) {
       @strongify(self);
        [self prepareData];
    }];
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        // TODO get instagram images for the place
        @strongify(self);
        [self getInstagramMedia];
    }];

    self.foursquarePlace = foursquarePlace;

    return self;
}

- (void)getInstagramMedia
{
    @weakify(self);
    [[LiiF3rdPartyEngine searchInstagramForFoursquarePlace:self.foursquarePlace] subscribeNext:^(id x) {
        @strongify(self);
        NSArray *mediaObjects = (NSArray *)x;
        self.instagramMediaObjects = mediaObjects;
        [self prepareData];
    }];
}

- (void)prepareData
{
    NSMutableArray *sections = [NSMutableArray array];
    if(self.foursquarePlace){
        NSArray *titleSection = @[self.foursquarePlace];
        NSArray *infoSection = @[self.foursquarePlace];
        NSArray *toolbarSection = @[[NSNull null]];

        [sections addObject:titleSection];
        [sections addObject:infoSection];
        [sections addObject:toolbarSection];

        NSMutableArray *imagesSection = [
                @[@{@"message" : @"Loading..."},
//                  @{@"url" : @""},
//                  @{@"url" : @""},
//                  @{@"url" : @""},
//                  @{@"url" : @""},
//                  @{@"url" : @""},
//                  @{@"url" : @""},
//                  @{@"url" : @""},
//                  @{@"url" : @""},
                ]
                mutableCopy];
        if(self.instagramMediaObjects){
            if(self.instagramMediaObjects.count > 0){
                [sections addObject:self.instagramMediaObjects];
            }
            else{
                [sections addObject:@[@{@"message" : @"No Photo Yet!"},]];
            }
        }
        else{
            [sections addObject:imagesSection];
        }
    }

    self.sections = sections;
}

#pragma mark - Collection View

- (void)registerCollectionViewCellClasses:(UICollectionView*)collectionView
{
    [collectionView registerClass:[LiiFTitleCellView class] forCellWithReuseIdentifier:TitleCellIdentifier];
    [collectionView registerClass:[LiiFInfoCellView class] forCellWithReuseIdentifier:InfoCellIdentifier];
    [collectionView registerClass:[LiiFToolbarCellView class] forCellWithReuseIdentifier:ToolbarCellIdentifier];
    [collectionView registerClass:[LiiFImageCellView class] forCellWithReuseIdentifier:ImageCellIdentifier];
}

- (NSString*)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section){
        case 0:{
            return TitleCellIdentifier;
        }
        case 1:
        {
            return InfoCellIdentifier;
        }
        case 2:
        {
            return ToolbarCellIdentifier;
        }
        case 3:
        {
            return ImageCellIdentifier;
        }


    }
    return TitleCellIdentifier;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize result;
    CGFloat screenWidth = 300.0f;
    switch (indexPath.section){
        case 0:{
            return CGSizeMake(screenWidth, 40.0f);
        }
        case 1:
        {
            return CGSizeMake(screenWidth - 8.0f, 120.0f);
        }
        case 2:
        {
            return CGSizeMake(screenWidth + 20.0f, 44.0f);;
        }
        case 3:
        {
            return CGSizeMake(100.0f, 100.0f);;
        }


    }
    return result;
}


@end