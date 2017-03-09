//
//  TableExampleViewController.m
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "TableExampleViewController.h"
#import "WUTable.h"
#import "TableSimpleViewController.h"
#import "TableCustomerViewController.h"
#import "TableHeaderFooterViewController.h"

@interface TableExampleViewController ()

@property(nonatomic, strong) WUTableView *tableView;

@end

@implementation TableExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeComponent];
}

-(void)initializeComponent {
    self.title = @"TableView";
    
    _tableView = [[WUTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.datas = [self datas];
    _tableView.deSelectWhenSelected = YES;
    [self.view addSubview:_tableView];
}

-(NSMutableArray<WUSectionObject*>*)datas {
    WUCellObject *obj1 = [[WUCellObject alloc] init];
    obj1.text = @"简单视图";
    obj1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    obj1.size = CGSizeMake(0, 44);
    obj1.target = self;
    obj1.selectorString = NSStringFromSelector(@selector(simple:));
    
    WUCellObject *obj2 = [[WUCellObject alloc] init];
    obj2.text = @"自定义视图";
    obj2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    obj2.size = CGSizeMake(0, 44);
    obj2.target = self;
    obj2.selectorString = NSStringFromSelector(@selector(customer:));
    
    WUCellObject *obj3 = [[WUCellObject alloc] init];
    obj3.text = @"HeaderFooter";
    obj3.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    obj3.size = CGSizeMake(0, 44);
    obj3.target = self;
    obj3.selectorString = NSStringFromSelector(@selector(headerFooter:));
    
    NSMutableArray<WUCellObject*> *cells = [NSMutableArray arrayWithArray:@[obj1, obj2, obj3]];
    
    WUSectionObject *section = [WUSectionObject sectionWithCells:cells];
    
    return [NSMutableArray arrayWithArray:@[section]];
}

-(void)simple:(NSIndexPath*)indexPath {
    TableSimpleViewController *simple = [[TableSimpleViewController alloc] init];
    [self showViewController:simple sender:nil];
}

-(void)customer:(NSIndexPath*)indexPath {
    TableCustomerViewController *customer = [[TableCustomerViewController alloc] init];
    [self showViewController:customer sender:nil];
}

-(void)headerFooter:(NSIndexPath*)indexPath {
    TableHeaderFooterViewController *headerFooter = [[TableHeaderFooterViewController alloc] init];
    [self showViewController:headerFooter sender:nil];
}

@end
