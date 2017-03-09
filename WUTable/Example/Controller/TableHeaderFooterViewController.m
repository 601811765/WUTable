//
//  TableHeaderFooterViewController.m
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "TableHeaderFooterViewController.h"
#import "WUTable.h"
#import "CustomerHeaderFooterView.h"

@interface TableHeaderFooterViewController ()

@property(nonatomic, strong) WUTableView *tableView;

@end

@implementation TableHeaderFooterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeComponent];
}

-(void)initializeComponent {
    self.title = @"HeaderFooter";
    
    _tableView = [[WUTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.datas = [self datas];
    _tableView.deSelectWhenSelected = YES;
    [self.view addSubview:_tableView];
}

-(NSMutableArray<WUSectionObject*>*)datas {
    
    WUCellObject *obj1 = [[WUCellObject alloc] init];
    obj1.text = @"简单Header Footer";
    obj1.size = CGSizeMake(0, 40);
    
    WUSectionObject *sectionObj1 = [WUSectionObject sectionWithCells:[NSMutableArray arrayWithArray:@[obj1]]];
    
    WUHeaderFooterObject *header1 = [[WUHeaderFooterObject alloc] init];
    header1.text = @"Header";
    header1.size = CGSizeMake(0, 30);
    
    WUHeaderFooterObject *footer1 = [[WUHeaderFooterObject alloc] init];
    footer1.text = @"Footer";
    footer1.size = CGSizeMake(0, 30);
    
    sectionObj1.header = header1;
    sectionObj1.footer = footer1;
    
    WUCellObject *obj2 = [[WUCellObject alloc] init];
    obj2.text = @"自定义";
    obj2.size = CGSizeMake(0, 40);
    
    WUSectionObject *sectionObj2 = [WUSectionObject sectionWithCells:[NSMutableArray arrayWithArray:@[obj2]]];
    WUHeaderFooterObject *header2 = [[WUHeaderFooterObject alloc] init];
    header2.registerClass = [WUKeyValueItem itemWithKey:@"customerIdentifier" value:[CustomerHeaderFooterView class]];
    
    sectionObj2.header = header2;
    
    return [NSMutableArray arrayWithArray:@[sectionObj1, sectionObj2]];
}

@end
