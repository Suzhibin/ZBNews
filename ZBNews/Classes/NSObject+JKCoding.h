//
//  NSObject+JKCoding.h
//  runtimeProject
//
//  Created by wangdan on 15/6/20.
//  Copyright (c) 2015年 wangdan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (JKCoding)


/**
 * 可以代替手写归档协议方法,支持
 * 继承类，对象嵌套以及字典、数组中持有对象
 *
 */
-(void)encodeWithCoder:(NSCoder *)aCoder;

-(instancetype)initWithCoder:(NSCoder *)aDecoder;


/**
 * 用于从字典生成模型类对象
 *
 */
+(id)objectFromDic:(NSDictionary*)dic;


+(NSArray *)objectArrayFromArray:(NSArray *)array;



@end
