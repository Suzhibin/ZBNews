
//
//  HeadsPicture.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/8.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "HeadsPicture.h"
@interface HeadsPicture()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

-(NSString *)imagePathForKey:(NSString *)key;

@end
@implementation HeadsPicture
+(instancetype)sharedHeadsPicture{
    
    static HeadsPicture *instance = nil;
    //确保多线程中只创建一次对象,线程安全的单例
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        
        _dictionary = [[NSMutableDictionary alloc] init];
   
    }
    return self;
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key{
    dispatch_sync(dispatch_queue_create(0, DISPATCH_QUEUE_SERIAL), ^{
        [self.dictionary setObject:image forKey:key];
        //获取保存图片的全路径
        NSString *path = [self imagePathForKey:key];
        //从图片提取JPEG格式的数据,第二个参数为图片压缩参数
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        //以PNG格式提取图片数据
        //NSData *data = UIImagePNGRepresentation(image);
        
        //将图片数据写入文件
        [data writeToFile:path atomically:YES];

    });
}

-(UIImage *)imageForKey:(NSString *)key{
    //return [self.dictionary objectForKey:key];
    UIImage *image = [self.dictionary objectForKey:key];
    if (!image) {
        NSString *path = [self imagePathForKey:key];
        image = [UIImage imageWithContentsOfFile:path];
        if (image) {
            
            [self.dictionary setObject:image forKey:key];
        }else{
            
            NSLog(@"Error: unable to find %@", [self imagePathForKey:key]);
        }
    }
    return image;
}

-(NSString *)imagePathForKey:(NSString *)key{
    NSString *libraryDirectory=[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:key];
    return libraryDirectory;
}


@end
