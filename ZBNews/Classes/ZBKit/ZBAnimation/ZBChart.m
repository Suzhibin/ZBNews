//
//  ZBChart.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/7.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBChart.h"
#define k_COLOR_STOCK @[[UIColor colorWithRed:1.000 green:0.783 blue:0.371 alpha:1.000], [UIColor colorWithRed:1.000 green:0.562 blue:0.968 alpha:1.000],[UIColor colorWithRed:0.313 green:1.000 blue:0.983 alpha:1.000],[UIColor colorWithRed:0.560 green:1.000 blue:0.276 alpha:1.000],[UIColor colorWithRed:0.239 green:0.651 blue:0.170 alpha:1.000]]

@interface ZBChart ()

//环图间隔 单位为π
@property (nonatomic,assign)CGFloat itemsSpace;

//数值和
@property (nonatomic,assign) CGFloat totolCount;

@property (nonatomic,assign) CGFloat redius;

@end

@implementation ZBChart
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _xDescTextFontSize = _yDescTextFontSize = 8.0;
        self.xAndYLineColor = [UIColor darkGrayColor];
        self.contentInsets = UIEdgeInsetsMake(10, 20, 10, 10);
        self.chartOrigin = P_M(self.contentInsets.left, CGRectGetHeight(self.frame) - self.contentInsets.bottom);
        
        self.chartOrigin = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2);
        _redius = (CGRectGetHeight(self.frame) -60*k_Width_Scale)/4;
        _ringWidth = 40;
    }
    return self;
}
-(void)setValueDataArr:(NSArray *)valueDataArr{
    _valueDataArr = valueDataArr;
    [self configBaseData];
}

- (void)configBaseData{
    
    _totolCount = 0;
    _itemsSpace =  (M_PI * 2.0 * 10 / 360)/_valueDataArr.count ;
    for (id obj in _valueDataArr) {
        
        _totolCount += [obj floatValue];
    }
}
//开始动画
- (void)showAnimation{
    
    /*        动画开始前，应当移除之前的layer         */
    for (CALayer *layer in self.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    
    CGFloat lastBegin = -M_PI/2;
    
    CGFloat totloL = 0;
    NSInteger  i = 0;
    for (id obj in _valueDataArr) {
        
        CAShapeLayer *layer = [CAShapeLayer layer] ;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        layer.fillColor = [UIColor clearColor].CGColor;
        
        if (i<_fillColorArray.count) {
            layer.strokeColor =[_fillColorArray[i] CGColor];
        }else{
            layer.strokeColor =[k_COLOR_STOCK[i%k_COLOR_STOCK.count] CGColor];
        }
        CGFloat cuttentpace = [obj floatValue] / _totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);
        totloL += [obj floatValue] / _totolCount;
        
        [path addArcWithCenter:self.chartOrigin radius:_redius startAngle:lastBegin  endAngle:lastBegin  + cuttentpace clockwise:YES];
        
        layer.path = path.CGPath;
        [self.layer addSublayer:layer];
        layer.lineWidth = _ringWidth;
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        basic.fromValue = @(0);
        basic.toValue = @(1);
        basic.duration = 0.5;
        basic.fillMode = kCAFillModeForwards;
        
        [layer addAnimation:basic forKey:@"basic"];
        lastBegin += (cuttentpace+_itemsSpace);
        i++;
    }
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    CGFloat lastBegin = 0;
    CGFloat longLen = _redius +30*k_Width_Scale;
    for (NSInteger i = 0; i<_valueDataArr.count; i++) {
        id obj = _valueDataArr[i];
        CGFloat currentSpace = [obj floatValue] / _totolCount * (M_PI * 2 - _itemsSpace * _valueDataArr.count);;
        //NSLog(@"%f",currentSpace);
        CGFloat midSpace = lastBegin + currentSpace / 2;
        
        CGPoint begin = CGPointMake(self.chartOrigin.x + sin(midSpace) * _redius, self.chartOrigin.y - cos(midSpace)*_redius);
        CGPoint endx = CGPointMake(self.chartOrigin.x + sin(midSpace) * longLen, self.chartOrigin.y - cos(midSpace)*longLen);
        
        //NSLog(@"%@%@",NSStringFromCGPoint(begin),NSStringFromCGPoint(endx));
        lastBegin += _itemsSpace + currentSpace;
        
        UIColor *color;
        
        if (_fillColorArray.count<_valueDataArr.count) {
            color = k_COLOR_STOCK[i%k_COLOR_STOCK.count];
        }else{
            color = _fillColorArray[i];
        }
        
        [self drawLineWithContext:contex andStarPoint:begin andEndPoint:endx andIsDottedLine:NO andColor:color];
        
        
        CGPoint secondP = CGPointZero;
        
        CGSize size = [[NSString stringWithFormat:@"%.02f%c",[obj floatValue] / _totolCount * 100,'%'] boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10*k_Width_Scale]} context:nil].size;
        
        if (midSpace<M_PI) {
            secondP =CGPointMake(endx.x + 20*k_Width_Scale, endx.y);
            [self drawText:[NSString stringWithFormat:@"%.02f%c",[obj floatValue] / _totolCount * 100,'%'] andContext:contex atPoint:CGPointMake(secondP.x + 3, secondP.y - size.height / 2) WithColor:color andFontSize:10*k_Width_Scale];
            
        }else{
            secondP =CGPointMake(endx.x - 20*k_Width_Scale, endx.y);
            [self drawText:[NSString stringWithFormat:@"%.02f%c",[obj floatValue] / _totolCount * 100,'%'] andContext:contex atPoint:CGPointMake(secondP.x - size.width - 3, secondP.y - size.height/2) WithColor:color andFontSize:10*k_Width_Scale];
        }
        [self drawLineWithContext:contex andStarPoint:endx andEndPoint:secondP andIsDottedLine:NO andColor:color];
        [self drawPointWithRedius:3*k_Width_Scale andColor:color andPoint:secondP andContext:contex];
    }
}

