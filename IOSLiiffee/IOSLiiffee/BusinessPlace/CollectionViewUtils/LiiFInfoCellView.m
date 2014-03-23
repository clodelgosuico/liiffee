//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFInfoCellView.h"

@interface LiiFInfoCellView()

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation LiiFInfoCellView {

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    // Configure self
    self.backgroundColor = [UIColor liifBarelyGray];
    self.layer.cornerRadius = 8.0f;
    [self setupViews];
    [self setupLayout];

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