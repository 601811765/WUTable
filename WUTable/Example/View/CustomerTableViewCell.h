//
//  CustomerTableViewCell.h
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WUTable.h"

@class CustomerTableViewCell;

@protocol CustomerTableViewCellDelegate <NSObject>

-(void)customerTableViewCell:(CustomerTableViewCell*)cell buttonTouched:(UIButton*)sender;

@end

@interface CustomerTableViewCell : UITableViewCell<WUDataSourceProtocol>

@property(nonatomic, weak) id<CustomerTableViewCellDelegate> delegate;

@end
