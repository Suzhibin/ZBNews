//
//  ChannelViewModel.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/9.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "ChannelViewModel.h"

#import "API_Constants.h"

#import "Constants.h"
@interface ChannelViewModel()<ZBURLSessionDelegate>
@property (nonatomic,strong)NSMutableArray *dataArr;
@end
@implementation ChannelViewModel

- (void)getDataWithUrl:(NSString *)url type:(apiType)type{
    [[ZBURLSessionManager sharedManager] setValue:APIKEY forHTTPHeaderField:@"apikey"];
    [[ZBURLSessionManager sharedManager]getRequestWithUrlString:url target:self apiType:type];

}
#pragma mark - ZBURLSessionDelegate
- (void)urlRequestFinished:(ZBURLSessionManager *)request{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *body=[dict objectForKey:@"showapi_res_body"];
    NSDictionary *pagebean=[body objectForKey:@"pagebean"];
    NSMutableArray *contentlist=[pagebean objectForKey:@"contentlist"];
  //  NSMutableArray * arr = [self getPreparedArrWith:contentlist];
    for (NSDictionary *dic in contentlist) {
        ChannelModel *model=[[ChannelModel alloc]initWithDict:dic];
        model.imageurls=[dic objectForKey:@"imageurls"];
        if ( model.imageurls.count>0) {
            for (NSDictionary *imagedict in model.imageurls) {
                model.url=[imagedict objectForKey:@"url"];
            }
        }
       // [self.dataArr addObject:model];
        NSLog(@"%@",model.title);
        if ([self.delegate respondsToSelector:@selector(requestFinished:sendModel:)]) {
            [self.delegate requestFinished:request sendModel:model];
        }
    }

  
}
- (void)urlRequestFailed:(ZBURLSessionManager *)request{
    if ([self.delegate respondsToSelector:@selector(requestFailed:)]) {
        [self.delegate requestFailed:request];
    }
}
- (NSMutableArray *)getPreparedArrWith:(NSMutableArray *)dataArr{
    
    
    return self.dataArr;
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
@end
