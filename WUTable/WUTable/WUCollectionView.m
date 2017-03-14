//
//  WUCollectionView.m
//  WUTable
//
//  Created by 武探 on 2017/3/10.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "WUCollectionView.h"
#import <objc/message.h>

@implementation WUCollectionView

@dynamic delegate;
@dynamic dataSource;

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if(self) {
        [super setDelegate:self];
        [super setDataSource:self];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setDatas:(NSMutableArray<WUSectionObject *> *)datas {
    _datas = datas;
    
    if(!_datas || datas.count == 0) {
        return;
    }
    
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:WUCollectionDefaultCellIdentifier];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:WUCollectionDefaultHeaderIdentifier];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:WUCollectionDefaultFooterIdentifier];
    
    for (WUSectionObject *obj in _datas) {
        if(!obj.header) {
            obj.header = [self defaultHeaderFooter];
            obj.header.registerClass = [WUKeyValueItem itemWithKey:WUCollectionDefaultHeaderIdentifier value:[UICollectionReusableView class]];
        } else {
            if(!obj.header.registerClass) {
                obj.header.registerClass = [WUKeyValueItem itemWithKey:WUCollectionDefaultHeaderIdentifier value:[UICollectionReusableView class]];
            } else {
                [self registerClass:obj.header.registerClass.value forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:obj.header.registerClass.key];
            }
        }
        
        if(!obj.footer) {
            obj.footer = [self defaultHeaderFooter];
            obj.footer.registerClass = [WUKeyValueItem itemWithKey:WUCollectionDefaultFooterIdentifier value:[UICollectionReusableView class]];
        } else {
            if(!obj.footer.registerClass) {
                obj.footer.registerClass = [WUKeyValueItem itemWithKey:WUCollectionDefaultFooterIdentifier value:[UICollectionReusableView class]];
            } else {
                [self registerClass:obj.footer.registerClass.value forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:obj.footer.registerClass.key];
            }
        }
        
        if(obj.cells) {
            for (WUCellObject *cell in obj.cells) {
                if(!cell.registerClass) {
                    cell.registerClass = [WUKeyValueItem itemWithKey:WUCollectionDefaultCellIdentifier value:[UICollectionViewCell class]];
                } else {
                    [self registerClass:cell.registerClass.value forCellWithReuseIdentifier:cell.registerClass.key];
                }
            }
        }
    }
}

-(WUHeaderFooterObject*)defaultHeaderFooter {
    WUHeaderFooterObject *headerFooter = [[WUHeaderFooterObject alloc] init];
    headerFooter.size = CGSizeZero;
    return headerFooter;
}

-(WUHeaderFooterObject*)headerFooterObjWithIndex:(NSInteger)index kind:(NSString*)kind {
    WUSectionObject *s = self.datas[index];
    WUHeaderFooterObject *obj = kind == UICollectionElementKindSectionHeader ? s.header : s.footer;
    return obj;
}

-(WUCellObject*)cellObjectWithIndexPath:(NSIndexPath*)indexPath {
    WUSectionObject *sections = self.datas[indexPath.section];
    WUCellObject *obj = sections.cells[indexPath.row];
    return obj;
}

-(CGSize)sizeWithHeaderFooterObj:(WUHeaderFooterObject*)obj {
    if(!obj) {
        return CGSizeZero;
    }
    
    CGSize size = obj.size;
    if(CGSizeEqualToSize(WUSizeNotFound, size)) {
        Class cls = obj.registerClass.value;
        if([cls conformsToProtocol:@protocol(WUDataSourceProtocol)]) {
            size = [cls dataSourceSizeWithUserData:obj.userData];
            obj.size = size;
        } else {
            size = CGSizeZero;
        }
    }
    
    return size;
}

-(void)callFillData:(id)userData target:(id)target userInfo:(id)userInfo {
    if([target conformsToProtocol:@protocol(WUDataSourceProtocol)]) {
        [target dataSourceFillWithUserData:userData];
        if([target respondsToSelector:@selector(dataSourceSetUserInfo:)]) {
            [target performSelector:@selector(dataSourceSetUserInfo:) withObject:userInfo];
        }
    }
}

#pragma mark -

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.datas.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    WUSectionObject *s = self.datas[section];
    return s.cells.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    WUSectionObject *s = self.datas[section];
    CGSize size = [self sizeWithHeaderFooterObj:s.header];
    return size;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    WUSectionObject *s = self.datas[section];
    CGSize size = [self sizeWithHeaderFooterObj:s.footer];
    return size;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    WUHeaderFooterObject *obj = [self headerFooterObjWithIndex:indexPath.section kind:kind];
     UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:obj.registerClass.key forIndexPath:indexPath];
    if(WUSystemVersion < 8.0) {
        [self callFillData:obj.userData target:view userInfo:obj.userInfo];
    }
    return view;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    WUHeaderFooterObject *obj = [self headerFooterObjWithIndex:indexPath.section kind:elementKind];
    [self callFillData:obj.userData target:view userInfo:obj.userInfo];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:indexPath];
    CGSize size = obj.size;
    if(CGSizeEqualToSize(WUSizeNotFound, size)) {
        Class cls = obj.registerClass.value;
        if([cls conformsToProtocol:@protocol(WUDataSourceProtocol)]) {
            size = [cls dataSourceSizeWithUserData:obj.userData];
            obj.size = size;
        } else {
            size = CGSizeZero;
        }
    }
    
    return size;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:indexPath];
    WUKeyValueItem *item = obj.registerClass;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:item.key forIndexPath:indexPath];
    if(WUSystemVersion < 8.0) {
        [self callFillData:obj.userData target:cell userInfo:obj.userInfo];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:indexPath];
    [self callFillData:obj.userData target:cell userInfo:obj.userInfo];
    if(self.willDisplayCellHandler) {
        self.willDisplayCellHandler(self, cell, indexPath);
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WUCellObject *obj = [self cellObjectWithIndexPath:indexPath];
    if(obj.target && obj.selectorString) {
        SEL selector = NSSelectorFromString(obj.selectorString);
        if([obj.target respondsToSelector:selector]) {
            ((void (*)(void *, SEL, NSIndexPath*))objc_msgSend)((__bridge void *)(obj.target), selector, indexPath);
        }
    }
    
    if(self.didSelectItemHandler) {
        self.didSelectItemHandler(self, indexPath);
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.canMoveItemHandler) {
        return self.canMoveItemHandler(self, indexPath);
    }
    return NO;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if(self.moveItemHandler) {
        self.moveItemHandler(self, sourceIndexPath, destinationIndexPath);
    }
}

@end
