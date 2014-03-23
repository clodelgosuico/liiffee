//
// Created by Agathe Battestini on 3/23/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LiiFDealCellView.h"

@interface LiiFDealCellView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *buttonView;

//@property (nonatomic, strong) UIView *labelBackgroundView;


@end

@implementation LiiFDealCellView {

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    // Configure self
    self.backgroundColor = [UIColor liifBarelyGray];
//    self.backgroundColor = [UIColor randomColor];
    [self setupViews];
    [self setupLayout];

    return self;
}

- (void)setupViews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.buttonView];
}

- (void)setupLayout
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).with.offset(8.0f);
        make.centerY.equalTo(self.contentView.centerY);
        make.height.equalTo(self.contentView.height).with.offset(-8.0f);
        make.width.equalTo(self.imageView.height);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.right).with.offset(8.0f);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.right).with.offset(8.0f);
        make.right.equalTo(self.contentView.right).with.offset(-8.0f);
        make.width.greaterThanOrEqualTo(@70.0f).with.priority(500.0f);
        make.centerY.equalTo(self.contentView.centerY);
    }];
}

#pragma mark - views

- (UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.numberOfLines = 0;
//        _titleLabel.backgroundColor = [UIColor randomColor];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
//        _imageView.backgroundColor = [UIColor randomColor];
    }
    return _imageView;
}

- (UIButton *)buttonView {
    if(!_buttonView){
        _buttonView = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"Order"
                         attributes:[UIFont liifStringAttributesWithSize:16.0f withColor:[UIColor liifDarkText]]];
        _buttonView.backgroundColor = [UIColor liifActiveIcon];
        _buttonView.layer.cornerRadius = 4.0f;
        _buttonView.contentEdgeInsets = UIEdgeInsetsMake(4.0f, 8.0f, 4.0f, 8.0f);
        [_buttonView setAttributedTitle:string forState:UIControlStateNormal];
    }
    return _buttonView;
}



#pragma mark - Setting data object

- (void)setDataObject:(id)object
{
    if(!object || object == [NSNull null]){
        return ;
    }

    self.titleLabel.text = @"menu";
    if([object isKindOfClass:[NSDictionary class]]){
        NSDictionary *info = (NSDictionary *)object;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]
                initWithString:info[@"title"]
                    attributes:[UIFont liifStringAttributesWithSize:14.0f withColor:[UIColor liifDarkText]]];
        self.titleLabel.attributedText = string;

        NSInteger number = arc4random() % 4;
        NSURL *url = [[NSURL alloc] initWithString:info[@"url"]];
//        [self.imageView setImageWithURL:url];
        NSString *image = [NSString stringWithFormat:@"SaladSample%d", number];
        self.imageView.image = [UIImage imageNamed:image];
    }
}

@end