//
//  BaseViewController.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDefine.h"
#import "API_Constants.h"
#import "UIImageView+WebCache.h"
#import "ZBKit.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import "MJRefresh.h"
#import  <VTMagic/VTMagic.h>
#import "BaseViewModel.h"
static const NSInteger timeOut = 60*60;
@interface BaseViewController : UIViewController
@property (nonatomic,strong)BaseViewModel *baseVM;
@end
