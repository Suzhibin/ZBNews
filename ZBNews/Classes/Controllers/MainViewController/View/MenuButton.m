//
//  MenuButton.m
//  ZBNews
//
//  Created by Suzhibin on 2019/6/28.
//  Copyright © 2019 Suzhibin. All rights reserved.
//

#import "MenuButton.h"

@interface MenuButton()
@property (nonatomic, strong) UIView *verticalLineView;
@end
@implementation MenuButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    
        _verticalLineHidden = NO;
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.translatesAutoresizingMaskIntoConstraints = NO;
        _verticalLineView.backgroundColor = [UIColor redColor];
        _verticalLineView.hidden = _verticalLineHidden;
        [self addSubview:_verticalLineView];
       [self setNeedsUpdateConstraints];
    }
    return self;
}
- (void)updateConstraints {
    _verticalLineView.frame=CGRectMake(self.frame.size.width-1, 22, 1, 20);

    [super updateConstraints];
}
- (void)setVerticalLineHidden:(BOOL)verticalLineHidden{
    _verticalLineHidden=verticalLineHidden;
    _verticalLineView.hidden=verticalLineHidden;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
