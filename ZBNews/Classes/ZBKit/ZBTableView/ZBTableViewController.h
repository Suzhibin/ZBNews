//
//  ZBTableViewController.h
//  ZBKit
//
//  Created by NQ UEC on 17/2/14.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBConstants.h"
@interface ZBTableGroup : NSObject
@property (nonatomic, copy) NSString *header; // 头部标题
@property (nonatomic, copy) NSString *footer; // 尾部标题
@property (nonatomic, strong) NSArray *items; // 中间的条目
@property (nonatomic,assign) CGFloat headerHeight; // 头部高度
@property (nonatomic, assign) CGFloat footerHeight; // 尾部高度


@end


//=========================================================================

typedef NS_ENUM(NSInteger,ZBTableItemType) {
    
    ZBTableItemTypeNone,                  // 什么也没有
    ZBTableItemTypeArrow,                 // 箭头
    ZBTableItemTypeSwitch,                // 开关
    ZBTableItemTypeRightText,             // 右侧文字
    ZBTableItemTypeRightAttributedText,   // 右侧文字
    ZBTableItemTypeArrowWithText,         // 箭头和右侧文字
    ZBTableItemTypeTextField,             // 右侧有textField
    ZBTableItemTypeRightImage,            // 右侧有（头像）imageView
} ;
@interface ZBTableItem : NSObject
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
/** 右侧文字 */
@property (nonatomic, copy) NSString *rightText;
/** 右侧文字 */
@property (nonatomic, copy) NSMutableAttributedString *rightAttributedText;
/** 右侧头像的URL */
@property (nonatomic, copy) NSString *imageUrl;
/** textField的placeholder */
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isOpenSwitch;
/** 是否认证通过 */
@property (nonatomic, assign, getter=isAuthor) BOOL author;
@property (nonatomic, assign) ZBTableItemType type;// Cell的样式
/** cell上开关的操作事件 */
@property (nonatomic, copy) void (^switchBlock)(BOOL on) ;
@property (nonatomic, copy) void (^operation)() ; // 点击cell后要执行的操作
@property (nonatomic, copy) void (^imageTapBlock)(); // 右侧头像点击

/**
 *
 *  @param title  标题
 *  @param type   右侧箭头类型
 *
 *  @return ZFSettingItem
 */
+ (instancetype)itemWithTitle:(NSString *)title type:(ZBTableItemType)type;

/**
 *  @param icon   左侧图标
 *  @param title  标题
 *  @param type   右侧箭头类型
 *
 *  @return ZFSettingItem
 */
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title type:(ZBTableItemType)type;

@end

//=========================================================================

@interface ZBTableCell : UITableViewCell
@property (nonatomic, strong) ZBTableItem *item;
@property (nonatomic, strong) UISwitch *rightSwitch;
@property (nonatomic, strong) UIImageView *photoImageView;
/** switch状态改变的block*/
@property (copy, nonatomic) void(^switchChangeBlock)(BOOL on);

@end


//=========================================================================

@interface ZBTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_allGroups; // 所有的组模型
}
//@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong)  ZBTableCell *cell;
//- (void)tableReloadData;


@end
