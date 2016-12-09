//
//  MyViewTool.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/8.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "MyViewTool.h"
#import "Constants.h"
@interface MyViewTool ()

@property (strong,nonatomic) UILabel* TimedOutLabel;


@end
@implementation MyViewTool
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // self.backgroundColor=[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
        
       // self.backgroundColor=[[UIColor colorWithRed:0.60f green:0.60f blue:0.60f alpha:1.00f] colorWithAlphaComponent:0.5];
        
        
        self.TimedOutLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.TimedOutLabel.text=@"请求超时";
        self.TimedOutLabel.textAlignment=NSTextAlignmentCenter;
        self.TimedOutLabel.font = [UIFont systemFontOfSize:15];
        self.TimedOutLabel.backgroundColor=[UIColor colorWithRed:0.50 green:0.83 blue:0.98 alpha:1.00];
        self.TimedOutLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.TimedOutLabel];

    }
    return self;
}
- (void)hide
{
    [UIView animateWithDuration:0.50 animations:^{
        self.alpha = 0.0f;
  
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
