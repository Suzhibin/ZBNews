//
//  ZBSettingViewController.h
//  ZBNews
//
//  Created by NQ UEC on 16/12/1.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZBSettingGroup : NSObject
@property (nonatomic, copy) NSString *header; // 头部标题
@property (nonatomic, copy) NSString *footer; // 尾部标题
@property (nonatomic, strong) NSArray *items; // 中间的条目
@property (nonatomic,assign) CGFloat headerHeight; // 头部高度
@property (nonatomic, assign) CGFloat footerHeight; // 尾部高度


@end


//=========================================================================

typedef NS_ENUM(NSInteger,ZBSettingItemType) {
    
    ZBSettingItemTypeNone,           // 什么也没有
    ZBSettingItemTypeArrow,          // 箭头
    ZBSettingItemTypeSwitch,         // 开关
    ZBSettingItemTypeRightText,      // 右侧文字
    ZBSettingItemTypeArrowWithText,  // 箭头和右侧文字
    ZBSettingItemTypeTextField,      // 右侧有textField
    ZBSettingItemTypeRightImage      // 右侧有（头像）imageView
} ;
@interface ZBSettingItem : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
/** 右侧文字 */
@property (nonatomic, copy) NSString *rightText;
/** 右侧头像的URL */
@property (nonatomic, copy) NSString *imageUrl;
/** textField的placeholder */
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isOpenSwitch;
/** 是否认证通过 */
@property (nonatomic, assign, getter=isAuthor) BOOL author;
@property (nonatomic, assign) ZBSettingItemType type;// Cell的样式
/** cell上开关的操作事件 */
@property (nonatomic, copy) void (^switchBlock)(BOOL on) ;
@property (nonatomic, copy) void (^operation)() ; // 点击cell后要执行的操作
@property (nonatomic, copy) void (^imageTapBlock)(); // 右侧头像点击
/**
 *  @param icon   左侧图标
 *  @param title  标题
 *  @param type   右侧箭头类型
 *
 *  @return ZFSettingItem
 */
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title type:(ZBSettingItemType)type;

@end

//=========================================================================

@interface ZBSettingCell : UITableViewCell
@property (nonatomic, strong) ZBSettingItem *item;
@property (nonatomic, strong) UISwitch *rightSwitch;
@property (nonatomic, strong) UIImageView *photoImageView;
/** switch状态改变的block*/
@property (copy, nonatomic) void(^switchChangeBlock)(BOOL on);

@end


//=========================================================================

@interface ZBSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_allGroups; // 所有的组模型
}
@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)  ZBSettingCell *cell;
@end
