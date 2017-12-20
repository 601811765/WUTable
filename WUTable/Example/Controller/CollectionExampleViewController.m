//
//  CollectionExampleViewController.m
//  WUTable
//
//  Created by 武探 on 2017/3/14.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "CollectionExampleViewController.h"
#import "WUTable.h"
#import "CollectionCell.h"
#import "CollectionReusableView.h"

@interface CollectionExampleViewController ()

@property(nonatomic, strong) WUCollectionView *collectionView;

@end

@implementation CollectionExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeComponent];
}

-(void)initializeComponent {
    self.title = @"CollectionView";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    _collectionView = [[WUCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.datas = [self datas];
    _collectionView.interactiveMovementEnabled = YES;
    _collectionView.interactiveMovementMinimumPressDuration = 0.3;
    [self.view addSubview:_collectionView];
    
    [self makeConstraints];
}

-(void)makeConstraints {
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [_collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0].active = YES;
    [_collectionView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0].active = YES;
    [_collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
    [_collectionView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0].active = YES;
}

-(NSMutableArray<WUSectionObject*>*)datas {
    
    WUSectionObject *section = [WUSectionObject sectionWithCells:[self cells]];
    
    WUHeaderFooterObject *header = [[WUHeaderFooterObject alloc] init];
    header.registerClass = [WUKeyValueItem itemWithKey:WURandomReusableIdentifier value:[CollectionReusableView class]];
    header.userData = @"Header";
    section.header = header;
    
    WUHeaderFooterObject *footer = [[WUHeaderFooterObject alloc] init];
    footer.registerClass = [WUKeyValueItem itemWithKey:WURandomReusableIdentifier value:[CollectionReusableView class]];
    footer.userData = @"Footer";
    section.footer = footer;
    
    return [NSMutableArray arrayWithArray:@[section]];
}

-(NSMutableArray<WUCellObject*>*)cells {
    NSMutableArray<WUCellObject*> *cells = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        WUCellObject *cell = [[WUCellObject alloc] init];
        cell.registerClass = [WUKeyValueItem itemWithKey:WURandomReusableIdentifier value:[CollectionCell class]];
        cell.userData = [NSString stringWithFormat:@"%d", i];
        
        if(i == 0) {
            cell.canMove = NO;
        }
        
        [cells addObject:cell];
    }
    return cells;
}


@end
