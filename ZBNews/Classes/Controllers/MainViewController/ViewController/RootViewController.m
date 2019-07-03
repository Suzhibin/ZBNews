//
//  RootViewController.m
//  ZBNews
//
//  Created by Suzhibin on 2019/7/3.
//  Copyright © 2019 Suzhibin. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn_home= [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_home setTitle:@"首页" forState:UIControlStateNormal];
   
    btn_home.backgroundColor = [UIColor redColor];
    [btn_home setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_home.frame = CGRectMake(100, 300, 200, 50);
    btn_home.titleLabel.adjustsFontSizeToFitWidth=YES;
    [btn_home addTarget:self action:@selector(btn_Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_home];
}
- (void)btn_Action{
    MainViewController *vc=[[MainViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
