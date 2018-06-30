//
//  DelegateChannelViewModel.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "DelegateChannelViewModel.h"
#import "DelegateChannelFirstCell.h"
#import "DelegateChannelSecondCell.h"
@implementation DelegateChannelViewModel
- (void)requestListDataWithPage:(NSInteger)page menuInfo:(MenuInfo*)menuInfo requestType:(apiType)requestType{
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
    }  success:^(id responseObj,apiType type,BOOL isCache){
        if (type==ZBRequestTypeRefresh) {
            [self.channelList removeAllObjects];//清除数据 等待新数据的到来
        }
        NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in array) {
            RACChannelModel *model=[[RACChannelModel alloc]initWithDict:dic];
            [self.channelList addObject:model];
        }
        if (isCache) {
            SLog(@"%@-读缓存",menuInfo.title);
        }else{
            SLog(@"%@-重新请求",menuInfo.title);
        }
        if([self.viewModelDelegate respondsToSelector:@selector(requestFinished:)]) {
            [self.viewModelDelegate requestFinished:self.channelList];
        }
    } failure:^(NSError *error){
        if([self.viewModelDelegate respondsToSelector:@selector(requestFailed:)]) {
            [self.viewModelDelegate requestFailed:error];
        }
    }];
}

- (void)cancelRequestWithMenuInfo:(MenuInfo*)menuInfo{
    [self cancelRequestWithURLString:self.urlString menuInfo:menuInfo];
}

- (NSString *)dataCellIdentifier:(RACChannelModel *)model{
    if ([model.icon isKindOfClass:[NSDictionary class]]){
        return NSStringFromClass([DelegateChannelFirstCell class]);
    }else{
        return NSStringFromClass([DelegateChannelSecondCell class]);
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
