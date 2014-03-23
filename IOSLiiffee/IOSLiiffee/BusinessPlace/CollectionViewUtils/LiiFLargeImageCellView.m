//
// Created by Agathe Battestini on 3/23/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFLargeImageCellView.h"
#import "UIImageView+AFNetworking.h"

@interface LiiFLargeImageCellView()


@end

@implementation LiiFLargeImageCellView {

}

- (void)setDataObject:(id)object
{
    if(!object || object == [NSNull null]){
        return ;
    }

    if([object isKindOfClass:[InstagramMedia class]]){
        InstagramMedia *media = (InstagramMedia *) object;
        [self.imageView setImageWithURL:media.standardResolutionImageURL];
    }
    else {
        NSString *title = @"";
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *info = (NSDictionary *) object;
            if(info[@"message"])
                title = info[@"message"];
        }
        self.imageView.backgroundColor = [UIColor liifSubtleGray];
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:title
                                                                     attributes:[UIFont liifStringAttributesWithSize:12.0f withColor:[UIColor liifDarkText]]];
        self.titleLabel.attributedText = string;
    }
//    NSDictionary *foursquarePlace = (NSDictionary *)object;
//    self.titleLabel.text = foursquarePlace[@"name"];
}

- (void)setupViews {
    [super setupViews];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setupLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.centerY.equalTo(self.contentView.centerY);
        make.width.equalTo(self.contentView.width).with.offset(-16.0f);
        make.height.equalTo(self.contentView.height).with.offset(-16.0f);

    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

}



@end