//
//  MainViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "MainViewController.h"
#import "API_Constants.h"
#import "Constants.h"
#import "MainModel.h"
#import "ChannelViewController.h"
#import "DataManager.h"
#import "ZBNetworking.h"
#import "GlobalSettingsTool.h"
#import <SDAutoLayout.h>
#import <Masonry.h>
#import "ZBWeatherAnimatedView.h"
#import "HeaderAnimatedView.h"
#import "YYFPSLabel.h"
@interface MainViewController ()
@property (nonatomic, strong)  UIImageView *imageView;
@property (nonatomic, strong)  NSMutableArray *menuList;
@property (nonatomic, assign)  BOOL autoSwitch;

@property (strong, nonatomic) HeaderAnimatedView *mainNavView;
@end

@implementation MainViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:STARTANIMATING object:nil];
}

#pragma mark - NSNotification
- (void)addNotification {
    [self removeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MainVCchangeNightView) name:NIGHT object:nil];//夜间模式通知
}
- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NIGHT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STARTANIMATING object:nil];

}
- (void)statusBarOrientationChange:(NSNotification *)notification {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self mainVCgetNightPattern];
    [self generateData];
    [self integrateComponents];
    [self configSeparatorView];
    [self addNotification];
    YYFPSLabel *fps = [[YYFPSLabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100,0, 60, 20)];//fps监测
    [[UIApplication sharedApplication].keyWindow addSubview:fps];
}
- (void)MainVCchangeNightView{
    [self mainVCgetNightPattern];
}
- (void)mainVCgetNightPattern{
    if ([GlobalSettingsTool getNightPattern]==YES) {
        self.view.backgroundColor=[UIColor colorWithRed:0.11 green:0.12 blue:0.13 alpha:1.00];
        self.magicView.navigationColor =[UIColor colorWithRed:0.11 green:0.12 blue:0.13 alpha:1.00];
    }else{
        self.view.backgroundColor=[UIColor whiteColor];
        self.magicView.navigationColor = [UIColor whiteColor];//顶部导航栏背景色
    }
}
#pragma  mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
   // NEWSLog(@"_menuList:%@",_menuList);
        for (MainModel *menu in _menuList) {
            // NEWSLog(@"name:%@",menu.name);
            [titleList addObject:menu.title];
        }

    return titleList;
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex{
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
    }
    //    JSMainModel *menuInfo = _menuList[itemIndex];
    //    [menuItem setTitle:menuInfo.name forState:UIControlStateNormal];
    return menuItem;
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    MainModel *mainModel=_menuList[pageIndex];
    static NSString *channeId = @"Channe.identifier";
    ChannelViewController *channeVC= [magicView dequeueReusablePageWithIdentifier:channeId];
    if (!channeVC) {
        channeVC=[[ChannelViewController alloc]init];
    }
    channeVC.mainModel=mainModel;
    //    homeVC.channelId=mainModel.channelId;
    return channeVC;
    
}
#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex{
    NEWSLog(@"index:%ld viewDidAppeare:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappeare:(UIViewController *)viewController atPage:(NSUInteger)pageIndex{
    NEWSLog(@"index:%ld viewDidDisappeare:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex{
    NEWSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

- (void)integrateComponents{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [rightButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [rightButton setTitle:@"+" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    rightButton.center = self.view.center;
    [rightButton addTarget:self action:@selector(subscribeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.magicView.rightNavigatoinItem = rightButton;
}

- (void)configSeparatorView {
    
    self.mainNavView = [[HeaderAnimatedView alloc] init];
    self.scrollDelegate = (id<MainControllerScrollDelegate>)_mainNavView;
    [self.magicView.headerView addSubview:_mainNavView ];
    [_mainNavView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(SCREEN_WIDTH-40));
        make.top.equalTo(@(-280));
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
    }];
    
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 20, 30, 30)];
    _imageView.image=[UIImage imageNamed:@"ball.png"];
    _imageView.center=CGPointMake(80,25);
    [self.magicView.headerView  addSubview:_imageView];

    self.magicView.headerHidden =YES;
    //  self.magicView.headerView .backgroundColor=[UIColor orangeColor];
  //  self.magicView.needPreloading=NO;//预加载开关。 等于NO 点击菜单时无过度动画
    self.magicView.headerHeight = 84;//头部组件的高度默认64
    // self.magicView.navigationHeight = 44;//顶部导航条的高度，默认是44
    self.magicView.againstStatusBar = YES;//顶部导航栏是否紧贴系统状态栏，即是否需要为状态栏留出20个点的区域，默认NO
    // self.magicView.headerView.backgroundColor =randomColor;
    self.magicView.layoutStyle = VTLayoutStyleDefault;//导航菜单的布局样式
    // self.edgesForExtendedLayout = UIRectEdgeAll;
    //    self.magicView.itemScale = 1.2;//点击字体放大
    //    self.magicView.itemSpacing = 20.f;//文本直接的距离
    //    self.magicView.headerHidden = NO;//是否隐藏头部组件，默认YES
    //    self.magicView.bounces = YES;//滑到边缘是否反弹
    
    self.magicView.previewItems=2;//导航菜单item的预览数，默认为1
   // self.magicView.separatorHeight = 2.f;//导航分割线高度
  //  self.magicView.separatorColor = [UIColor blueColor];//导航分割线高度颜色
    self.magicView.separatorHidden = YES;//是否隐藏导航分割线
   // UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    //separatorView.backgroundColor=[UIColor redColor];
    //[self.magicView setSeparatorView:separatorView];
    
    //下方设置导航分割线 阴影效果
    // self.magicView.navigationView.layer.shadowColor = RGBCOLOR(22, 146, 211).CGColor;
    // self.magicView.navigationView.layer.shadowOffset = CGSizeMake(0, 0.5);
    // self.magicView.navigationView.layer.shadowOpacity = 0.8;
   //  self.magicView.navigationView.clipsToBounds = NO;
    
}
#pragma mark 点击事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=touches.anyObject;
    CGPoint location= [touch locationInView:self.view];
    /*创建弹性动画
     damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
     velocity:弹性复位的速度
     delay 延迟 秒
     */
    [UIView animateWithDuration:5.0 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _imageView.center=location; //CGPointMake(160, 284);
    } completion:nil];
  
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollContentOffsetY = scrollView.contentOffset.y;
    NEWSLog(@"scrollContentOffsetY:%f",scrollContentOffsetY);
  //  [_scrollDelegate mainHomeScrollViewDidScroll2OffsetY:scrollContentOffsetY];
}

- (void)subscribeAction:(UIButton *)sender{
    self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
}
#pragma mark - menuListdata
- (void)generateData{
    
     NSString *path=[[NSBundle mainBundle]pathForResource:@"menu" ofType:@"plist"];
    _menuList=[[NSMutableArray alloc]init];
    //将plist中的信息读到数组中
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:path];

    for (NSDictionary *dic in plistArray) {
        MainModel *model=[[MainModel alloc]initWithDict:dic];
        [_menuList addObject:model];

    }
    [self.magicView reloadData];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
