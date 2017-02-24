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
@property (strong, nonatomic) UIImageView *ImageView1;
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
    self.titleLabel.font=[UIFont systemFontOfSize:12];
    self.titleLabel.textColor=[UIColor redColor];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font=[UIFont systemFontOfSize:12];
 
    [self getNightPattern];
}
- (void)setttingViewAtuoLayout{

    [self.contentView sd_addSubviews:@[self.titleLabel,self.descLabel]];
    
    self.titleLabel.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,5).heightIs(20).rightSpaceToView(self.contentView,80);
    
    self.descLabel.sd_layout.leftSpaceToView(self.titleLabel,0).topSpaceToView(self.contentView,5).heightIs(20);
}

- (void)setChannelModel:(ChannelModel *)channelModel{
    if (channelModel!=nil) {
        _channelModel=channelModel;
        
        self.titleLabel.text=_channelModel.title;
        NSString *hitsStr=[NSString stringWithFormat:@"%@次浏览",_channelModel.hits];
        self.descLabel.text=hitsStr;
        
        NSArray *imageArray=[NSArray arrayWithObjects:_channelModel.icon_small1,_channelModel.icon_small2,_channelModel.icon_small3, nil];
        
         CGFloat space1 = (SCREEN_WIDTH-30-40*3)/4.0;
        
        for (NSInteger i=0; i<imageArray.count; i++) {
            
            self.ImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(space1+i%3*(space1+40)-20, 25, 90, 70)];
        
            [self.contentView addSubview: self.ImageView1];
   
             if ([GlobalSettingsTool downloadImagePattern]==YES) {
                 NSInteger netStatus=[ZBNetworkManager startNetWorkMonitoring];
                 
                 if (netStatus==AFNetworkReachabilityStatusReachableViaWiFi) {
                     
                     [self.ImageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"back"]];
                 }else{
                     [self.ImageView1 sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:    [UIImage imageNamed:@"back"]];
                 }
                 
             }else{
                 [self.ImageView1 sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"back"]];
             }
        
        }
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