/**
 *  绘制线段
 *
 *  @param context  图形绘制上下文
 *  @param start    起点
 *  @param end      终点
 *  @param isDotted 是否是虚线
 *  @param color    线段颜色
 */
- (void)drawLineWithContext:(CGContextRef )context andStarPoint:(CGPoint )start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color{

    //    移动到点
    CGContextMoveToPoint(context, start.x, start.y);
    //    连接到
    CGContextAddLineToPoint(context, end.x, end.y);
    
    CGContextSetLineWidth(context, 0.3);
    
    [color setStroke];
    
    if (isDotted) {
        CGFloat ss[] = {1.5,2};
        
        CGContextSetLineDash(context, 0, ss, 2);
    }
    CGContextMoveToPoint(context, end.x, end.y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

/**
 *  绘制文字
 *
 *  @param text    文字内容
 *  @param context 图形绘制上下文
 *  @param rect    绘制点
 *  @param color   绘制颜色
 */
- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize{
    
    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:color}];
    
    [color setFill];
    
    CGContextDrawPath(context, kCGPathFill);
}

- (void)drawText:(NSString *)text context:(CGContextRef )context atPoint:(CGRect )rect WithColor:(UIColor *)color font:(UIFont*)font{
    //    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [[NSString stringWithFormat:@"%@",text] drawInRect:rect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
}
/**
 *  判断文本宽度
 *
 *  @param text 文本内容
 *
 *  @return 文本宽度
 */
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text{
    
    CGSize size = [[NSString stringWithFormat:@"%@",text] boundingRectWithSize:CGSizeMake(100, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7]} context:nil].size;
    
    return size.width;
}

/**
 *  绘制长方形
 *
 *  @param color  填充颜色
 *  @param p      开始点
 *  @param contex 图形上下文
 */
- (void)drawQuartWithColor:(UIColor *)color andBeginPoint:(CGPoint)p andContext:(CGContextRef)contex{
    
    CGContextAddRect(contex, CGRectMake(p.x, p.y, 10, 10));
    [color setFill];
    [color setStroke];
    CGContextDrawPath(contex, kCGPathFillStroke);
}

- (void)drawPointWithRedius:(CGFloat)redius andColor:(UIColor *)color andPoint:(CGPoint)p andContext:(CGContextRef)contex{
    
    CGContextAddArc(contex, p.x, p.y, redius, 0, M_PI * 2, YES);
    [color setFill];
    CGContextDrawPath(contex, kCGPathFill);
}
/**
 *  返回字符串的占用尺寸
 *
 *  @param maxSize   最大尺寸
 *  @param fontSize  字号大小
 *  @param aimString 目标字符串
 *
 *  @return 占用尺寸
 */
- (CGSize)sizeOfStringWithMaxSize:(CGSize)maxSize textFont:(CGFloat)fontSize aimString:(NSString *)aimString{
    
    return [[NSString stringWithFormat:@"%@",aimString] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
