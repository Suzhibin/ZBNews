//
//  MainViewController.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <VTMagic/VTMagic.h>
@protocol MainControllerScrollDelegate <NSObject>
- (void)mainScrollViewDidScroll2OffsetY:(CGFloat)offsetY;
@end
@interface MainViewController : VTMagicController
@property (weak, nonatomic) id<MainControllerScrollDelegate> scrollDelegate;
@end
