//
//  WUTableView.h
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUDataSource.h"

@class WUTableView;

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^WUTableViewCanEditRowHandler)(WUTableView *tableView, NSIndexPath *indexPath);
typedef NSArray<UITableViewRowAction *> * _Nullable (^WUTableViewEditForRowActionHandler)(WUTableView *tableView, NSIndexPath *indexPath);
typedef void(^WUTableViewWillDisplayCellHandler)(WUTableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);
typedef void(^WUTableViewDidSelectRowHandler)(WUTableView *tableView, NSIndexPath *indexPath);
typedef NSArray<NSString *> * _Nullable (^WUTableViewSectionIndexTitlesHandler)(WUTableView *tableView);
typedef void(^WUTableViewMoveRowCompletedHandler)(WUTableView *tableView, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

#pragma mark -

@interface WUTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak, nullable) id<UITableViewDelegate> delegate NS_UNAVAILABLE;
@property(nonatomic, weak, nullable) id<UITableViewDataSource> dataSource NS_UNAVAILABLE;

/**
 在选中后是否自动取消选中效果 默认NO
 */
@property(nonatomic, assign) BOOL deSelectWhenSelected;
/**
 是否在moveRow完成时自动更新data中的数据 默认YES
 */
@property(nonatomic, assign) BOOL autoRefreshDataWhenMoveItemCompleted;

/**
 填充的数据（在刷新数据时，需主动调用reloadData方法）
 */
@property(nonatomic, strong, nullable) NSMutableArray<WUSectionObject*> *datas;

@property(nonatomic, copy, nullable) WUTableViewCanEditRowHandler canEditRowHandler;
@property(nonatomic, copy, nullable) WUTableViewEditForRowActionHandler editForRowActionHandler NS_AVAILABLE_IOS(8_0);
@property(nonatomic, copy, nullable) WUTableViewWillDisplayCellHandler willDisplayCellHandler;
@property(nonatomic, copy, nullable) WUTableViewDidSelectRowHandler didSelectRowHandler;
@property(nonatomic, copy, nullable) WUTableViewSectionIndexTitlesHandler sectionIndexTitlesHandler;
@property(nonatomic, copy, nullable) WUTableViewMoveRowCompletedHandler moveRowCompletedHandler;

/**
 需要重新计算cell的高度，(需要主动调用reload方法)

 @param indexPath NSIndexPath
 */
-(void)setNeedsUpdateCellHeightWithIndexPath:(NSIndexPath*)indexPath;
/**
 需要重新计算所有cell的高度，(需要主动调用reload方法)
 */
-(void)setNeedsUpdateAllCellsHeight;

/**
 返回点击cell的屏幕rect

 @param point 相对于tableView的点击point
 @return 如果没有对应的cell，返回CGRectNull
 */
-(CGRect)cellScreenRectWithTouchPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
