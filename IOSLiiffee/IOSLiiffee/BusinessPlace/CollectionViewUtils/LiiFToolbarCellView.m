//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFToolbarCellView.h"

@interface LiiFToolbarCellView()

@property (nonatomic, strong) UIButton *gridButton;
@property (nonatomic, strong) UIButton *listButton;
@property (nonatomic, strong) UIButton *mapButton;
@property (nonatomic, strong) UIButton *dealsButton;

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *bottomLine;


@end

@implementation LiiFToolbarCellView {

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    // Configure self
    self.backgroundColor = [UIColor liifBarelyGray];

    [self setupViews];
    [self setupLayout];

    @weakify(self);
    [[RACObserve(self, sectionMode) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify(self);
        if(x){
//            NSLog(@"new mode %d", self.sectionMode.integerValue);
            self.gridButton.selected = NO;
            self.dealsButton.selected = NO;
            switch (self.sectionMode.integerValue){
                case 0:{
                    self.gridButton.selected = YES;
                    break;
                }
                case 2:{
                    self.dealsButton.selected = YES;
                    break;
                }
            }
        }
    }];

    self.gridButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.toolbarDelegate liiFToolbarCellView:self didSelectGridMode:YES];
        self.sectionMode = @0;
        return [RACSignal empty];
    }];

    self.dealsButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.toolbarDelegate liiFToolbarCellView:self didSelectDealsMode:YES];
        self.sectionMode = @2;
        return [RACSignal empty];
    }];

    // default is grid
    self.sectionMode = @0;

    return self;
}

- (void)setupViews
{
    [self.contentView addSubview:self.gridButton];
    [self.contentView addSubview:self.listButton];
    [self.contentView addSubview:self.mapButton];
    [self.contentView addSubview:self.dealsButton];
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.bottomLine];
}

- (void)setupLayout
{
    CGFloat spacing = 8.0f *3.0;

    [self.gridButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.left).with.offset(spacing + 24.0f);
        make.centerY.equalTo(self.contentView.centerY);
        make.height.equalTo(self.contentView.height).with.offset(-8.0f);
        make.height.equalTo(self.gridButton.width);
    }];

    [self.listButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.gridButton.right).with.offset(spacing);
        make.centerY.equalTo(self.gridButton.centerY);
        make.width.equalTo(self.gridButton.width);
        make.height.equalTo(self.gridButton.height);
    }];
    [self.mapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.listButton.right).with.offset(spacing);
        make.centerY.equalTo(self.gridButton.centerY);
        make.width.equalTo(self.gridButton.width);
        make.height.equalTo(self.gridButton.height);
    }];
    [self.dealsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mapButton.right).with.offset(spacing);
        make.centerY.equalTo(self.gridButton.centerY);
        make.width.equalTo(self.gridButton.width);
        make.height.equalTo(self.gridButton.height);
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.top.equalTo(self.contentView.top);
        make.width.equalTo(self.contentView.width);
        make.height.equalTo(@1.5f);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.centerX);
        make.bottom.equalTo(self.contentView.bottom);
        make.width.equalTo(self.contentView.width);
        make.height.equalTo(@1.5f);
    }];
}

#pragma mark - views

- (UIButton *)gridButton {
    if(!_gridButton){
        _gridButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gridButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_gridButton setImage:[UIImage imageNamed:@"GridGray"] forState:UIControlStateNormal];
        [_gridButton setImage:[UIImage imageNamed:@"GridGreen"] forState:UIControlStateHighlighted];
        [_gridButton setImage:[UIImage imageNamed:@"GridGreen"] forState:UIControlStateSelected];
//        _gridButton.backgroundColor = [UIColor randomColor];
    }
    return _gridButton;
}

- (UIButton *)listButton {
    if(!_listButton){
        _listButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _listButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_listButton setImage:[UIImage imageNamed:@"ListGray"] forState:UIControlStateNormal];
        [_listButton setImage:[UIImage imageNamed:@"ListGreen"] forState:UIControlStateHighlighted];
        [_listButton setImage:[UIImage imageNamed:@"ListGreen"] forState:UIControlStateSelected];
//        _listButton.backgroundColor = [UIColor randomColor];
    }
    return _listButton;
}

- (UIButton *)mapButton {
    if(!_mapButton){
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mapButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_mapButton setImage:[UIImage imageNamed:@"MapGray"] forState:UIControlStateNormal];
        [_mapButton setImage:[UIImage imageNamed:@"MapGreen"] forState:UIControlStateHighlighted];
        [_mapButton setImage:[UIImage imageNamed:@"MapGreen"] forState:UIControlStateSelected];
//        _mapButton.backgroundColor = [UIColor randomColor];
    }
    return _mapButton;
}

- (UIButton *)dealsButton {
    if(!_dealsButton){
        _dealsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dealsButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_dealsButton setImage:[UIImage imageNamed:@"DealsGray"] forState:UIControlStateNormal];
        [_dealsButton setImage:[UIImage imageNamed:@"DealsGreen"] forState:UIControlStateHighlighted];
        [_dealsButton setImage:[UIImage imageNamed:@"DealsGreen"] forState:UIControlStateSelected];
//        _dealsButton.backgroundColor = [UIColor randomColor];
    }
    return _dealsButton;
}

- (UIView *)topLine {
    if(!_topLine){
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor liifDarkText];
        _topLine.opaque = NO;
        _topLine.alpha = 0.4f;
    }
    return _topLine;
}

- (UIView *)bottomLine {
    if(!_bottomLine){
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor liifDarkText];
        _bottomLine.opaque = NO;
        _bottomLine.alpha = 0.4f;
    }
    return _bottomLine;
}




#pragma mark - Setting data object

//- (void)setDataObject:(id)object
//{
//    if(!object || object == [NSNull null]){
//        return ;
//    }
////    NSDictionary *foursquarePlace = (NSDictionary *)object;
////    self.titleLabel.text = foursquarePlace[@"name"];
////    NSAttributedString *string = [[NSAttributedString alloc] initWithString:foursquarePlace[@"name"]
////                                                                 attributes:[UIFont liifStringAttributesWithSize:24.0f withColor:[UIColor liifDarkText]]];
////    self.titleLabel.attributedText = string;
//}

@end