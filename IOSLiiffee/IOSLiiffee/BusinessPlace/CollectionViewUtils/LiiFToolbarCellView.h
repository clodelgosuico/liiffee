//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LiiFToolbarCellView;

@protocol LiiFToolbarCellViewDelegate

- (void)liiFToolbarCellView:(LiiFToolbarCellView*)toolbarCellView didSelectGridMode:(BOOL)flag;
- (void)liiFToolbarCellView:(LiiFToolbarCellView*)toolbarCellView didSelectListMode:(BOOL)flag;
- (void)liiFToolbarCellView:(LiiFToolbarCellView*)toolbarCellView didSelectDealsMode:(BOOL)flag;

@end

@interface LiiFToolbarCellView : UICollectionViewCell

/* 0:grid 1:list 2:deals */
@property (nonatomic, strong) NSNumber *sectionMode;

@property (nonatomic, assign) id<LiiFToolbarCellViewDelegate>toolbarDelegate;


@end