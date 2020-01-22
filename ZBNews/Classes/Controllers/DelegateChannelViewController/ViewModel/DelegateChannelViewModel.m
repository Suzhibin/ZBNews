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
- (void)requestListDataWithPage:(NSInteger)page menuInfo:(MenuInfo*)menuInfo requestType:(ZBApiType)requestType{
    self.requestType=requestType;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"id"] = menuInfo.menu_id;
    parameters[@"p"] = @(page).stringValue;
    self.identifier = [ZBRequestManager requestWithConfig:^(ZBURLRequest *request){
        request.URLString=@"/wnl/tag/page";
        request.apiType=self.requestType;
        request.parameters=parameters;
    }  success:^(id responseObject,ZBURLRequest *request){
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)responseObject;
            if (request.apiType==ZBRequestTypeRefreshAndCache) {
                [self.channelList removeAllObjects];//清除数据 等待新数据的到来
            }
            for (NSDictionary *dic in array) {
                RACChannelModel *model=[[RACChannelModel alloc]initWithDict:dic];
                [self.channelList addObject:model];
            }
            if (request.isCache) {
                SLog(@"%@-读缓存",menuInfo.title);
            }else{
                SLog(@"%@-重新请求",menuInfo.title);
            }
            if([self.viewModelDelegate respondsToSelector:@selector(requestFinished:)]) {
                [self.viewModelDelegate requestFinished:self.channelList];
            }
        }
      
    } failure:^(NSError *error){
        if([self.viewModelDelegate respondsToSelector:@selector(requestFailed:)]) {
            [self.viewModelDelegate requestFailed:error];
        }
    }];
}

- (void)cancelRequest{
    [ZBRequestManager cancelRequest:self.identifier];
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
