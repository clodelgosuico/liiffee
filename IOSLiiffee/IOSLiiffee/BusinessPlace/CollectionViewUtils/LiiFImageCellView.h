//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LiiFImageCellView;


/**
* CollectionViewCell for an instagram object
*/
@interface LiiFImageCellView : UICollectionViewCell

- (void)setDataObject:(id)object;
@end

@interface LiiFImageCellView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

- (void)setupViews;

- (void)setupLayout;
@end
