//
//  HeadsPicture.h
//  ZBNews
//
//  Created by NQ UEC on 16/12/8.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HeadsPicture : NSObject
+(instancetype)sharedHeadsPicture;
/**
 *  设置头像
 *
 *  @param image 图片
 */
-(void)setImage:(UIImage *)image forKey:(NSString *)key;

/**
 *  读取图片
 *
 */
-(UIImage *)imageForKey:(NSString *)key;

@end
