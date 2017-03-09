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

extern NSString *const WUTableHeaderFooterDefaultIdentifier;
extern NSString *const WUTableCellDefaultIdentifier;

#pragma mark -

typedef BOOL(^WUTableViewCanEditRowHandler)(WUTableView *tableView, NSIndexPath *indexPath);
typedef UITableViewCellEditingStyle(^WUTableViewEditingStyleForRowHandler)(WUTableView *tableView, NSIndexPath *indexPath);
typedef void(^WUTableViewCommitEditingStyleForRowHandler)(WUTableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath);
typedef NSArray<UITableViewRowAction *> * _Nullable (^WUTableViewEditForRowActionHandler)(WUTableView *tableView, NSIndexPath *indexPath);
typedef void(^WUTableViewWillDisplayCellHandler)(WUTableView *tableView, UITableViewCell *cell, NSIndexPath *indexPath);
typedef void(^WUTableViewDidSelectRowHandler)(WUTableView *tableView, NSIndexPath *indexPath);
typedef NSArray<NSString *> * _Nullable (^WUTableViewSectionIndexTitlesHandler)(WUTableView *tableView);
typedef BOOL(^WUTableViewCanMoveRowHandler)(WUTableView *tableView, NSIndexPath *indexPath);
typedef void(^WUTableViewMoveRowHandler)(WUTableView *tableView, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

#pragma mark -

@interface WUTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, weak, nullable) id<UITableViewDelegate> delegate NS_UNAVAILABLE;
@property(nonatomic, weak, nullable) id<UITableViewDataSource> dataSource NS_UNAVAILABLE;

@property(nonatomic, assign) BOOL deSelectWhenSelected;
@property(nonatomic, strong, nullable) NSArray<WUSectionObject*> *datas;

@property(nonatomic, copy, nullable) WUTableViewCanEditRowHandler canEditRowHandler;
@property(nonatomic, copy, nullable) WUTableViewEditingStyleForRowHandler editingStyleForRowHandler;
@property(nonatomic, copy, nullable) WUTableViewCommitEditingStyleForRowHandler commitEditingStyleForRowHandler;
@property(nonatomic, copy, nullable) WUTableViewEditForRowActionHandler editForRowActionHandler NS_AVAILABLE_IOS(8_0);
@property(nonatomic, copy, nullable) WUTableViewWillDisplayCellHandler willDisplayCellHandler;
@property(nonatomic, copy, nullable) WUTableViewDidSelectRowHandler didSelectRowHandler;
@property(nonatomic, copy, nullable) WUTableViewSectionIndexTitlesHandler sectionIndexTitlesHandler;
@property(nonatomic, copy, nullable) WUTableViewCanMoveRowHandler canMoveRowHandler;
@property(nonatomic, copy, nullable) WUTableViewMoveRowHandler moveRowHandler;

-(void)setNeedsUpdateCellHeightWithIndexPath:(NSIndexPath*)indexPath;
-(void)setNeedsUpdateAllCellsHeight;

@end

NS_ASSUME_NONNULL_END
