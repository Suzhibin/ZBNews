//
//  ZBImageDownloader.m
//  ZBKit
//
//  Created by NQ UEC on 17/1/20.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBImageDownloader.h"
#import "NSFileManager+pathMethod.h"
#import "ZBConstants.h"
#import "UIImage+ZBKit.h"

NSString *const ImageDefaultPath =@"AppImage";
@interface ZBImageDownloader ()


@end
@implementation ZBImageDownloader

+ (ZBImageDownloader *)sharedInstance{
    static ZBImageDownloader *imageInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageInstance = [[ZBImageDownloader alloc] init];
    });
    return imageInstance;
}
- (id)init{
    self = [super init];
    if (self) {
    
        [[ZBCacheManager sharedInstance]createDirectoryAtPath:[self imageFilePath]];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(automaticCleanImageCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(automaticCleanImageCache)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundCleanImageCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)downloadImageUrl:(NSString *)imageUrl{
    [self downloadImageUrl:imageUrl completion:nil];
}

- (void)downloadImageUrl:(NSString *)imageUrl completion:(downloadCompletion)completion{
    [self downloadImageUrl:imageUrl path:[self imageFilePath] completion:completion];
}

- (void)downloadImageUrl:(NSString *)imageUrl path:(NSString *)path{
     [self downloadImageUrl:imageUrl path:path completion:nil];
}

- (void)downloadImageUrl:(NSString *)imageUrl path:(NSString *)path completion:(downloadCompletion)completion{
    
    if ([[ZBCacheManager sharedInstance]diskCacheExistsWithKey:imageUrl path:path]) {

        [[ZBCacheManager sharedInstance]getCacheDataForKey:imageUrl path:path value:^(NSData *data,NSString *filePath) {
            
             UIImage *image=[UIImage imageWithData:data];
            
            completion(image) ;
        }];
    
    }else{
        [self requestImageUrl:imageUrl completion:^(UIImage *image){
    
            [[ZBCacheManager sharedInstance]storeContent:image forKey:imageUrl path:path];
         
            completion(image);
        }];
    }
}

- (void)requestImageUrl:(NSString *)imageUrl completion:(downloadCompletion)completion{
    if (!imageUrl)return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSURL *url=[NSURL URLWithString:imageUrl];
        
        NSData *data=[NSData dataWithContentsOfURL:url];
        
        UIImage *image=[UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

- (NSUInteger)imageFileSize{
   return [[ZBCacheManager sharedInstance]getFileSizeWithpath:[self imageFilePath]];
}

- (NSUInteger)imageFileCount{
   return [[ZBCacheManager sharedInstance]getFileCountWithpath:[self imageFilePath]];
}

- (void)clearImageFile{
    [self clearImageFileCompletion:nil];
}

- (void)clearImageFileCompletion:(ZBCacheCompletedBlock)completion{
     [[ZBCacheManager sharedInstance]clearDiskWithpath:[self imageFilePath] completion:completion];
}

- (void)clearImageForkey:(NSString *)key{
    [self clearImageForkey:key completion:nil];
}

- (void)clearImageForkey:(NSString *)key completion:(ZBCacheCompletedBlock)completion{
    [[ZBCacheManager sharedInstance]clearCacheForkey:key path:[self imageFilePath] completion:completion];
}

- (void)automaticCleanImageCache{

    [[ZBCacheManager sharedInstance]automaticCleanCacheWithPath:[self imageFilePath] completion:nil];
}

- (void)backgroundCleanImageCache {
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return;
    }
    UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
    __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    [[ZBCacheManager sharedInstance]automaticCleanCacheWithPath:[self imageFilePath] completion:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    // Start the long-running task and return immediately.
}
/*
- (void)saveThePhotoAlbum:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        
    }else{
        
    }
}
 */

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            
            return nil;
    }
    return nil;
}

- (NSString *)imageFilePath{
    NSString *AppImagePath =  [[[ZBCacheManager sharedInstance]ZBKitPath]stringByAppendingPathComponent:ImageDefaultPath];
    return AppImagePath;
}


@end
