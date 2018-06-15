//
//  RACChannelSecondCell.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "RACChannelSecondCell.h"
#import "RACChannelModel.h"
@interface RACChannelSecondCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIImageView *iconImage;
@end
@implementation RACChannelSecondCell
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
    SLog(@"channelModel.icon2222:%@",channelModel.icon);
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:channelModel.icon]placeholderImage:[UIImage imageNamed:@"back"]];
}
- (void)createUI{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font=[UIFont systemFontOfSize:16];
    titleLabel.numberOfLines=0;
    [self.contentView addSubview:titleLabel];
    self.titleLabel=titleLabel;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:descLabel];
    self.descLabel=descLabel;
    
    UIImageView *iconImage=[[UIImageView alloc]init];
    [self.contentView addSubview:iconImage];
    self.iconImage=iconImage;
}
- (void)settingViewAtuoLayout{
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.top.equalTo(@10);
        make.width.offset(84);
        make.height.offset(94);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(@10);
        make.height.offset(60);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-30);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.height.offset(20);
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
