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
typedef CGSize(^WUCollectionViewSizeForItemHandler)(WUCollectionView *collectionView, UICollectionViewLayout *collectionViewLayout, NSIndexPath *indexPath);
typedef void(^WUCollectionViewWillDisplayCellHandler)(WUCollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath);
typedef void(^WUCollectionViewDidEndDisplayCellHandler)(WUCollectionView *collectionView, UICollectionViewCell *cell, NSIndexPath *indexPath);
typedef void(^WUCollectionViewDidSelectItemHandler)(WUCollectionView *collectionView, NSIndexPath *indexPath);
typedef void(^WUCollectionViewMoveItemCompletedHandler)(WUCollectionView *collectionView, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

@interface WUCollectionView : UICollectionView<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak, nullable) id<UICollectionViewDelegate> delegate NS_UNAVAILABLE;
@property(nonatomic, weak, nullable) id<UICollectionViewDataSource> dataSource NS_UNAVAILABLE;

@property(nonatomic, strong, nullable) NSMutableArray<WUSectionObject*> *datas;
/**
 是否启用拖动排列功能 默认NO
 */
@property(nonatomic, assign) BOOL interactiveMovementEnabled NS_AVAILABLE_IOS(9_0);
/**
 是否在moveItem完成时自动更新data中的数据 默认YES
 */
@property(nonatomic, assign) BOOL autoRefreshDataWhenMoveItemCompleted NS_AVAILABLE_IOS(9_0);

/**
 如果实现了此block，[WUDataSourceProtocol dataSourceSizeWithUserData:]将会被忽略
 */
@property(nonatomic, copy, nullable) WUCollectionViewSizeForItemHandler sizeForItemHandler;
@property(nonatomic, copy, nullable) WUCollectionViewWillDisplayCellHandler willDisplayCellHandler NS_AVAILABLE_IOS(8_0);
@property(nonatomic, copy, nullable) WUCollectionViewDidEndDisplayCellHandler didEndDisplayCellHandler NS_AVAILABLE_IOS(8_0);
@property(nonatomic, copy, nullable) WUCollectionViewDidSelectItemHandler didSelectItemHandler;
@property(nonatomic, copy, nullable) WUCollectionViewMoveItemCompletedHandler moveItemCompletedHandler NS_AVAILABLE_IOS(9_0);

/**
 返回点击cell的屏幕rect
 
 @param point 相对于tableView的点击point
 @return 如果没有对应的cell，返回CGRectNull
 */
-(CGRect)cellScreenRectWithTouchPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
