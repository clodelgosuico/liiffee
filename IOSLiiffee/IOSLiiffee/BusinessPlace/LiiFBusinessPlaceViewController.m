//
// Created by Agathe Battestini on 3/22/14.
// Copyright (c) 2014 Liiffee. All rights reserved.
//

#import "LiiFBusinessPlaceViewController.h"
#import "LiiFBusinessPlaceViewModel.h"
#import "LiiFBusinessPlaceCollectionFlowLayout.h"
#import "LiiFToolbarCellView.h"

@interface LiiFBusinessPlaceViewController()<UICollectionViewDelegateFlowLayout,
        UICollectionViewDelegate, UICollectionViewDataSource, LiiFToolbarCellViewDelegate>

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
    self.collectionView.delaysContentTouches = NO;

    self.title = self.viewModel.foursquarePlace[@"name"];

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
    [[self rac_signalForSelector:@selector(liiFToolbarCellView:didSelectGridMode:)
                    fromProtocol:@protocol(LiiFToolbarCellViewDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"grid selected ");
        self.viewModel.bottomSectionMode = @0;
    }];

    [[self rac_signalForSelector:@selector(liiFToolbarCellView:didSelectDealsMode:)
                    fromProtocol:@protocol(LiiFToolbarCellViewDelegate)] subscribeNext:^(id x) {
        @strongify(self);
        NSLog(@"deals selected ");
        self.viewModel.bottomSectionMode = @2;
    }];

    // Need to "reset" the cached values of respondsToSelector: of UIKit
    self.collectionView.delegate = self;
}


#pragma mark - Views

- (UICollectionView *)collectionView {
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor liifWhite];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.viewModel registerCollectionViewCellClasses:_collectionView];
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
    NSString *cellIdentifier = [self.viewModel cellIdentifierAtIndexPath:indexPath];
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                            forIndexPath:indexPath];
    NSArray * rows = self.viewModel.sections[indexPath.section];
    id object = rows[indexPath.row];
    if([cell respondsToSelector:@selector(setDataObject:)]){
        [cell performSelector:@selector(setDataObject:) withObject:object];
    }
    else{
//        cell.backgroundColor = [UIColor liifBarelyGray];
//        UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.attributedText = [[NSAttributedString alloc] initWithString:@"?"
//                               attributes:[UIFont liifStringAttributesWithSize:26.0f
//                                             withColor:[UIColor liifDarkText]]];
//        [cell addSubview:label];
    }
    if([cell isKindOfClass:[LiiFToolbarCellView class]]){
        [(LiiFToolbarCellView *) cell setToolbarDelegate:self];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.viewModel.sections.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    CGSize result;
    return [self.viewModel sizeForItemAtIndexPath:indexPath];
//    return result;
}


@end