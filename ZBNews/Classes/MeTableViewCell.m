//
//  MeTableViewCell.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "MeTableViewCell.h"
#import <SDAutoLayout.h>
#import "Constants.h"
#import "GlobalSettingsTool.h"
@implementation MeTableViewCell
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
    [self meCellgetNightPattern];
}
- (void)createUI{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.textAlignment=NSTextAlignmentRight;
     [self meCellgetNightPattern];
}
- (void)setttingViewAtuoLayout{
    [self.contentView sd_addSubviews:@[self.titleLabel,self.descLabel]];
    
    self.titleLabel.sd_layout.leftSpaceToView(self.contentView,10).topSpaceToView(self.contentView,10).heightIs(20).widthIs(180);
    
    self.descLabel.sd_layout.topSpaceToView(self.contentView,10).heightIs(20).rightSpaceToView(self.contentView,20).widthIs(100);
}
- (void)meCellgetNightPattern{
    if ([GlobalSettingsTool getNightPattern]==YES) {
        self.backgroundColor=[UIColor colorWithRed:0.07 green:0.11 blue:0.07 alpha:1.00];
        self.titleLabel.textColor=[UIColor whiteColor];
        self.descLabel.textColor=[UIColor whiteColor];
    }else{
        self.backgroundColor=[UIColor whiteColor];
        self.titleLabel.textColor=[UIColor blackColor];
        self.descLabel.textColor=[UIColor blackColor];
    }
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
