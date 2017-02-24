//
//  ChannelTableViewCell.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "ChannelTableViewCell.h"
#import <SDAutoLayout.h>
#import "Constants.h"
#import "GlobalSettingsTool.h"
#import <UIImageView+WebCache.h>
#import "ZBKit.h"
@interface ChannelTableViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UIImageView *ImageView1;
@end
@implementation ChannelTableViewCell
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
    
    self.ImageView1 = [[UIImageView alloc]init];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor=[UIColor redColor];
    self.titleLabel.numberOfLines=0;
    self.titleLabel.font=[UIFont systemFontOfSize:14];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font=[UIFont systemFontOfSize:10];

  
   [self getNightPattern];
    
}
- (void)setttingViewAtuoLayout{
    [self.contentView sd_addSubviews:@[self.ImageView1,self.titleLabel,self.descLabel]];
  
    self.ImageView1.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).heightIs(50).widthIs(90);
    
    self.titleLabel.sd_layout.leftSpaceToView(self.ImageView1,10).topSpaceToView(self.contentView,10).heightIs(40).rightSpaceToView(self.contentView,10);
    
    self.descLabel.sd_layout.leftSpaceToView(self.ImageView1,10).topSpaceToView(self.contentView,45).heightIs(20).rightSpaceToView(self.contentView,10);

    // [self setupAutoHeightWithBottomView:self.titleLabel bottomMargin:10];
}

- (void)setChannelModel:(ChannelModel *)channelModel{
    if (channelModel!=nil) {
        _channelModel=channelModel;
        if ([_channelModel.icon isKindOfClass:[NSString class]]){
            
            if ([GlobalSettingsTool downloadImagePattern]==YES) {
                NSInteger netStatus=[ZBNetworkManager startNetWorkMonitoring];
                
                if (netStatus==AFNetworkReachabilityStatusReachableViaWiFi) {
                    
                    [self.ImageView1 sd_setImageWithURL:[NSURL URLWithString:_channelModel.icon] placeholderImage:[UIImage imageNamed:@"back"]];
                }else{
                    [self.ImageView1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:    [UIImage imageNamed:@"back"]];
                }
                
            }else{
                [self.ImageView1 sd_setImageWithURL:[NSURL URLWithString:_channelModel.icon] placeholderImage:[UIImage imageNamed:@"back"]];
            }
        }
        self.titleLabel.text=_channelModel.title;
        NSString *hitsStr=[NSString stringWithFormat:@"%@次浏览",_channelModel.hits];
        self.descLabel.text=hitsStr;

    }else{
        NEWSLog(@"无数据");
    }
}
- (void)getNightPattern{
    if ([GlobalSettingsTool getNightPattern]==YES) {
        self.backgroundColor=[UIColor colorWithRed:0.11 green:0.12 blue:0.13 alpha:1.00];
        self.titleLabel.textColor=[UIColor whiteColor];
        self.descLabel.textColor=[UIColor whiteColor];

        
    }else{
        self.backgroundColor=[UIColor whiteColor];
        self.titleLabel.textColor=[UIColor blackColor];
        self.descLabel.textColor=[UIColor blackColor];

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
