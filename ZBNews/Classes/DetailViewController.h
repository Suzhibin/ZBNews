//
//  DetailViewController.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "BaseViewController.h"
#import "ChannelModel.h"

@interface DetailViewController : BaseViewController
@property (nonatomic,strong)ChannelModel *model;
@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,copy)NSString *html;
@end
