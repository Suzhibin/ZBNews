//
//  ZBControlTool.m
//  ZBKit
//
//  Created by NQ UEC on 17/2/6.
//  Copyright © 2017年 Suzhibin. All rights reserved.
//

#import "ZBControlTool.h"

#import "AppDelegate.h"

@implementation ZBControlTool


+ (BOOL)checkIsChinese:(NSString *)string{
    for (int i=0; i<string.length; i++)
    {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5)
        {
            return YES;
        }
    }
    return NO;
}

+ (NSMutableAttributedString *)AttributedString:(NSString *)string range:(NSUInteger)range lengthString:(NSString *)lengthString{
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:string];
    
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:20.0]
                          range:NSMakeRange(range, [lengthString length])];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor redColor]
                          range:NSMakeRange(range, [lengthString length])];
    return  AttributedStr;
}


+  (NSString * )str:(NSString *)string{

    NSString *str = string;
    // 去掉所有的空格
    NSString *replaceStr = [str stringByReplacingOccurrencesOfString:@" " withString:@""];

    return replaceStr;
}

+ (NSString*)reverseWordsInString:(NSString*)string{
    NSMutableString *reverString = [NSMutableString stringWithCapacity:string.length];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}

+ (NSString *)phoneticizeChinese:(NSString *)string{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [string mutableCopy];

    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //返回最近结果
    return pinyin;
}

+(NSString *)translation:(NSString *)arebic{
    NSString *str = arebic;
    NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
    
    NSMutableArray *sums = [NSMutableArray array];
    for (int i = 0; i < str.length; i ++) {
        NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
        NSString *a = [dictionary objectForKey:substr];
        NSString *b = digits[str.length -i-1];
        NSString *sum = [a stringByAppendingString:b];
        if ([a isEqualToString:chinese_numerals[9]])
        {
            if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
            {
                sum = b;
                if ([[sums lastObject] isEqualToString:chinese_numerals[9]])
                {
                    [sums removeLastObject];
                }
            }else
            {
                sum = chinese_numerals[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum])
            {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *sumStr = [sums componentsJoinedByString:@""];
    NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
    //NSLog(@"str%@",str);
    //NSLog(@"chinese%@",chinese);
    return chinese;
}

+ (void)timerDisabled{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

+ (void)setStatusBarBackgroundColor:(UIColor *)color{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    {
        statusBar.backgroundColor = color;
    }
}

//============================================================
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    button.tag=tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text tag:(NSInteger)tag{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.tag=tag;
    label.textAlignment=NSTextAlignmentLeft;
    return label;
}

// imageName 是一个完整路径
+ (UIImageView *)createImageViewWithFrame:(CGRect)frame imageString:(NSString *)imageString{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageString];
    return imageView;
}

+ (UITextField *)createTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder borderStyle:(UITextBorderStyle)borderStyle delegate:(id<UITextFieldDelegate>)delegate{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = borderStyle;
    textField.placeholder = placeHolder;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.delegate = delegate;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.clearsOnBeginEditing = YES;
    return textField;
}


@end
