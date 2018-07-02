//
//  MainViewModel.h
//  ZBNews
//
//  Created by NQ UEC on 2018/6/12.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "BaseViewModel.h"

@interface MainViewModel : BaseViewModel

@property(nonatomic,strong)RACCommand *command;
 //注释掉 用command
//- (RACSignal *)requestMenuData;

@end
