//
//  CustomerTableViewCell.m
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "CustomerTableViewCell.h"

@implementation CustomerTableViewCell {
    UIImageView *_imView;
    UILabel *_titleLabel;
    UIButton *_button;
}

-(void)setDataSourceUserInfo:(id)dataSourceUserInfo {
    if([dataSourceUserInfo conformsToProtocol:@protocol(CustomerTableViewCellDelegate)]) {
        self.delegate = dataSourceUserInfo;
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    
    _imView = [[UIImageView alloc] init];
    _imView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_imView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    _button = [[UIButton alloc] init];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setBackgroundColor:[UIColor redColor]];
    [_button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_button];
    
    [self makeConstraints];
}

-(void)makeConstraints {
    _imView.translatesAutoresizingMaskIntoConstraints = NO;
    [_imView.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = YES;
    [_imView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
    [_imView.widthAnchor constraintEqualToConstant:64].active = YES;
    [_imView.heightAnchor constraintEqualToConstant:64].active = YES;
    
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_titleLabel.topAnchor constraintEqualToAnchor:_imView.bottomAnchor constant:10].active = YES;
    [_titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10].active = YES;
    [_titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10].active = YES;
    
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    [_button.topAnchor constraintEqualToAnchor:_titleLabel.bottomAnchor constant:10].active = YES;
    [_button.centerXAnchor constraintEqualToAnchor:self.centerXAnchor constant:0].active = YES;
    [_button.widthAnchor constraintEqualToConstant:80];
    [_button.heightAnchor constraintEqualToConstant:30];
}

-(void)buttonTouchUpInside:(UIButton*)sender {
    if(self.delegate) {
        [self.delegate customerTableViewCell:self buttonTouchUpInside:sender];
    }
}

-(void)dataSourceSetUserInfo:(id  _Nullable __weak)userInfo {
    if(userInfo && [userInfo conformsToProtocol:@protocol(CustomerTableViewCellDelegate)]) {
        self.delegate = userInfo;
    } else {
        self.delegate = nil;
    }
}

-(void)dataSourceFillWithUserData:(id)userData {
    _titleLabel.text = @"标题";
    [_button setTitle:@"按钮" forState:UIControlStateNormal];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://dn-frahx1zb.qbox.me/hC1jFiX9roag1AN4RFb2nw6QkoR3p2tf8MOD3nYm.jpg"]];
            UIImage *image = [UIImage imageWithData:data];
            _imView.image = image;
        }];
    }];
}

+(CGSize)dataSourceSizeWithUserData:(id)userData {
    CGFloat height = 10;
    height += 64;
    height += 10;
    height += [UIFont systemFontOfSize:16].lineHeight;
    height += 10;
    height += 30;
    height += 10;
    
    return CGSizeMake(0, height);
}

@end
