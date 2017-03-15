//
//  CollectionCell.m
//  WUTable
//
//  Created by 武探 on 2017/3/14.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "CollectionCell.h"
#import "WUTable.h"

@interface CollectionCell ()<WUDataSourceProtocol>

@property(nonatomic, strong) UILabel *textLabel;

@end

@implementation CollectionCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    
    self.contentView.backgroundColor = [UIColor greenColor];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:18];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_textLabel];
    
    [self makeConstraints];
}

-(void)makeConstraints {
    
    UIView *view = self.contentView;
    
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_textLabel.topAnchor constraintEqualToAnchor:view.topAnchor constant:0].active = YES;
    [_textLabel.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:10].active = YES;
    [_textLabel.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:0].active = YES;
    [_textLabel.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-10].active = YES;
}

-(void)dataSourceFillWithUserData:(id)userData {
    if(!userData || ![userData isKindOfClass:[NSString class]]) {
        return;
    }
    
    self.textLabel.text = userData;
}

+(CGSize)dataSourceSizeWithUserData:(id)userData {
    return CGSizeMake(([[UIScreen mainScreen] bounds].size.width - 15) / 4, 80);
}

@end
