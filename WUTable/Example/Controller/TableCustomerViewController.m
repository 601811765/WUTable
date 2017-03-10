//
//  TableCustomerViewController.m
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "TableCustomerViewController.h"
#import "CustomerTableViewCell.h"
#import "WUTable.h"

@interface TableCustomerViewController ()<CustomerTableViewCellDelegate>

@property(nonatomic, strong) WUTableView *tableView;

@end

@implementation TableCustomerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeComponent];
}

-(void)initializeComponent {
    self.title = @"自定义视图";
    
    _tableView = [[WUTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.datas = [self datas];
    _tableView.deSelectWhenSelected = YES;
    [self.view addSubview:_tableView];
}

-(NSMutableArray<WUSectionObject*>*)datas {
    WUCellObject *obj = [[WUCellObject alloc] init];
    obj.selectionStyle = UITableViewCellSelectionStyleNone;
    obj.registerClass = [WUKeyValueItem itemWithKey:@"customerIdentifier" value:[CustomerTableViewCell class]];
    obj.userInfo = self;
    
    WUSectionObject *section = [WUSectionObject sectionWithCells:[NSMutableArray arrayWithArray:@[obj]]];
    section.header = [[WUHeaderFooterObject alloc] init];
    section.header.size = CGSizeMake(0, 20);
    
    return [NSMutableArray arrayWithArray:@[section]];
}

-(void)customerTableViewCell:(CustomerTableViewCell *)cell buttonTouched:(UIButton *)sender {
    NSLog(@"%@", sender);
}

@end
