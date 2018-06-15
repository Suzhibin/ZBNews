//
//  DelegateChannelFirstCell.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "DelegateChannelFirstCell.h"
#import "RACChannelModel.h"
@implementation DelegateChannelFirstCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

        [self createUI];
      //  self.contentView.backgroundColor=[UIColor yellowColor];
    }
    return self;
}
- (void)setChannelModel:(RACChannelModel *)channelModel{
    [super setChannelModel:channelModel];
    self.titleLabel.text=channelModel.title;
}
- (void)createUI{
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.numberOfLines=0;
    titleLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    UIEdgeInsets padding = UIEdgeInsetsMake(0,0,0,0);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(padding);
    }];
}
@end
