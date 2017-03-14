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
@property(nonatomic, strong) CALayer *topLayer;
@property(nonatomic, strong) CALayer *bottomLayer;

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
    
    _topLayer = [[CALayer alloc] init];
    _topLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.contentView.layer addSublayer:_topLayer];
    
    _bottomLayer = [[CALayer alloc] init];
    _bottomLayer.backgroundColor = [UIColor grayColor].CGColor;
    [self.contentView.layer addSublayer:_bottomLayer];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat lineHeight = 1 / [[UIScreen mainScreen] scale];
    _topLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), lineHeight);
    _bottomLayer.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame), CGRectGetWidth(self.contentView.frame), lineHeight);
}

-(void)dataSourceFillWithUserData:(id)userData {
    if(!userData || ![userData isKindOfClass:[NSString class]]) {
        return;
    }
    
    self.textLabel.text = userData;
}

+(CGSize)dataSourceSizeWithUserData:(id)userData {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, 80);
}

@end
