//
//  LiiFTitleCellView.m
//  IOSLiiffee
//
//  Created by Agathe Battestini on 3/22/14.
//  Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFTitleCellView.h"
@interface LiiFTitleCellView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LiiFTitleCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    // Configure self
    self.backgroundColor = [UIColor clearColor];

    [self setupViews];
    [self setupLayout];

//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [self.contentView addSubview:imageView];

    return self;
}

- (void)setupViews
{
    [self.contentView addSubview:self.titleLabel];
}

- (void)setupLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - views

- (UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

#pragma mark - Setting data object

- (void)setDataObject:(id)object
{
    if(!object || object == [NSNull null]){
        return ;
    }
    NSDictionary *foursquarePlace = (NSDictionary *)object;
    self.titleLabel.text = foursquarePlace[@"name"];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:foursquarePlace[@"name"]
                         attributes:[UIFont liifStringAttributesWithSize:24.0f withColor:[UIColor liifDarkText]]];
    self.titleLabel.attributedText = string;
}



@end
