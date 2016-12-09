// 
//  代码地址: https://github.com/iphone5solo/PYSearch
//  代码地址: http://www.code4app.com/thread-11175-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  最主要的搜索控制器

#import <UIKit/UIKit.h>

@class PYSearchViewController, PYSearchSuggestionViewController;

typedef void(^PYDidSearchBlock)(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText); // 开始搜索时调用的block

typedef NS_ENUM(NSInteger, PYHotSearchStyle)  { // 热门搜索标签风格
    PYHotSearchStyleNormalTag,      // 普通标签(不带边框)
    PYHotSearchStyleColorfulTag,    // 彩色标签（不带边框，背景色为随机彩色）
    PYHotSearchStyleBorderTag,      // 带有边框的标签,此时标签背景色为clearColor
    PYHotSearchStyleARCBorderTag,   // 带有圆弧边框的标签,此时标签背景色为clearColor
    PYHotSearchStyleRankTag,        // 带有排名标签
    PYHotSearchStyleRectangleTag,   // 矩形标签,此时标签背景色为clearColor
    PYHotSearchStyleDefault = PYHotSearchStyleNormalTag // 默认为普通标签
};

typedef NS_ENUM(NSInteger, PYSearchHistoryStyle) {  // 搜索历史风格
    PYSearchHistoryStyleCell,           // UITableViewCell 风格
    PYSearchHistoryStyleNormalTag,      // PYHotSearchStyleNormalTag 标签风格
    PYSearchHistoryStyleColorfulTag,    // 彩色标签（不带边框，背景色为随机彩色）
    PYSearchHistoryStyleBorderTag,      // 带有边框的标签,此时标签背景色为clearColor
    PYSearchHistoryStyleARCBorderTag,   // 带有圆弧边框的标签,此时标签背景色为clearColor
    PYSearchHistoryStyleDefault = PYSearchHistoryStyleCell // 默认为 PYSearchHistoryStyleCell
};

typedef NS_ENUM(NSInteger, PYSearchResultShowMode) { // 搜索结果显示方式
    PYSearchResultShowModeCustom,   // 通过自定义显示
    PYSearchResultShowModePush,     // 通过Push控制器显示
    PYSearchResultShowModeEmbed,    // 通过内嵌控制器View显示
    PYSearchResultShowModeDefault = PYSearchResultShowModeCustom // 默认为用户自定义（自己处理）
};

@protocol PYSearchViewControllerDataSource <NSObject, UITableViewDataSource>

@optional
/**
 *  自定义搜索建议Cell的数据源方法
 */
/** 返回用户自定义搜索建议Cell */
- (UITableViewCell *)searchSuggestionView:(UITableView *)searchSuggestionView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/** 返回用户自定义搜索建议cell的rows */
- (NSInteger)searchSuggestionView:(UITableView *)searchSuggestionView numberOfRowsInSection:(NSInteger)section;
/** 返回用户自定义搜索建议cell的section */
- (NSInteger)numberOfSectionsInSearchSuggestionView:(UITableView *)searchSuggestionView;
/** 返回用户自定义搜索建议cell高度 */
- (CGFloat)searchSuggestionView:(UITableView *)searchSuggestionView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  自定义搜索结果Cell的数据源方法
 */
/** 返回用户自定义搜索结果Cell */
- (UITableViewCell *)searchResultView:(UITableView *)searchResultView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
/** 返回用户自定义搜索结果cell的rows */
- (NSInteger)searchResultView:(UITableView *)searchResultView numberOfRowsInSection:(NSInteger)section;
/** 返回用户自定义搜索结果cell的section */
- (NSInteger)numberOfSectionsInSearchSearchResultView:(UITableView *)searchSuggestionView;
/** 返回用户自定义搜索结果cell高度 */
- (CGFloat)searchResultView:(UITableView *)searchResultView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol PYSearchViewControllerDelegate <NSObject, UITableViewDelegate>

@optional

/** 点击(开始)搜索时调用 */
- (void)searchViewController:(PYSearchViewController *)searchViewController didSearchWithsearchBar:(UISearchBar *)searchBar searchText:(NSString *)searchText;
/** 点击热门搜索时调用，如果实现该代理方法则点击热门搜索时searchViewController:didSearchWithsearchBar:searchText:失效*/
- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectHotSearchAtIndex:(NSInteger)index searchText:(NSString *)searchText;
/** 点击搜索历史时调用，如果实现该代理方法则搜索历史时searchViewController:didSearchWithsearchBar:searchText:失效 */
- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchHistoryAtIndex:(NSInteger)index searchText:(NSString *)searchText;
/** 点击搜索建议时调用，如果实现该代理方法则点击搜索建议时searchViewController:didSearchWithsearchBar:searchText:失效 */
- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndex:(NSInteger)index searchText:(NSString *)searchText;
/** 搜索框文本变化时，显示的搜索建议通过searchViewController的searchSuggestions赋值即可 */
- (void)searchViewController:(PYSearchViewController *)searchViewController  searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText;
/** 点击取消时调用 */
- (void)didClickCancel:(PYSearchViewController *)searchViewController;

