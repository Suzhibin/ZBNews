//
//  UIImageView+ZBKit.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/23.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "UIImageView+ZBKit.h"

@implementation UIImageView (ZBKit)

- (void)zb_setImageWithURL:(NSString *)urlString{
    [self zb_setImageWithURL:urlString completion:nil];
}

- (void)zb_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder{
    [self zb_setImageWithURL:urlString placeholderImage:placeholder path:nil];
}

- (void)zb_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder path:(NSString *)path{
    [self zb_setImageWithURL:urlString placeholderImage:placeholder path:path completion:nil];
}

- (void)zb_setImageWithURL:(NSString *)urlString completion:(downloadCompletion)completion{
    [self zb_setImageWithURL:urlString placeholderImage:nil completion:completion];
}

- (void)zb_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder completion:(downloadCompletion)completion{
    [self zb_setImageWithURL:urlString placeholderImage:placeholder path:[[ZBImageDownloader sharedInstance]imageFilePath] completion:completion];
}

- (void)zb_setImageWithURL:(NSString *)urlString placeholderImage:(UIImage *)placeholder path:(NSString *)path completion:(downloadCompletion)completion{
    if(placeholder){
        self.image=placeholder;
    }
    __weak __typeof(self)wself = self;
    [[ZBImageDownloader sharedInstance]downloadImageUrl:urlString path:path completion:^(UIImage *image){
        if (image) {
            wself.image=image;
            [wself setNeedsLayout];
        }else{
            wself.image=placeholder;
            [wself setNeedsLayout];
        }
        if (completion) {
            completion(image);
        }
    }];

}

@end
