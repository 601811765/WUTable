//
//  WUCollectionView.h
//  WUTable
//
//  Created by 武探 on 2017/3/10.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUDataSource.h"

@class WUCollectionView;

NS_ASSUME_NONNULL_BEGIN

#pragma mark -

typedef void(^WUCollectionViewWillDisplayCellHandler)(WUCollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath);
typedef void(^WUCollectionViewDidSelectItemHandler)(WUCollectionView *collectionView, NSIndexPath *indexPath);
typedef BOOL(^WUCollectionViewCanMoveItemHandler)(WUCollectionView *collectionView, NSIndexPath *indexPath);
typedef void(^WUCollectionViewMoveItemHandler)(WUCollectionView *collectionView, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

@interface WUCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak, nullable) id<UICollectionViewDelegate> delegate NS_UNAVAILABLE;
@property(nonatomic, weak, nullable) id<UICollectionViewDataSource> dataSource NS_UNAVAILABLE;

@property(nonatomic, strong, nullable) NSMutableArray<WUSectionObject*> *datas;

@property(nonatomic, copy, nullable) WUCollectionViewWillDisplayCellHandler willDisplayCellHandler;
@property(nonatomic, copy, nullable) WUCollectionViewDidSelectItemHandler didSelectItemHandler;
@property(nonatomic, copy, nullable) WUCollectionViewCanMoveItemHandler canMoveItemHandler;
@property(nonatomic, copy, nullable) WUCollectionViewMoveItemHandler moveItemHandler;

@end

NS_ASSUME_NONNULL_END