@end

@interface PYSearchViewController : UIViewController

/** 
 * 排名标签背景色对应的16进制字符串（如：@"#ffcc99"）数组(四个颜色)
 * 前三个为分别为1、2、3 第四个为后续所有标签的背景色
 * 该属性只有在设置hotSearchStyle为PYHotSearchStyleColorfulTag才生效
 */
@property (nonatomic, strong) NSArray<NSString *> *rankTagBackgroundColorHexStrings;
/** 
 * web安全色池,存储的是UIColor数组，用于设置标签的背景色
 * 该属性只有在设置hotSearchStyle为PYHotSearchStyleColorfulTag才生效
 */
@property (nonatomic, strong) NSMutableArray<UIColor *> *colorPol;
/** 热门搜索 */
@property (nonatomic, copy) NSArray<NSString *> *hotSearches;
/** 所有的热门标签 */
@property (nonatomic, copy) NSArray<UILabel *> *hotSearchTags;
/** 热门标签头部 */
@property (nonatomic, weak) UILabel *hotSearchHeader;

/** 所有的搜索历史标签,只有当PYSearchHistoryStyle != PYSearchHistoryStyleCell才有值 */
@property (nonatomic, copy) NSArray<UILabel *> *searchHistoryTags;
/** 搜索历史标题,只有当PYSearchHistoryStyle != PYSearchHistoryStyleCell才有值 */
@property (nonatomic, weak) UILabel *searchHistoryHeader;
/** 搜索历史缓存保存路径, 默认为PYSearchHistoriesPath(PYSearchConst.h文件中的宏定义) */
@property (nonatomic, copy) NSString *searchHistoriesCachePath;

/** 代理 */
@property (nonatomic, weak) id<PYSearchViewControllerDelegate> delegate;
/** 数据源 */
@property (nonatomic, weak) id<PYSearchViewControllerDataSource> dataSource;

/** 热门搜索风格 （默认为：PYHotSearchStyleDefault）*/
@property (nonatomic, assign) PYHotSearchStyle hotSearchStyle;
/** 搜索历史风格 （默认为：PYSearchHistoryStyleDefault）*/
@property (nonatomic, assign) PYSearchHistoryStyle searchHistoryStyle;
/** 显示搜索结果模式（默认为自定义：PYSearchResultShowModeDefault） */
@property (nonatomic, assign) PYSearchResultShowMode searchResultShowMode;
/** 搜索栏 */
@property (nonatomic, weak) UISearchBar *searchBar;
/** 搜索栏的背景色 */
@property (nonatomic, strong) UIColor *searchBarBackgroundColor;
/** 取消按钮 */
@property (nonatomic, weak) UIBarButtonItem *cancelButton;

/** 搜索时调用此Block */
@property (nonatomic, copy) PYDidSearchBlock didSearchBlock;
/** 搜索建议,注意：给此属性赋值时，确保searchSuggestionHidden值为NO，否则赋值失效 */
@property (nonatomic, copy) NSArray<NSString *> *searchSuggestions;
/** 搜索建议是否隐藏 默认为：NO */
@property (nonatomic, assign) BOOL searchSuggestionHidden;

/** 搜索结果控制器
 * 当searchResultShowMode == PYSearchResultShowModePush时，
 * 将目的控制器给该属性赋值，即Push到searchResultController控制器
 * 当searchResultShowMode == PYSearchResultShowModeEmbed时，
 * 将目的控制器给该属性赋值，即将searchResultController.view添加到self.view
 */
@property (nonatomic, strong) UIViewController *searchResultController;

/**
 * 快速创建PYSearchViewController对象
 *
 * hotSearches : 热门搜索数组
 * placeholder : searchBar占位文字
 *
 */
+ (PYSearchViewController *)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder;

/**
 * 快速创建PYSearchViewController对象
 *
 * hotSearches : 热门搜索数组
 * placeholder : searchBar占位文字
 * block: 点击（开始）搜索时调用block
 * 注意 : delegate(代理)的优先级大于block(即实现了代理方法则block失效)
 *
 */
+ (PYSearchViewController *)searchViewControllerWithHotSearches:(NSArray<NSString *> *)hotSearches searchBarPlaceholder:(NSString *)placeholder didSearchBlock:(PYDidSearchBlock)block;

@end
