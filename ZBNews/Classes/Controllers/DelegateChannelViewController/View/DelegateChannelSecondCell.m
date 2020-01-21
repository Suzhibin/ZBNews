//
//  DelegateChannelSecondCell.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "DelegateChannelSecondCell.h"
#import "RACChannelModel.h"
@implementation DelegateChannelSecondCell
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
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:channelModel.icon] placeholderImage:[UIImage imageNamed:@"back"]];
}
- (void)createUI{
    
    UIImageView *iconImage=[[UIImageView alloc]init];
    [self.contentView addSubview:iconImage];
    self.iconImage=iconImage;
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(5));
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.height.offset(60);
    }];
    UILabel *titleLabel=[[UILabel alloc]init];
    titleLabel.numberOfLines=0;
    titleLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    self.titleLabel=titleLabel;
  
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImage.mas_bottom).offset(5);
        make.left.equalTo(@(0));
        make.right.equalTo(@(0));
        make.height.offset(35);
    }];
  
}
@end
