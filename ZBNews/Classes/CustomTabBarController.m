//
//  CustomTabBarController.m
//  SynPush
//
//  Created by suzhibin on 14-7-11.
//  Copyright (c) 2014年 suzhibin. All rights reserved.
//

#import "CustomTabBarController.h"
#import "MainViewController.h"
#import "MeViewController.h"
#import "GlobalSettingsTool.h"
@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editchangeNightView) name:@"showNightView" object:nil];//夜间模式通知
 

    [self createTabBar];
}
- (void)editchangeNightView{
    if ([GlobalSettingsTool getNightPattern]==YES) {
        self.tabBar.backgroundImage=[UIImage imageNamed:@"tabbg"];
    }else{
        self.tabBar.backgroundImage=nil;
        self.tabBar.backgroundColor=[UIColor whiteColor];
    }
}
- (void)createTabBar{
    NSArray *vcArr=@[@"MainViewController",@"MeViewController"];
    NSArray *images=@[@"tab_c0",@"tab_c1",@"tab_c2",@"tab_c3"];
    NSArray *seleImages=@[@"tab_0",@"tab_1",@"tab_2",@"tab_3"];
    NSArray *titleArr=[NSArray arrayWithObjects:@"首页",@"个人中心",nil];
    NSMutableArray *viewControllers=[NSMutableArray array];
    for (int i=0; i<vcArr.count; i++) {
       // NSString *title=[titleArr objectAtIndex:i];
        Class cls=NSClassFromString(vcArr[i]);
        UIViewController *vc=[[cls alloc]init];
        vc.title=titleArr[i];
        UINavigationController *nc=[[UINavigationController alloc]initWithRootViewController:vc];
        NSString *image=[images objectAtIndex:i];
        NSString *seleImage=[seleImages objectAtIndex:i];
        //ios7不推荐用的方法
       // [nc.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:seleImage] withFinishedUnselectedImage:[UIImage imageNamed:image]];
        
        // ios7 增加了一个新的方法
        // 显示真实的图片的内容!!
       nc.tabBarItem.image=[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nc.tabBarItem.selectedImage=[[UIImage imageNamed:seleImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [viewControllers addObject:nc];
        
    }
    self.viewControllers=viewControllers;
    if ([GlobalSettingsTool getNightPattern]==YES) {
      //  self.tabBar.backgroundColor=[UIColor colorWithRed:0.07 green:0.11 blue:0.07 alpha:1.00];
          self.tabBar.backgroundImage=[UIImage imageNamed:@"tabbg"];
    }else{
          self.tabBar.backgroundImage=nil;
        self.tabBar.backgroundColor=[UIColor whiteColor];
    }
  

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


