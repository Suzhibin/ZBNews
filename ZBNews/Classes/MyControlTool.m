//
//  MyControlTool.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "MyControlTool.h"
#import <SDAutoLayout.h>
#import "CKShimmerLabel.h"
#import "Constants.h"
@implementation MyControlTool

+ (MyControlTool *)sharedManager {
    static MyControlTool *myTool=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        myTool = [[MyControlTool alloc] init];
    });
    return myTool;
}

+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval
{
    NSTimeInterval seconds = [timeInterval integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [format stringFromDate:date];
}

- (UIView *)TimedOutAlert{
    self.TimedOutLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    self.TimedOutLabel.text=@"请求超时";
    self.TimedOutLabel.textAlignment=NSTextAlignmentCenter;
    self.TimedOutLabel.font = [UIFont systemFontOfSize:15];
    self.TimedOutLabel.backgroundColor=[UIColor colorWithRed:0.50 green:0.83 blue:0.98 alpha:1.00];
     self.TimedOutLabel.textColor=[UIColor whiteColor];
    return self.TimedOutLabel;
   
}
- (UIView *)loading:(UIView *)view{

      self.loadingLabel = [[CKShimmerLabel alloc] init];
        self.loadingLabel.text = @"新闻头条";
        self.loadingLabel.textColor = [UIColor grayColor];
        self.loadingLabel.font = [UIFont systemFontOfSize:30];
        self.loadingLabel.contentLabel.textAlignment=NSTextAlignmentCenter;
        self.loadingLabel.durationTime = 1.0;// 滚动时间
        [self.loadingLabel startShimmer];// 开启闪烁
        [view addSubview:self.loadingLabel];
        self.loadingLabel.sd_layout.centerXEqualToView(view).centerYEqualToView(view).heightIs(30).widthIs(140);
        return self.loadingLabel;

}
- (void)removeloadingLabel
{
    [UIView animateWithDuration:0.50 animations:^{
        self.loadingLabel.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [self.loadingLabel removeFromSuperview];
        
    }];
    
}
- (void)removeTimedOutAlertLabel
{
    [UIView animateWithDuration:0.50 animations:^{
        self.TimedOutLabel.alpha = 0.0f;

    } completion:^(BOOL finished) {
        [self.TimedOutLabel removeFromSuperview];

    }];

}
@end
