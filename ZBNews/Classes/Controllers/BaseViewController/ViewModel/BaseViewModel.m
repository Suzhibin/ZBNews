
//
//  BaseViewModel.m
//  ZBNews
//
//  Created by NQ UEC on 2018/3/23.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "BaseViewModel.h"
#import "DetailViewController.h"
@implementation BaseViewModel

- (void)pushModel:(RACChannelModel *)model controller:(UIViewController *)controller completion:(pushCompletedBlock)completion{
//    if (model=详情) {
//
//    }else if(model=外链){
//
//    }else{
//
//    }
    DetailViewController *detailsVC=[[DetailViewController alloc]init];
    detailsVC.model=model;
    // 设置代理信号
    detailsVC.delegateSubject = [RACSubject subject];
    [detailsVC.delegateSubject subscribeNext:^(id  _Nullable x) {
        if (completion) {
            completion(x);
        }
    }];
    [controller.navigationController pushViewController:detailsVC animated:YES];
}

- (void)cancelRequestWithURLString:(NSString *)URLString menuInfo:(MenuInfo*)menuInfo{
    [ZBRequestManager cancelRequest:URLString completion:^(BOOL results, NSString *urlString) {
        if (results==YES) {
           SLog(@"\n 取消请求成功 \n 栏目:%@ \n id:%@ \n URL:%@",menuInfo.title,menuInfo.menu_id,urlString)
        }else{
            SLog(@"%@ 已经请求完毕无法取消",menuInfo.title);
        }
    }];
}

#pragma mark - 懒加载
- (NSMutableArray *)menuList {
    if (!_menuList) {
        _menuList = [[NSMutableArray alloc] init];
    }
    return _menuList;
}

- (NSMutableArray *)channelList {
    if (!_channelList) {
        _channelList = [[NSMutableArray alloc] init];
    }
    return _channelList;
}
@end

