//
//  LiiFBusinessPlaceCollectionFlowLayout.m
//  FRP
//

#import "LiiFBusinessPlaceCollectionFlowLayout.h"

@implementation LiiFBusinessPlaceCollectionFlowLayout

-(instancetype)init {
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(300, 100.0);
    self.minimumInteritemSpacing = 2;
    self.minimumLineSpacing = 2;
    self.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
//    self.headerReferenceSize = CGSizeMake(320, 44);
    return self;
}

@end
