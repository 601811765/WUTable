//
//  WUTableView.m
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "WUTableView.h"
#import <objc/message.h>

#define WUTableMinLineHeight self.style == UITableViewStylePlain ? 0.0 : 0.1

@implementation WUTableView

@dynamic delegate;
@dynamic dataSource;

#pragma mark -

-(void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if(self) {
        [self initialize];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if(self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    [self setDelegateDataSource];
    self.autoRefreshDataWhenMoveItemCompleted = YES;
}

-(void)setDelegateDataSource {
    super.delegate = self;
    super.dataSource = self;
}

-(void)setDatas:(NSMutableArray<WUSectionObject *> *)datas {
    _datas = datas;
    
    if(!_datas || datas.count == 0) {
        return;
    }
    
    [self parseDatas];
}

-(void)parseDatas {
    [self registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:WUTableDefaultHeaderFooterIdentifier];
    for (WUSectionObject *obj in _datas) {
        if(!obj.header) {
            obj.header = [self defaultHeaderFooter];
        } else {
            if(!obj.header.registerClass) {
                obj.header.registerClass = [WUKeyValueItem itemWithKey:WUTableDefaultHeaderFooterIdentifier value:[UITableViewHeaderFooterView class]];
            } else {
                [self registerClass:obj.header.registerClass.value forHeaderFooterViewReuseIdentifier:obj.header.registerClass.key];
            }
        }
        
        if(!obj.footer) {
            obj.footer = [self defaultHeaderFooter];
        } else {
            if(!obj.footer.registerClass) {
                obj.header.registerClass = [WUKeyValueItem itemWithKey:WUTableDefaultHeaderFooterIdentifier value:[UITableViewHeaderFooterView class]];
            } else {
                [self registerClass:obj.footer.registerClass.value forHeaderFooterViewReuseIdentifier:obj.footer.registerClass.key];
            }
        }
        
        if(obj.cells) {
            for (WUCellObject *cell in obj.cells) {
                if(!cell.registerClass) {
                    cell.registerClass = [WUKeyValueItem itemWithKey:WUTableDefaultCellIdentifier value:[UITableViewCell class]];
                }
            }
        }
    }
}

-(WUHeaderFooterObject*)defaultHeaderFooter {
    WUHeaderFooterObject *headerFooter = [[WUHeaderFooterObject alloc] init];
    headerFooter.size = CGSizeMake(0, WUTableMinLineHeight);
    headerFooter.registerClass = [WUKeyValueItem itemWithKey:WUTableDefaultHeaderFooterIdentifier value:[UITableViewHeaderFooterView class]];
    return headerFooter;
}

-(WUCellObject*)cellObjectWithIndexPath:(NSIndexPath*)indexPath {
    WUSectionObject *sections = self.datas[indexPath.section];
    WUCellObject *obj = sections.cells[indexPath.row];
    return obj;
}

-(CGFloat)heightWithHeaderFooterObj:(WUHeaderFooterObject*)obj {
    if(!obj) {
        return 0;
    }
    
    CGFloat height = obj.size.height;
    if(height == WUNotFound) {
        Class cls = obj.registerClass.value;
        if([cls conformsToProtocol:@protocol(WUDataSourceProtocol)]) {
            CGSize size = [cls dataSourceSizeWithUserData:obj.userData];
            obj.size = size;
            height = size.height;
        } else {
            height = 0;
        }
    }
    
    return height;
}

-(void)callFillData:(id)userData target:(id)target userInfo:(id)userInfo {
    if([target conformsToProtocol:@protocol(WUDataSourceProtocol)]) {
        [target dataSourceFillWithUserData:userData];
        if([target respondsToSelector:@selector(dataSourceSetUserInfo:)]) {
            [target performSelector:@selector(dataSourceSetUserInfo:) withObject:userInfo];
        }
    }
}

#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WUSectionObject *s = self.datas[section];
    return s.cells.count;
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if(self.sectionIndexTitlesHandler) {
        return self.sectionIndexTitlesHandler(self);
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    WUSectionObject *s = self.datas[section];
    CGFloat height = [self heightWithHeaderFooterObj:s.header];
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WUSectionObject *s = self.datas[section];
    WUKeyValueItem<NSString*, Class> *header = s.header.registerClass;
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:header.key];
    headerView.textLabel.text = s.header.text;
    [self callFillData:s.header.userData target:headerView userInfo:s.header.userInfo];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    WUSectionObject *s = self.datas[section];
    CGFloat height = [self heightWithHeaderFooterObj:s.footer];
    return height;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WUSectionObject *s = self.datas[section];
    WUKeyValueItem<NSString*, Class> *footer = s.footer.registerClass;
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footer.key];
    footerView.textLabel.text = s.footer.text;
    [self callFillData:s.footer target:footerView userInfo:s.footer.userInfo];
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:indexPath];
    CGFloat height = obj.size.height;
    if(height == WUNotFound) {
        Class cls = obj.registerClass.value;
        if([cls conformsToProtocol:@protocol(WUDataSourceProtocol)]) {
            CGSize size = [cls dataSourceSizeWithUserData:obj.userData];
            obj.size = size;
            height = size.height;
        } else {
            height = 0;
        }
    }
    
    return height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:obj.registerClass.key];
    if(!cell) {
        cell = [[obj.registerClass.value alloc] initWithStyle:obj.style reuseIdentifier:obj.registerClass.key];
    }
    
    cell.textLabel.text = obj.text;
    cell.detailTextLabel.text = obj.detailText;
    cell.selectionStyle = obj.selectionStyle;
    cell.accessoryType = obj.accessoryType;
    if(obj.imageName) {
        cell.imageView.image = [UIImage imageNamed:obj.imageName];
    } else {
        cell.imageView.image = nil;
    }
    
    [self callFillData:obj.userData target:cell userInfo:obj.userInfo];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.willDisplayCellHandler) {
        self.willDisplayCellHandler(self, cell, indexPath);
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:indexPath];
    if(obj.target && obj.selectorString) {
        SEL selector = NSSelectorFromString(obj.selectorString);
        if([obj.target respondsToSelector:selector]) {
            ((void (*)(void *, SEL, NSIndexPath*))objc_msgSend)((__bridge void *)(obj.target), selector, indexPath);
        }
    }
    
    if(self.deSelectWhenSelected) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if(self.didSelectRowHandler) {
        self.didSelectRowHandler(self, indexPath);
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.canEditRowHandler) {
        return self.canEditRowHandler(self, indexPath);
    }
    return YES;
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.editForRowActionHandler) {
        return self.editForRowActionHandler(self, indexPath);
    }
    
    return nil;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:indexPath];
    return obj.canMove;
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:proposedDestinationIndexPath];
    if(!obj.canMove) {
        return sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if(self.autoRefreshDataWhenMoveItemCompleted) {
        WUSectionObject *sourceSection = self.datas[sourceIndexPath.section];
        WUCellObject *sourceObj = sourceSection.cells[sourceIndexPath.row];
        [sourceSection.cells removeObject:sourceObj];
        
        WUSectionObject *destinationSection = self.datas[destinationIndexPath.section];
        [destinationSection.cells insertObject:sourceObj atIndex:destinationIndexPath.row];
    }
    
    if(self.moveRowCompletedHandler) {
        self.moveRowCompletedHandler(self, sourceIndexPath, destinationIndexPath);
    }
}

#pragma mark -

-(void)setNeedsUpdateCellHeightWithIndexPath:(NSIndexPath *)indexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:indexPath];
    if(obj) {
        obj.size = WUSizeNotFound;
    }
}

-(void)setNeedsUpdateAllCellsHeight {
    if(!self.datas) {
        return;
    }
    
    for (WUSectionObject *obj in self.datas) {
        for (WUCellObject *cell in obj.cells) {
            cell.size = WUSizeNotFound;
        }
    }
}

#pragma mark -

-(CGRect)cellScreenRectWithTouchPoint:(CGPoint)point {
    NSIndexPath *indexPath = [self indexPathForRowAtPoint:point];
    if(!indexPath) {
        return CGRectNull;
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(!window) {
        return CGRectNull;
    }
    
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    CGRect rect = [self convertRect:cell.frame toView:window];
    return rect;
}

@end
