//
//  WUDataSource.h
//  BKFoundation
//
//  Created by 武探 on 2017/3/6.
//  Copyright © 2017年 wutan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WUNotFound CGFLOAT_MAX
#define WUSizeNotFound CGSizeMake(WUNotFound, WUNotFound)
#define WUSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define WURandomReusableIdentifier [[NSUUID UUID] UUIDString]

NS_ASSUME_NONNULL_BEGIN

@interface WUKeyValueItem<__covariant KeyType, __covariant ObjectType> : NSObject

@property(nonatomic, strong) KeyType key;
@property(nonatomic, strong) ObjectType value;

+(instancetype)itemWithKey:(KeyType)key value:(ObjectType)value;

@end

@interface WUCellObject : NSObject

@property(nonatomic, strong, nullable) NSString *text;
@property(nonatomic, strong, nullable) NSString *detailText;
/**
 本地图片资源名
 */
@property(nonatomic, strong, nullable) NSString *imageName;
@property(nonatomic, assign) UITableViewCellStyle style;
@property(nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property(nonatomic, assign) UITableViewCellAccessoryType accessoryType;
/**
 注册的类，key 为reuseIdentifier
 */
@property(nonatomic, strong) WUKeyValueItem<NSString*, Class> *registerClass;
@property(nonatomic, weak, nullable) id target;
@property(nonatomic, strong, nullable) NSString *selectorString;

/**
 在TableViewCell中 size.width会被忽略
 */
@property(nonatomic, assign) CGSize size;

/**
 填充cell所需的数据，根据需求自定义
 */
@property(nonatomic, strong, nullable) id userData;

/**
 根据需求自定义 如：自定义cell的代理
 */
@property(nonatomic, weak, nullable) id userInfo;

@end

@interface WUHeaderFooterObject : NSObject

@property(nonatomic, strong, nullable) NSString *text;
@property(nonatomic, assign) CGSize size;
@property(nonatomic, strong) WUKeyValueItem<NSString*, Class> *registerClass;
@property(nonatomic, strong, nullable) id userData;
@property(nonatomic, weak, nullable) id userInfo;

@end

@interface WUSectionObject : NSObject

@property(nonatomic, strong, nullable) NSMutableArray<WUCellObject*> *cells;
@property(nonatomic, strong, nullable) WUHeaderFooterObject *header;
@property(nonatomic, strong, nullable) WUHeaderFooterObject *footer;

+(instancetype)sectionWithCells:(NSMutableArray<WUCellObject*>*)cells;

@end



/**
 对于 自定义 UITableViewCell UITableViewHeaderFooterView UICollectionViewCell UICollectionReusableView
 都应完成此协议
 */
@protocol WUDataSourceProtocol <NSObject>

@required
/**
 计算cell的size

 @param userData 自定义数据
 @return CGsize 对于TableView size.width会被忽略
 */
+(CGSize)dataSourceSizeWithUserData:(nullable id)userData;

/**
 数据填充方法

 @param userData 自定义数据
 */
-(void)dataSourceFillWithUserData:(nullable id)userData;

@optional
-(void)dataSourceSetUserInfo:(__weak _Nullable id)userInfo;

@end

extern NSString *const WUTableDefaultCellIdentifier;
extern NSString *const WUTableDefaultHeaderFooterIdentifier;
extern NSString *const WUCollectionDefaultCellIdentifier;
extern NSString *const WUCollectionDefaultHeaderIdentifier;
extern NSString *const WUCollectionDefaultFooterIdentifier;

NS_ASSUME_NONNULL_END
