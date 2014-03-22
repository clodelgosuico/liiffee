//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RVMViewModel.h"


@interface LiiFBusinessPlaceViewModel : RVMViewModel

@property (nonatomic, strong) NSDictionary *foursquarePlace;
@property (nonatomic, strong) NSArray *sections;

- (instancetype)initWithFoursquarePlace:(NSDictionary *)foursquarePlace;

- (void)registerCollectionViewCellClasses:(UICollectionView *)collectionView;

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;
@end