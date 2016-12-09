//
//  BaseViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
}
- (void)addItemWithTitle:(NSString *)title selector:(SEL)selector location:(BOOL)isLeft{
    
    UIBarButtonItem *item =[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain  target:self action:selector];
    
    if (isLeft == YES) {
        //左
        self.navigationItem.leftBarButtonItem = item;
    }else{
        //右边
        self.navigationItem.rightBarButtonItem = item;
    }
    
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
