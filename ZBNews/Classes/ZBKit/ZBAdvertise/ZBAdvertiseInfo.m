//
//  ZBAdvertiseInfo.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBAdvertiseInfo.h"
#import "ZBNetworking.h"
#import "ZBConstants.h"                                                                                                                                                                                                             
#import "ZBImageDownloader.h"
NSString *const urlString=@"http://192.168.33.186:9080/BOSS_APD_WEB//news/ad/screen_zh_CN";
NSString *const AdDefaultPath =@"Advertise";

@implementation ZBAdvertiseInfo

+ (void)getAdvertisingInfo:(ZBAdvertisingInfo)info{

    [[ZBCacheManager sharedInstance]createDirectoryAtPath:[self advertiseFilePath]];
    
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [ZBAdvertiseInfo getFilePathWithImageName:[[NSUserDefaults standardUserDefaults] valueForKey:adImageName]];
    
    NSString *plistPath = [ZBAdvertiseInfo getFilePathWithPlistName:[[NSUserDefaults standardUserDefaults] valueForKey:adUrl]];
    
    NSDictionary *dict=[NSDictionary dictionaryWithContentsOfFile:plistPath];

    BOOL isExist =  [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:FALSE];
    
    info ? info(filePath,dict,isExist) : nil;
     // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
     [ZBAdvertiseInfo requestAdvertising];
 

}
/**
 *  请求广告页面
 */
