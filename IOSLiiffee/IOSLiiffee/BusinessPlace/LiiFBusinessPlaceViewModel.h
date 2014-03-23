//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVMViewModel.h"


@interface LiiFBusinessPlaceViewModel : RVMViewModel

@property (nonatomic, strong) NSDictionary *foursquarePlace;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, strong) NSArray *instagramMediaObjects;

/* Which data is shown in the bottom: 0: images, 1: list, 2: deals */
@property (nonatomic, strong) NSNumber *bottomSectionMode;

- (instancetype)initWithFoursquarePlace:(NSDictionary *)foursquarePlace;

- (void)registerCollectionViewCellClasses:(UICollectionView *)collectionView;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
@end