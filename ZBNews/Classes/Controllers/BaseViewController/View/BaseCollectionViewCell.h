//
//  BaseCollectionViewCell.h
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "CommonDefine.h"
#import "UIImageView+WebCache.h"
#import "ZBKit.h"
@class RACChannelModel;
@interface BaseCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)RACChannelModel *channelModel;
@end
