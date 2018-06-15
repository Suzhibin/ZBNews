//
//  BaseTableViewCell.m
//  ZBNews
//
//  Created by NQ UEC on 2017/9/12.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)setChannelModel:(RACChannelModel *)channelModel{
    _channelModel=channelModel;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
