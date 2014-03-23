//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFImageCellView.h"
#import "UIImageView+AFNetworking.h"



@implementation LiiFImageCellView {

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    // Configure self
    self.backgroundColor = [UIColor liifWhite];

    [self setupViews];
    [self setupLayout];

    return self;
}

- (void)setupViews
{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
}

- (void)setupLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(self.contentView.width).with.offset(-8.0f);
        make.height.equalTo(self.contentView.height).with.offset(-8.0f);

    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

}

#pragma mark - views

- (UILabel *)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _imageView;
}

#pragma mark - Setting data object

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.titleLabel.attributedText = nil;
}

- (void)setDataObject:(id)object
{
    if(!object || object == [NSNull null]){
        return ;
    }

    if([object isKindOfClass:[InstagramMedia class]]){
        InstagramMedia *media = (InstagramMedia *) object;
        [self.imageView setImageWithURL:media.thumbnailURL];
    }
    else {
        NSString *title = @"";
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *info = (NSDictionary *) object;
            if(info[@"message"])
                title = info[@"message"];
        }
        self.imageView.backgroundColor = [UIColor liifBarelyGray];
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:title
                     attributes:[UIFont liifStringAttributesWithSize:12.0f withColor:[UIColor liifDarkText]]];
        self.titleLabel.attributedText = string;
    }
//    NSDictionary *foursquarePlace = (NSDictionary *)object;
//    self.titleLabel.text = foursquarePlace[@"name"];
}

@end