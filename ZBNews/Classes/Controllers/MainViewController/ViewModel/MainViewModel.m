//
//  MainViewModel.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/12.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "MainViewModel.h"

@implementation MainViewModel
- (RACSignal *)requestMenuData{
    RACSignal *signal=[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
       
        NSString *path=[[NSBundle mainBundle]pathForResource:@"menu" ofType:@"plist"];
        //将plist中的信息读到数组中
        NSArray *plistArray = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *dic in plistArray) {
            MenuInfo *model=[[MenuInfo alloc]initWithDict:dic];
            [self.menuList addObject:model];
        }
        
        //发送信号
        [subscriber sendNext:self.menuList];
        [subscriber sendCompleted];
        return nil;
    }];
    return signal;
}

@end
