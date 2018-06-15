//
//  offlineViewController.h
//  ZBNews
//
//  Created by NQ UEC on 16/12/8.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "BaseViewController.h"
@protocol offlineDelegate <NSObject>

- (void)downloadWithArray:(NSMutableArray *)offlineArray;
@end
@interface offlineViewController : BaseViewController
@property (nonatomic,weak)id<offlineDelegate>delegate;
@end
