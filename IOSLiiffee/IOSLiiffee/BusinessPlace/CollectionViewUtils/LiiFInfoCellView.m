//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFInfoCellView.h"

@interface LiiFInfoCellView()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *labelBackgroundView;

@end


@implementation LiiFInfoCellView {

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    // Configure self
    self.backgroundColor = [UIColor clearColor];
    [self setupViews];
    [self setupLayout];

    return self;
}

- (void)setupViews
{
    [self.contentView addSubview:self.labelBackgroundView];
    [self.labelBackgroundView addSubview:self.titleLabel];
}

- (void)setupLayout
{
    [self.labelBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.labelBackgroundView);
        make.width.equalTo(self.labelBackgroundView.width).with.offset(-16.0f);
        make.height.equalTo(self.labelBackgroundView.height).with.offset(-0.0f);
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

- (UIView *)labelBackgroundView {
    if(!_labelBackgroundView){
        _labelBackgroundView = [[UIView alloc] init];
        _labelBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        _labelBackgroundView.backgroundColor = [UIColor liifBarelyGray];
        _labelBackgroundView.layer.cornerRadius = 8.0f;
    }
    return _labelBackgroundView;
}




#pragma mark - Setting data object

- (void)setDataObject:(id)object
{
    if(!object || object == [NSNull null]){
        return ;
    }
    NSDictionary *foursquarePlace = (NSDictionary *)object;

    NSString *address = [NSString stringWithFormat:@"Address:\n%@\n%@, %@, %@",
                    [foursquarePlace valueForKeyPath:@"location.address"],
                    [foursquarePlace valueForKeyPath:@"location.city"],
                    [foursquarePlace valueForKeyPath:@"location.state"],
                    [foursquarePlace valueForKeyPath:@"location.postalCode"]
    ];
    NSString *phone = [NSString stringWithFormat:@"Phone: %@",
                    [foursquarePlace valueForKeyPath:@"contact.formattedPhone"]
    ];
    NSString *hours = [NSString stringWithFormat:@"Hours: Mo-Fr: 11am-10pm, Sa-Su: 9am-11pm"
    ];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]
            initWithString:address
                attributes:[UIFont liifStringAttributesWithSize:14.0f withColor:[UIColor liifDarkText]]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"
                attributes:[UIFont liifStringAttributesWithSize:3.0f withColor:[UIColor liifDarkText]]]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:phone
                attributes:[UIFont liifStringAttributesWithSize:14.0f withColor:[UIColor liifDarkText]]]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"
                attributes:[UIFont liifStringAttributesWithSize:3.0f withColor:[UIColor liifDarkText]]]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:hours
                attributes:[UIFont liifStringAttributesWithSize:14.0f withColor:[UIColor liifDarkText]]]];

    self.titleLabel.attributedText = string;
}

@end