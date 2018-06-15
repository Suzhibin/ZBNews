//
//  DetailViewController.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "BaseViewController.h"
#import "RACChannelModel.h"

@interface DetailViewController : BaseViewController
@property (nonatomic,strong)RACChannelModel *model;

//使用 RACSubject代替代理。
@property (nonatomic,strong)RACSubject *delegateSubject;
@end
