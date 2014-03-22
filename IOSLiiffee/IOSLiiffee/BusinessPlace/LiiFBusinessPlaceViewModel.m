//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFBusinessPlaceViewModel.h"

static NSString* TitleCellIdentifier = @"TitleCell";
static NSString* InfoCellIdentifier = @"InfoCell";
static NSString* ToolbarCellIdentifier = @"ToolbarCell";
static NSString* ImageCellIdentifier = @"ImageCell";


@implementation LiiFBusinessPlaceViewModel {

}

- (instancetype)initWithFoursquarePlace:(NSDictionary *)foursquarePlace {
    self = [super init];
    if(!self) return nil;

    self.foursquarePlace = foursquarePlace;

    @weakify(self);

    [RACObserve(self, foursquarePlace) subscribeNext:^(id x) {
       @strongify(self);
        [self prepareData];
    }];
    [self.didBecomeActiveSignal subscribeNext:^(id x) {
        // TODO get instagram images for the place

    }];

    return self;
}

- (void)prepareData
{
    NSMutableArray *sections = [NSMutableArray array];
    if(self.foursquarePlace){
        NSArray *titleSection = @[self.foursquarePlace];
        NSArray *infoSection = @[self.foursquarePlace];
        NSArray *toolbarSection = @[[NSNull null]];
        NSArray *imagesSection = @[@{@"url": @""}];

    }

    self.sections = sections;
}

#pragma mark - Collection View

- (void)registerCollectionViewCellClasses:(UICollectionView*)collectionView
{
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:TitleCellIdentifier];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:InfoCellIdentifier];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ToolbarCellIdentifier];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ImageCellIdentifier];
}

- (NSString*)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
    return TitleCellIdentifier;
}



@end