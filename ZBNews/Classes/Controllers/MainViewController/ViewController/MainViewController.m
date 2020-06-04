//
//  MainViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "MainViewController.h"
#import "CommonDefine.h"
#import "MenuInfo.h"
#import "RACChannelViewController.h"
#import "DelegateChannelViewController.h"
#import "MeViewController.h"
#import "MainViewModel.h"
#import "MenuButton.h"
@interface MainViewController ()

@property (nonatomic, strong)  NSMutableArray *menuList;

@end

@implementation MainViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //此方法会使 系统侧滑返回手势失效
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self generateData];
    [self integrateComponents];
    [self configSeparatorView];
}
#pragma mark - menuListdata
- (void)generateData{
    MainViewModel *viewModel=[[MainViewModel alloc]init];
    RACSignal *signal =[viewModel.command execute:nil];
    [signal subscribeNext:^(id  _Nullable x) {
        self.menuList=x;
        [self.magicView reloadData];
    }];
    /*
    [[viewModel requestMenuData]subscribeNext:^(id  _Nullable x) {
        self.menuList=x;
        [self.magicView reloadData];
    }];
     */
}
#pragma  mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    NSMutableArray *titleList = [NSMutableArray array];
        for (MenuInfo *menu in _menuList) {
            [titleList addObject:menu.title];
        }
    return titleList;
}
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex{
    static NSString *itemIdentifier = @"itemIdentifier";
    MenuButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [MenuButton buttonWithType:UIButtonTypeCustom];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16.f];
        [menuItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuItem setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    }
    menuItem.verticalLineHidden=(_menuList.count-1==itemIndex)?YES:NO;
    return menuItem;
}
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex{
    MenuInfo *menuInfo=_menuList[pageIndex];
    if ([menuInfo.viewType integerValue]==1) {
        static NSString *racVCId = @"racVC.identifier";
        RACChannelViewController *racVC= [magicView dequeueReusablePageWithIdentifier:racVCId];
        if (!racVC) {
            racVC=[[RACChannelViewController alloc]init];
        }
        racVC.menuInfo=menuInfo;
        return racVC;
    }else{
        static NSString *delegateVCId = @"DelegateVC.identifier";
        DelegateChannelViewController *delegateVC= [magicView dequeueReusablePageWithIdentifier:delegateVCId];
        if (!delegateVC) {
            delegateVC=[[DelegateChannelViewController alloc]init];
        }
        delegateVC.menuInfo=menuInfo;
        return delegateVC;
    }
}
#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex{
  //  SLog(@"index:%ld viewDidAppearer:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex{
  //  SLog(@"index:%ld viewDidDisappearer:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex{
   // SLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

- (void)configSeparatorView {

    [self createMeButton];
    self.magicView.headerHidden =NO;

    self.magicView.needPreloading=YES;//预加载开关。 等于NO 点击菜单时无过度动画
    self.magicView.headerHeight = ZB_STATUS_HEIGHT+44;//头部组件的高度默认64
    self.magicView.navigationHeight = 64;//顶部导航条的高度，默认是44
    self.magicView.navigationColor=[UIColor whiteColor];
   // self.magicView.againstStatusBar = NO;//顶部导航栏是否紧贴系统状态栏，即是否需要为状态栏留出20个点的区域，默认NO
    self.magicView.headerView.backgroundColor=[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    
    self.magicView.layoutStyle = VTLayoutStyleDefault;//导航菜单的布局样式
    self.magicView.switchStyle= VTSwitchStyleStiff;
    // self.edgesForExtendedLayout = UIRectEdgeAll;
     self.magicView.itemScale = 1.2;//点击字体放大
    // self.magicView.itemSpacing = 20.f;//文本直接的距离
    // self.magicView.headerHidden = NO;//是否隐藏头部组件，默认YES
    // self.magicView.bounces = YES;//滑到边缘是否反弹
   
   // self.magicView.previewItems=2;//导航菜单item的预览数，默认为1
     self.magicView.displayCentered=YES;//居中
     self.magicView.sliderWidth=30;
    // self.magicView.separatorHeight = 2.f;//导航分割线高度
    // self.magicView.separatorColor = [UIColor blueColor];//导航分割线高度颜色
   // self.magicView.separatorHidden = YES;//是否隐藏导航分割线
    // UIImageView *separatorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
    //separatorView.backgroundColor=[UIColor redColor];
    //[self.magicView setSeparatorView:separatorView];
    //下方设置导航分割线 阴影效果
    // self.magicView.navigationView.layer.shadowColor = RGBCOLOR(22, 146, 211).CGColor;
    // self.magicView.navigationView.layer.shadowOffset = CGSizeMake(0, 0.5);
    // self.magicView.navigationView.layer.shadowOpacity = 0.8;
    // self.magicView.navigationView.clipsToBounds = NO;
}

- (void)integrateComponents{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [rightButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [rightButton setTitle:@"+" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    //rightButton.backgroundColor=[UIColor blueColor];
    rightButton.center = self.view.center;
    [rightButton addTarget:self action:@selector(subscribeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.magicView.rightNavigatoinItem = rightButton;
}

- (void)subscribeAction:(UIButton *)sender{
    self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
}

- (void)createMeButton{
    UIButton *meButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [meButton setTitle:@"设置" forState:UIControlStateNormal];
    [meButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    @weakify(self);
    [[meButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        x.enabled=NO;
        
        MeViewController *meVC=[[MeViewController alloc]init];
        [self.navigationController pushViewController:meVC animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            x.enabled = YES;
        });
    }];
    [self.magicView.headerView addSubview:meButton];
    
    [meButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.right.equalTo(self.magicView.headerView.mas_right).offset(-15);
        make.width.offset(44);
        make.height.offset(44);
    }];
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
