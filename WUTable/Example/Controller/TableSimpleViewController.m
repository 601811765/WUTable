//
//  TableSimpleViewController.m
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "TableSimpleViewController.h"
#import "WUTable.h"

@interface TableSimpleViewController ()

@property(nonatomic, strong) WUTableView *tableView;

@end

@implementation TableSimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeComponent];
}

-(void)initializeComponent {
    
    self.title = @"简单视图";
    
    _tableView = [[WUTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.datas = [self datas];
    _tableView.deSelectWhenSelected = YES;
    [self.view addSubview:_tableView];
    
    _tableView.canEditRowHandler = ^ BOOL (WUTableView *tableView, NSIndexPath *indexPath) {
        if(indexPath.section == 0 && indexPath.row == 2) {
            return NO;
        }
        return YES;
    };
    _tableView.editForRowActionHandler = ^ NSArray<UITableViewRowAction*>* (WUTableView *tableView, NSIndexPath *indexPath) {
        UITableViewRowAction *actionA = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"A" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
        }];
        
        UITableViewRowAction *actionB = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"B" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
        }];
        
        return @[actionA, actionB];
    };
}

-(NSMutableArray<WUSectionObject*>*)datas {
    WUCellObject *obj1 = [[WUCellObject alloc] init];
    obj1.text = @"UITableViewCellStyleDefault";
    obj1.size = CGSizeMake(0, 44);
    
    WUCellObject *obj2 = [[WUCellObject alloc] init];
    obj2.style = UITableViewCellStyleSubtitle;
    obj2.text = @"UITableViewCellStyleSubtitle";
    obj2.detailText = @"subTitle";
    obj2.size = CGSizeMake(0, 60);
    
    WUCellObject *obj3 = [[WUCellObject alloc] init];
    obj3.style = UITableViewCellStyleValue1;
    obj3.text = @"UITableViewCellStyleValue1";
    obj3.detailText = @"subTitle";
    obj3.size = CGSizeMake(0, 44);
    
    WUCellObject *obj4 = [[WUCellObject alloc] init];
    obj4.style = UITableViewCellStyleValue2;
    obj4.text = @"UITableViewCellStyleValue2";
    obj4.detailText = @"subTitle";
    obj4.size = CGSizeMake(0, 80);
    
    NSMutableArray<WUCellObject*> *cells = [NSMutableArray arrayWithArray:@[obj1, obj2, obj3, obj4]];
    
    WUSectionObject *section = [WUSectionObject sectionWithCells:cells];
    
    return [NSMutableArray arrayWithArray:@[section]];
}

@end
