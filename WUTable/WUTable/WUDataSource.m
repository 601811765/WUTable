//
//  WUDataSource.m
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "WUDataSource.h"
#import "WUTable.h"

NSString *const WUTableDefaultCellIdentifier = @"WUTableDefaultCellIdentifier";
NSString *const WUTableDefaultHeaderFooterIdentifier = @"WUTableDefaultHeaderFooterIdentifier";
NSString *const WUCollectionDefaultCellIdentifier = @"WUCollectionDefaultCellIdentifier";
NSString *const WUCollectionDefaultHeaderIdentifier = @"WUCollectionDefaultHeaderIdentifier";
NSString *const WUCollectionDefaultFooterIdentifier = @"WUCollectionDefaultFooterIdentifier";

@implementation WUKeyValueItem

+(instancetype)itemWithKey:(id)key value:(id)value {
    WUKeyValueItem *item = [[self alloc] init];
    item.key = key;
    item.value = value;
    
    return item;
}

@end


@implementation WUCellObject

-(instancetype)init {
    self = [super init];
    if(self) {
        self.style = UITableViewCellStyleDefault;
        self.size = WUSizeNotFound;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.canMove = YES;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    WUCellObject *obj = [[WUCellObject allocWithZone:zone] init];
    obj.text = self.text;
    obj.detailText = self.detailText;
    obj.imageName = self.imageName;
    obj.style = self.style;
    obj.selectionStyle = self.selectionStyle;
    obj.accessoryType = self.accessoryType;
    obj.canMove = self.canMove;
    obj.registerClass = self.registerClass;
    obj.target = self.target;
    obj.selectorString = self.selectorString;
    obj.size = self.size;
    obj.userData = self.userData;
    obj.userInfo = self.userInfo;
    
    return obj;
}

@end

@implementation WUHeaderFooterObject

-(instancetype)init {
    self = [super init];
    if(self) {
        self.size = WUSizeNotFound;
    }
    return self;
}

@end

@implementation WUSectionObject

+(instancetype)sectionWithCells:(NSMutableArray<WUCellObject *> *)cells {
    WUSectionObject *obj = [[self alloc] init];
    obj.cells = cells;
    return obj;
}

@end

