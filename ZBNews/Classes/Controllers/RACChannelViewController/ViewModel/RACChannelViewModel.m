//
//  RACChannelViewModel.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "RACChannelViewModel.h"
#import "RACChannelFirstCell.h"
#import "RACChannelSecondCell.h"
@implementation RACChannelViewModel
- (RACSignal *)requestListDataWithPage:(NSInteger)page menuInfo:(MenuInfo*)menuInfo requestType:(apiType)requestType{
    
    RACSignal *signal=[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        self.urlString=[NSString stringWithFormat:NEWS_URL,menuInfo.menu_id,page];
        
        if (requestType==ZBRequestTypeCache) {
            SLog(@"%@-预加载URL:%@",menuInfo.title,self.urlString);
        }
        if (requestType==ZBRequestTypeRefresh) {
            SLog(@"%@-下拉URL:%@",menuInfo.title,self.urlString);
        }
        if (requestType==ZBRequestTypeRefreshMore) {
            SLog(@"%@-上拉更多URL:%@",menuInfo.title,self.urlString);
        }
        
        [ZBRequestManager requestWithConfig:^(ZBURLRequest *request){
            request.URLString=self.urlString;
            request.apiType=requestType;
        }  success:^(id responseObj,apiType type){
            if (type==ZBRequestTypeRefresh) {
                [self.channelList removeAllObjects];//清除数据 等待新数据的到来
            }
            NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in array) {
                RACChannelModel *model=[[RACChannelModel alloc]initWithDict:dic];
                [self.channelList addObject:model];
            }
            //发送信号
            [subscriber sendNext:self.channelList];
            [subscriber sendCompleted];
        } failure:^(NSError *error){
            [subscriber sendError:error];
            [subscriber sendCompleted];
        }finished:^(id responseObject, apiType type, NSError *error, BOOL isCache) {
            if (isCache) {
               SLog(@"%@-读缓存",menuInfo.title);
            }else{
                SLog(@"%@-重新请求",menuInfo.title);
            }
        }];
        
        return nil;
    }];
    return signal;
}

- (void)cancelRequestWithMenuInfo:(MenuInfo*)menuInfo{
    [self cancelRequestWithURLString:self.urlString menuInfo:menuInfo];
}

- (NSString *)dataCellIdentifier:(RACChannelModel *)model{
    if ([model.icon isKindOfClass:[NSDictionary class]]){
        return NSStringFromClass([RACChannelFirstCell class]);
    }else{
        return NSStringFromClass([RACChannelSecondCell class]);
    }
}

/*//移至 ViewModel 基类里
- (void)pushModel:(RACChannelModel *)model controller:(UIViewController *)controller{
    //    if (model=详情) {
    //
    //    }else if(model=外链){
    //
    //    }else{
    //
    //    }
    DetailViewController *detailsVC=[[DetailViewController alloc]init];
    detailsVC.model=model;
    [controller.navigationController pushViewController:detailsVC animated:YES];
}
*/
@end
