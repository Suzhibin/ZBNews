//
//  RACChannelFirstCell.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "RACChannelFirstCell.h"
#import "RACChannelModel.h"
@interface RACChannelFirstCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIImageView *iconImage1;
@property (strong, nonatomic) UIImageView *iconImage2;
@property (strong, nonatomic) UIImageView *iconImage3;
@end
@implementation RACChannelFirstCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        [self createUI];
        [self settingViewAtuoLayout];
        
    }
    return self;
}

- (void)setChannelModel:(RACChannelModel *)channelModel{
    [super setChannelModel:channelModel];
    self.titleLabel.text=channelModel.title;
    NSString *hitsStr=[NSString stringWithFormat:@"%@次浏览",channelModel.hits];
    self.descLabel.text=hitsStr;
    [self.iconImage1 sd_setImageWithURL:[NSURL URLWithString:[channelModel.icon objectForKey:@"icon_small1"]] placeholderImage:[UIImage imageNamed:@"back"]];
    [self.iconImage2 sd_setImageWithURL:[NSURL URLWithString:[channelModel.icon objectForKey:@"icon_small2"]] placeholderImage:[UIImage imageNamed:@"back"]];
    [self.iconImage3 sd_setImageWithURL:[NSURL URLWithString:[channelModel.icon objectForKey:@"icon_small3"]] placeholderImage:[UIImage imageNamed:@"back"]];
    
}
- (void)createUI{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font=[UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:descLabel];
    self.descLabel=descLabel;
    
    UIImageView *iconImage1=[[UIImageView alloc]init];
    [self.contentView addSubview:iconImage1];
    self.iconImage1=iconImage1;
    
    UIImageView *iconImage2=[[UIImageView alloc]init];
    [self.contentView addSubview:iconImage2];
    self.iconImage2=iconImage2;
    
    UIImageView *iconImage3=[[UIImageView alloc]init];
    [self.contentView addSubview:iconImage3];
    self.iconImage3=iconImage3;
    
}
- (void)settingViewAtuoLayout{
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(@(5));
        make.height.offset(20);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.offset(20);
    }];
    [self.iconImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(30));
        make.top.equalTo(self.descLabel.mas_bottom).offset(5);
        make.width.offset(84);
        make.height.offset(64);
    }];
    [self.iconImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage1.mas_right).offset(10);;
        make.top.equalTo(self.descLabel.mas_bottom).offset(5);
        make.width.offset(84);
        make.height.offset(64);
    }];
    [self.iconImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage2.mas_right).offset(10);;
        make.top.equalTo(self.descLabel.mas_bottom).offset(5);
        make.width.offset(84);
        make.height.offset(64);
    }];
    
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
