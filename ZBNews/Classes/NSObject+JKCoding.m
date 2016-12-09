//
//  NSObject+JKCoding.m
//  runtimeProject
//
//  Created by wangdan on 15/6/20.
//  Copyright (c) 2015年 wangdan. All rights reserved.
//

#import "NSObject+JKCoding.h"

@implementation NSObject (JKCoding)


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    Class currentClass = self.class;
    if (currentClass == NSObject.class) {
        return;
    }
    while (currentClass && currentClass != [NSObject class])
    {
        unsigned int count = 0;
        objc_property_t *pList = class_copyPropertyList(currentClass, &count);
        if (count>0) {
            for (int i=0;i<count;i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(pList[i])];
                [aCoder encodeObject: [self valueForKey:key] forKey:key];
            }
        }
        currentClass = class_getSuperclass(currentClass);
        free(pList);
    }
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
   
    Class currentClass = self.class;
    if (currentClass == NSObject.class) {
        return nil;
    }
    while (currentClass && currentClass != [NSObject class])
    {
        unsigned int count = 0;
        objc_property_t *pList = class_copyPropertyList(currentClass, &count);
        if (count > 0) {
            for (int i = 0;i < count;i++) {
                NSString *key = [NSString stringWithUTF8String:property_getName(pList[i])];
                [self setValue:[aDecoder  decodeObjectForKey:key] forKey:key];
            }
        }
        currentClass = class_getSuperclass(currentClass);
        free(pList);
    }

    return  self;
}



+(id)objectFromDic:(NSDictionary*)dic
{
    return [[self alloc] initFromDic:dic];
}

+(NSArray *)objectArrayFromArray:(NSArray *)array
{
    if (array == nil || array.count == 0) {
        return nil;
    }
    
    NSMutableArray *objArray = [[NSMutableArray alloc] init ];
    [objArray enumerateObjectsUsingBlock:^(id objDic, NSUInteger idx, BOOL *stop) {
        id obj = [[self alloc] initFromDic:objDic];
        if (obj) {
            [objArray addObject:obj];
        }
    }];
    return objArray;
}


-(id)initFromDic:(NSDictionary *)dic
{
    if (self.class == NSObject.class) {
        return nil;
    }
    else {
        self = [self init];
    }
    
    if (self) {
        Class currentClass = self.class;
        NSMutableArray *propertyList = [[NSMutableArray alloc] init];
        NSMutableArray *attributeNameList = [[NSMutableArray alloc] init];
        
        while (currentClass && currentClass != NSObject.class)
        {
            unsigned int count = 0;
            objc_property_t *pList =  class_copyPropertyList(currentClass, &count);
            if (count > 0)
            {
                for (int i = 0; i < count; i++)
                {
                    NSString *propertyString = [NSString stringWithUTF8String:property_getName(pList[i])];
                    [propertyList addObject:propertyString];
                    
                    NSString *attributeString = [NSString stringWithUTF8String:property_getAttributes(pList[i])];
                    [attributeNameList addObject:attributeString];
                }
            }
            free(pList);
            currentClass = class_getSuperclass(currentClass);
        }
        
        
        if (propertyList.count == 0) {
            return self;
        }
        
        
        for (int i=0; i<propertyList.count ; i++) {
            
            NSString *key = propertyList[i];
            NSString *propertyType = [self getClassNameFromPropertyName:attributeNameList[i]];
            
            id obj = [dic objectForKey:key];
            if (obj == nil) {
                continue;
            }
            
            if (propertyType == nil) {
                [self setValue:obj forKey:key];
            }
            else if (([propertyType isEqualToString:@"NSMutableArray"] || [propertyType isEqualToString:@"NSArray"])
                     && [obj isKindOfClass:[NSArray class]]) {
                
                    SEL classNameMethod = NSSelectorFromString(@"classNameForKeys");
                    if ([self respondsToSelector:classNameMethod]) {
                        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        
                        NSDictionary *classNameDic = (NSDictionary*)[self performSelector:classNameMethod];
                        Class propertyClass = [classNameDic objectForKey:key];
                        
                        if (propertyClass) {
                            NSMutableArray *objArray = [[NSMutableArray alloc] init];
                            for (NSDictionary *objDic in obj) {
                                id transferedObj = [propertyClass objectFromDic:objDic];
                                if (transferedObj) {
                                    [objArray addObject:transferedObj];
                                }
                            }
                            [self setValue:objArray forKey:key];
                        }
                        else {
                            [self setValue:obj forKey:key];
                        }
                    }
                    else {
                        [self setValue:obj forKey:key];
                    }
            }
            else {
                
                Class keyClass = NSClassFromString(propertyType);
                if (keyClass) {
                    id transferedObj = [keyClass objectFromDic:obj];
                    if (transferedObj) {
                        [self setValue:transferedObj forKey:key];
                    }
                }
            }
        }
    }
    return self;
}



-(NSString *)getClassNameFromPropertyName:(NSString*)name
{
    if (name == nil) {
        return nil;
    }
    
    NSString * className = nil;
    if ([[name substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"@"]) {
        NSString *subRangeString = [name substringWithRange:NSMakeRange(3, 3)];
        if ([subRangeString isEqualToString:@"NSA"] || [subRangeString isEqualToString:@"NSM"]) {
            className = @"NSArray";
        }
        else {
            NSString *otherSystemString = [name substringWithRange: NSMakeRange(3, 2)];
            if ([otherSystemString isEqualToString:@"NS"]) {
                className = nil;
            }
            else {
                className = [[name componentsSeparatedByString:@"\""] objectAtIndex:1];
            }
        }
    }
    return className;
}



-(NSArray *)nomalObjTypeArray
{
    NSArray *array = @[@"NSDictonary",@"NSMutalbeDictionary",@"NSString",
                       @"NSNumber",@"NSAttributeString",@"NSValue",@"NSArray",@"NSMutableArray",
                       @"NSData"];
    return array;
}


@end