+ (void)requestAdvertising{
    
    //本地数据 正式使用请注掉
     NSString *adData = [[NSBundle mainBundle] pathForResource:@"adData" ofType:@"plist"];
    
     NSString *adData1 = [[NSBundle mainBundle] pathForResource:@"adData2" ofType:@"plist"];

     NSArray *plistArray=[NSArray arrayWithObjects:adData,adData1, nil];
    
     NSString *plist= plistArray[arc4random() % plistArray.count];

     NSArray *array = [[NSMutableArray alloc] initWithContentsOfFile:plist];

    for (NSDictionary *dic in array) {
        NSString *imageUrl=[dic objectForKey:@"imgUrl"];
        NSString *url=[dic objectForKey:@"url"];
        // 获取图片名:43-130P5122Z60-50.jpg
        NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
        NSString *imageName = stringArr.lastObject;
        // 拼接沙盒路径
        NSString *filePath = [ZBAdvertiseInfo getFilePathWithImageName:imageName];
        
        
        NSArray *urlArr = [url componentsSeparatedByString:@"//"];
        NSString *urlName = urlArr.lastObject;
        NSString *plistPath = [ZBAdvertiseInfo getFilePathWithPlistName:urlName];
        
        BOOL isExist =  [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:FALSE];
        
        BOOL plistExist=  [[NSFileManager defaultManager] fileExistsAtPath:plistPath isDirectory:FALSE];
        
        if (!isExist||!plistExist){// 如果该图片不存在，则删除老图片，下载新图片
            ZBKLog(@"下载图片和url");
            [ZBAdvertiseInfo downloadAdWithImageUrl:imageUrl url:url imageName:imageName urlName:urlName];
        }else{
            ZBKLog(@"有开屏缓存图片");
        }
    }
    

    /*
    //网络数据
     [[ZBURLSessionManager sharedManager]requestWithConfig:^(ZBURLRequest *request){
         request.urlString=@"请求的url";
         request.timeoutInterval=5;
         request.apiType=ZBRequestTypeRefresh;//每次重新请求 查看是否有新图片
     } success:^(id responseObj,apiType type){
         id result = [NSJSONSerialization JSONObjectWithData:responseObj options:NSJSONReadingMutableContainers error:nil];
         if ([result isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)result;
             if (array.count==0) {
                 [ZBAdvertiseInfo deleteOldImage];
                 ZBKLog(@"无开屏广告数据");
             }else{
                 ZBKLog(@"有开屏广告数据");
                 for (NSDictionary *dic in array) {
                     NSString *imageUrl=[dic objectForKey:@"imgUrl"];
                     NSString *url=[dic objectForKey:@"url"];
                     
                     // 获取图片名:43-130P5122Z60-50.jpg
                     NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
                     NSString *imageName = stringArr.lastObject;
                     // 拼接沙盒路径
                     NSString *filePath = [ZBAdvertiseInfo getFilePathWithImageName:imageName];
                     
                      // 获取url名:www.baidu.com
                     NSArray *urlArr = [url componentsSeparatedByString:@"//"];
                     NSString *urlName = urlArr.lastObject;
                     NSString *plistPath = [ZBAdvertiseInfo getFilePathWithPlistName:urlName];
                     
                     BOOL isExist =  [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:FALSE];
                     
                     BOOL plistExist=  [[NSFileManager defaultManager] fileExistsAtPath:plistPath isDirectory:FALSE];
                     
                     if (!isExist||!plistExist){// 如果该图片不存在，则删除老图片，下载新图片
                         ZBKLog(@"下载图片和url");
                         [ZBAdvertiseInfo downloadAdWithImageUrl:imageUrl url:url imageName:imageName urlName:urlName];
                     }else{
                         ZBKLog(@"有开屏缓存图片");
                     }
                 }
             }
         }
     
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
+ (void)downloadAdWithImageUrl:(NSString *)imageUrl url:(NSString *)url imageName:(NSString *)imageName urlName:(NSString *)urlName{
    
    [[ZBImageDownloader sharedInstance] requestImageUrl:imageUrl completion:^(UIImage *image){
        
        NSString *filePath = [ZBAdvertiseInfo getFilePathWithImageName:imageName]; // 保存图片文件的名称
        
        NSString *plistPath = [ZBAdvertiseInfo getFilePathWithPlistName:urlName]; // 保存url plist的名称
        
        NSDictionary *linkdict=@{@"link":url};
        [ZBAdvertiseInfo deleteOldImage];//删除旧图片
        
        //暂时没有使用 编码方法存储
        if ( [[ZBCacheManager sharedInstance]setContent:image writeToFile:filePath]) {// 保存成功
        
            ZBKLog(@"开屏image保存成功:%@",filePath);
            [[NSUserDefaults standardUserDefaults] setValue:imageName forKey:adImageName];
            [[NSUserDefaults standardUserDefaults] synchronize];

            // 如果有广告链接，将广告链接也保存下来
             [[ZBCacheManager sharedInstance]setContent:linkdict writeToFile:plistPath];
            
            ZBKLog(@"开屏url保存成功:%@",plistPath);
            [[NSUserDefaults standardUserDefaults] setValue:urlName forKey:adUrl];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            ZBKLog(@"开屏image保存失败");
        }

    }];
}

+ (void)deleteOldImage{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSString *imageName = [[NSUserDefaults standardUserDefaults] valueForKey:adImageName];
        
        NSString *plistName = [[NSUserDefaults standardUserDefaults] valueForKey:adUrl];
        
        if (imageName) {
          
            NSString *filePath = [ZBAdvertiseInfo getFilePathWithImageName:imageName];
            NSString *plistPath = [ZBAdvertiseInfo getFilePathWithPlistName:plistName];
            ZBKLog(@"删除%@",filePath);
            ZBKLog(@"删除%@",plistPath);
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:plistPath error:nil];
        }
    });
}

+ (NSString *)getFilePathWithPlistName:(NSString *)plistName{
    if (plistName) {
        NSString *name = [NSString stringWithFormat:@"%@.plist",plistName];
        NSString *filePath =[[self advertiseFilePath] stringByAppendingPathComponent:name];
        return filePath;
    }
    return nil;
}

+ (NSString *)getFilePathWithImageName:(NSString *)imageName{
    if (imageName) {
        NSString *filePath =[[self advertiseFilePath] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    return nil;
}

+ (NSString *)advertiseFilePath{
    NSString *AdvertisePath = [[[ZBCacheManager sharedInstance]ZBKitPath]stringByAppendingPathComponent:AdDefaultPath];
    return AdvertisePath;
}


+ (NSUInteger)advertiseFileSize{
    return [[ZBCacheManager sharedInstance]getFileSizeWithpath:[self advertiseFilePath]];
}

+ (NSUInteger)advertiseFileCount{
    return [[ZBCacheManager sharedInstance]getFileCountWithpath:[self advertiseFilePath]];
}

@end
