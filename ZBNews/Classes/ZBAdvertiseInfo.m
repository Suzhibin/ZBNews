//
//  ZBAdvertiseInfo.m
//  ZBNetworkingDemo
//
//  Created by NQ UEC on 17/1/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBAdvertiseInfo.h"

@implementation ZBAdvertiseInfo


+ (void)getAdvertising:(AdvertisingInfo)info{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[ZBAdvertiseInfo createFilePath]]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:[ZBAdvertiseInfo createFilePath] withIntermediateDirectories:YES attributes:nil error:nil];
    } else {
         NSLog(@"Advertising is exists.");
    }
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [ZBAdvertiseInfo getFilePathWithImageName:[[NSUserDefaults standardUserDefaults] valueForKey:adImageName]];
    
    BOOL isExist =  [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:FALSE];
    
    info ? info(filePath,isExist) : nil;
    
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [ZBAdvertiseInfo getAdvertisingImage];
}

/**
 *  请求广告页面
 */
+ (void)getAdvertisingImage{
    
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
    // 拼接沙盒路径
    NSString *filePath = [ZBAdvertiseInfo getFilePathWithImageName:imageName];
    BOOL isExist =  [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:FALSE];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [ZBAdvertiseInfo downloadAdImageWithUrl:imageUrl imageName:imageName];
        
    }else{
        NSLog(@"有图片");
    }

    /*
     [ZBNetworkManager requestWithConfig:^(ZBURLRequest *request){
     request.urlString=@"广告url";
     request.timeoutInterval=5;
     request.apiType=ZBRequestTypeRefresh;
     //  request.path=AdvertisePath;
     }  success:^(id responseObj,apiType type){
     
     NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
     NSArray *array=[dataDict objectForKey:@"videos"];
     for (NSDictionary *dict in array) {
     DetailsModel *model=[[DetailsModel alloc]initWithDict:dict];
     [self.dataArray addObject:model];
     
     }
     
     NSString *lastImage=[NSString stringWithFormat:@"%@",((DetailsModel *)[self.dataArray objectAtIndex:3]).thumb];
     } failed:^(NSError *error){
     if (error.code==NSURLErrorCancelled)return;
     if (error.code==NSURLErrorTimedOut){
     
     }else{
     
     }
     }];
     */
}
/**
 *  下载新图片
 */
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [ZBAdvertiseInfo deleteOldImage];
            [[NSUserDefaults standardUserDefaults] setValue:imageName forKey:adImageName];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
    });
}
/**
 *  删除旧图片
 */
+ (void)deleteOldImage{
    //删除旧图片
    NSString *imageName = [[NSUserDefaults standardUserDefaults] valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [ZBAdvertiseInfo getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}
/**
 *  根据图片名拼接文件路径
 */
+ (NSString *)getFilePathWithImageName:(NSString *)imageName{
    if (imageName) {
        NSString *filePath =[[ZBAdvertiseInfo createFilePath] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    
    return nil;
}

+ (NSString *)createFilePath{
    
    NSString *AdvertisePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Advertise"];
    NSString *imagePath = [AdvertisePath stringByAppendingPathComponent:@"AdvertiseImage"];
    return imagePath;
}
@end
