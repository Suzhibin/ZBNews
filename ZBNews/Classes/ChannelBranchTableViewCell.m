//
//  ChannelBranchTableViewCell.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "ChannelBranchTableViewCell.h"
#import <SDAutoLayout.h>
#import "Constants.h"
#import "GlobalSettingsTool.h"
#import <UIImageView+WebCache.h>
#import "ZBNetworking.h"
@interface ChannelBranchTableViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UILabel *pubDate;//时间
@property (strong, nonatomic) UIImageView *ImageViewUrl;
@end
@implementation ChannelBranchTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editchangeNightView) name:NIGHT object:nil];//夜间模式通知
        [self createUI];
        [self setttingViewAtuoLayout];
    }
    return self;
}

- (void)editchangeNightView{
    [self getNightPattern];
}

- (void)createUI{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font=[UIFont systemFontOfSize:14];
    self.titleLabel.textColor=[UIColor redColor];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font=[UIFont systemFontOfSize:10];
    self.descLabel.numberOfLines=0;
    
    self.pubDate = [[UILabel alloc] init];
    self.pubDate.font=[UIFont systemFontOfSize:8];
    
    self.ImageViewUrl = [[UIImageView alloc] init];
    self.ImageViewUrl.contentMode = UIViewContentModeScaleAspectFit;
    [self getNightPattern];
    
}
- (void)setttingViewAtuoLayout{
    [self.contentView sd_addSubviews:@[self.titleLabel,self.ImageViewUrl,self.descLabel,self.pubDate]];
    
    self.ImageViewUrl.sd_layout.widthIs(80).heightIs(60).leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,10);
    
    self.titleLabel.sd_layout.leftSpaceToView(self.ImageViewUrl,10).topSpaceToView(self.contentView,10).heightIs(20).rightSpaceToView(self.contentView,40);
    
    self.descLabel.sd_layout.leftSpaceToView(self.ImageViewUrl,10).topSpaceToView(self.contentView,30).heightIs(30).rightSpaceToView(self.contentView,40);
    
    self.pubDate.sd_layout.leftSpaceToView(self.ImageViewUrl,10).topSpaceToView(self.contentView,60).heightIs(10).widthIs(120);
    
       // [self setupAutoHeightWithBottomView:self.titleLabel bottomMargin:10];
}

- (void)setChannelModel:(ChannelModel *)channelModel{
    if (channelModel!=nil) {
        _channelModel=channelModel;
        if ([GlobalSettingsTool downloadImagePattern]==YES) {
            
            NSInteger netStatus=[ZBNetworkManager startNetWorkMonitoring];
            if (netStatus==AFNetworkReachabilityStatusReachableViaWiFi) {
                 [self.ImageViewUrl sd_setImageWithURL:[NSURL URLWithString:_channelModel.url] placeholderImage:[UIImage imageNamed:@"back"]];
            }else{
                 [self.ImageViewUrl sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"back"]];
            }
        }else{
            [self.ImageViewUrl sd_setImageWithURL:[NSURL URLWithString:_channelModel.url] placeholderImage:[UIImage imageNamed:@"back"]];
        }
        
        self.titleLabel.text=_channelModel.title;
        self.descLabel.text=_channelModel.desc;
        self.pubDate.text=_channelModel.pubDate;
    }else{
        NEWSLog(@"无数据");
    }
}
- (void)getNightPattern{
    if ([GlobalSettingsTool getNightPattern]==YES) {
        self.backgroundColor=[UIColor colorWithRed:0.11 green:0.12 blue:0.13 alpha:1.00];
        self.titleLabel.textColor=[UIColor whiteColor];
        self.descLabel.textColor=[UIColor whiteColor];
        self.pubDate.textColor=[UIColor whiteColor];
        
    }else{
        self.backgroundColor=[UIColor whiteColor];
        self.titleLabel.textColor=[UIColor blackColor];
        self.descLabel.textColor=[UIColor blackColor];
        self.pubDate.textColor=[UIColor blackColor];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NIGHT object:nil];
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
