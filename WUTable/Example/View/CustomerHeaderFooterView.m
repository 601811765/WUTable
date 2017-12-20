//
//  CustomerHeaderFooterView.m
//  BKFoundation
//
//  Created by 武探 on 2017/3/7.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import "CustomerHeaderFooterView.h"

@interface CustomerHeaderFooterView()

@property(nonatomic, strong) UIImageView *imageView;

@end

@implementation CustomerHeaderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self) {
        [self initialize];
    }
    return self;
}

-(void)initialize {
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor grayColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    
    [self makeConstraints];
}

-(void)makeConstraints {
    UIView *view = self.contentView;
    
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_imageView.topAnchor constraintEqualToAnchor:view.topAnchor constant:10].active = YES;
    [_imageView.centerXAnchor constraintEqualToAnchor:view.centerXAnchor constant:0].active = YES;
    [_imageView.widthAnchor constraintEqualToConstant:32].active = YES;
    [_imageView.heightAnchor constraintEqualToConstant:32].active = YES;
}

-(void)dataSourceFillWithUserData:(id)userData {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://ac-5vk4odto.clouddn.com/4hpuXQupP3EDhSI7vVoCMsSog1FWwFGnXXWCjGSl.jpg"]];
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            UIImage *image = [UIImage imageWithData:data];
            self.imageView.image = image;
        }];
    }];
}

+(CGSize)dataSourceSizeWithUserData:(id)userData {
    return CGSizeMake(0, 52);
}

@end
