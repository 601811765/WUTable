//
//  CollectionReusableView.m
//  WUTable
//
//  Created by 武探 on 2017/3/14.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "CollectionReusableView.h"
#import "WUTable.h"

@interface CollectionReusableView()<WUDataSourceProtocol>

@property(nonatomic, strong) UILabel *textLabel;

@end

@implementation CollectionReusableView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_textLabel];
    
    [self makeConstraints];
}

-(void)makeConstraints {
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_textLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:0].active = YES;
    [_textLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10].active = YES;
    [_textLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
    [_textLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10].active = YES;
}

-(void)dataSourceFillWithUserData:(id)userData {
    if(!userData || ![userData isKindOfClass:[NSString class]]) {
        return;
    }
    
    _textLabel.text = userData;
}

+(CGSize)dataSourceSizeWithUserData:(id)userData {
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width, 30);
}

@end
