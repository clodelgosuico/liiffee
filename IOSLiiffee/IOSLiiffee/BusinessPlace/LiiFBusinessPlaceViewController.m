//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFBusinessPlaceViewController.h"
#import "LiiFBusinessPlaceViewModel.h"
#import "LiiFBusinessPlaceCollectionFlowLayout.h"

@interface LiiFBusinessPlaceViewController()<UICollectionViewDelegateFlowLayout,
        UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) LiiFBusinessPlaceViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@end

@implementation LiiFBusinessPlaceViewController {

}
- (instancetype)init{
    self = [self initWithFoursquarePlace:nil];
    return self;
}

- (instancetype)initWithFoursquarePlace:(NSDictionary*)foursquarePlace {
    self = [super init];
    if(!self) return nil;
    self.viewModel = [[LiiFBusinessPlaceViewModel alloc] initWithFoursquarePlace:foursquarePlace];
    return self;
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self setupLayout];
    [self setupViewModelConnections];

    @weakify(self);
    [RACObserve(self.viewModel, sections) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewModel.active = YES; // will trigger fetching data from the network / cache
}

#pragma mark - Setting up view and model

- (void)setupLayout
{

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupViewModelConnections
{
    @weakify(self);
//    [RACObserve(self.viewModel, topCategories) subscribeNext:^(id x) {
//        @strongify(self);
//        [self.collectionView reloadData];
//    }];
//
//    [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)]
//            subscribeNext:^(RACTuple *arguments) {
//                @strongify(self);
//                NSIndexPath *indexPath = arguments.second;
//                StvyEntityCategory *category = [self.viewModel objectForIndexPath:indexPath];
//                // XXX TODO init products list view model with category
//                StuiProductsListViewController *viewController = [[StuiProductsListViewController alloc] init];
//                [self.navigationController pushViewController:viewController animated:YES];
//            }];
    // Need to "reset" the cached values of respondsToSelector: of UIKit
    self.collectionView.delegate = self;
}


#pragma mark - Views

- (UICollectionView *)collectionView {
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor liifBarelyGray];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
//        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CategoryCellIdentifier];
        _collectionView.bounces = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.scrollEnabled = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if(!_collectionViewFlowLayout){
        _collectionViewFlowLayout = [[LiiFBusinessPlaceCollectionFlowLayout alloc] init];
    }
    return _collectionViewFlowLayout;
}

#pragma mark - collection view
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [(NSArray *)self.viewModel.sections[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryCellIdentifier
//                                                                            forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor stuiSubtleGray];
//    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
//    StvyEntityCategory *category = [self.viewModel objectForIndexPath:indexPath];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.attributedText = [[NSAttributedString alloc] initWithString:category.name
//                                                           attributes:[UIFont stuiStringAttributesWithSize:26.0f
//                                                                                                 withColor:[UIColor stuiDarkGray]]];
//    [cell addSubview:label];
//    return cell;
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.sections.count;
}


@end