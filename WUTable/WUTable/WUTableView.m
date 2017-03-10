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

NSString *const WUTableHeaderFooterDefaultIdentifier = @"WUTableHeaderFooterDefaultIdentifier";
NSString *const WUTableCellDefaultIdentifier = @"WUTableCellDefaultIdentifier";

@implementation WUTableView

@dynamic delegate;
@dynamic dataSource;

#pragma mark -

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if(self) {
        [self setDelegateDataSource];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if(self) {
        [self setDelegateDataSource];
    }
    return self;
}

-(void)setDelegateDataSource {
    super.delegate = self;
    super.dataSource = self;
}

-(void)setDatas:(NSArray<WUSectionObject *> *)datas {
    _datas = datas;
    
    for (WUSectionObject *obj in _datas) {
        if(!obj.header) {
            obj.header = [self defaultHeaderFooter];
        } else {
            [self registerClass:obj.header.registerClass.value forHeaderFooterViewReuseIdentifier:obj.header.registerClass.key];
        }
        
        if(!obj.footer) {
            obj.footer = [self defaultHeaderFooter];
        } else {
            [self registerClass:obj.footer.registerClass.value forHeaderFooterViewReuseIdentifier:obj.footer.registerClass.key];
        }
    }
}

-(WUHeaderFooterObject*)defaultHeaderFooter {
    WUHeaderFooterObject *headerFooter = [[WUHeaderFooterObject alloc] init];
    headerFooter.size = CGSizeMake(0, WUTableMinLineHeight);
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

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.editingStyleForRowHandler) {
        return self.editingStyleForRowHandler(self, indexPath);
    }
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.commitEditingStyleForRowHandler) {
        self.commitEditingStyleForRowHandler(self, editingStyle, indexPath);
    }
}

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.editForRowActionHandler) {
        return self.editForRowActionHandler(self, indexPath);
    }
    
    return nil;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.canMoveRowHandler) {
        return self.canMoveRowHandler(self, indexPath);
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if(self.moveRowHandler) {
        self.moveRowHandler(self, sourceIndexPath, destinationIndexPath);
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

@end
