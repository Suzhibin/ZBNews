//
//  DetailViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "DetailViewController.h"
#import <WebKit/WebKit.h>
#import "ZBKit.h"
#import "APPTool.h"
@interface DetailViewController ()<WKNavigationDelegate,WKUIDelegate>
//,
/** 浏览器 */
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong)UIActivityIndicatorView *activity;
@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.delegateSubject) {
        [self.delegateSubject sendNext:@"我是信号"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
   [[ZBDataBaseManager sharedInstance]createTable:Sfavorites];//创建收藏夹的表

    SLog(@"阅读时间：%@",[self getDate]);
    NSString *TableName=[NSString stringWithFormat:@"%@%@",Scalendar,[self getDate]];
   [[ZBDataBaseManager sharedInstance]createTable:TableName];//创建阅读日历的表
    SLog(@"表名：%@",TableName);
 
    BOOL isExist=[[ZBDataBaseManager sharedInstance]isExistsWithItemId:self.model.newsId table:TableName];
    if (isExist) {
          SLog(@"已阅读");
    }else{
        NSDictionary *dict=[APPTool getObjectData:self.model];
       //  SLog(@"转成字典:%@",dict);
        SLog(@"newslId:%@",self.model.newsId);
        [[ZBDataBaseManager sharedInstance]table:TableName insertObj:dict ItemId:self.model.newsId isSuccess:^(BOOL isSuccess) {
            if (isSuccess) {
                SLog(@"阅读添加成功");
            }else{
                SLog(@"阅读添加失败");
            }
        }];
    }

    //创建一个WKWebView的配置对象
    [self createWebView];

    self.activity = [[UIActivityIndicatorView alloc] init];
    self.activity.center=self.view.center;
    [self.view addSubview:self.activity];
    self.activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    [self.activity startAnimating];
    
    UIButton * favoritesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoritesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favoritesButton setTitle:@"收藏" forState:UIControlStateNormal];
    if (  [[ZBDataBaseManager sharedInstance]isExistsWithItemId:self.model.newsId table:Sfavorites]){
        favoritesButton.selected=YES;
        //  [btn setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
        favoritesButton.titleLabel.alpha = 0.5;
    }
    @weakify(self);
    [[favoritesButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (x.selected==NO) {
            x.selected = YES;
            //收藏数据
            NSLog(@"收藏数据");
            NSDictionary *dict=[APPTool getObjectData:self.model];
            SLog(@"转成字典:%@",dict);
            [[ZBDataBaseManager sharedInstance]table:Sfavorites insertObj:dict ItemId:self.model.newsId isSuccess:^(BOOL isSuccess) {
                if (isSuccess) {
                    SLog(@"收藏添加成功");
                }else{
                    SLog(@"收藏添加失败");
                }
            }];
            //为了区分按钮的状态
            favoritesButton.titleLabel.alpha = 0.5;
        }else{
            x.selected =NO;
            [[ZBDataBaseManager sharedInstance]table:Sfavorites deleteObjectItemId:self.model.newsId isSuccess:^(BOOL isSuccess) {
                if (isSuccess) {
                    SLog(@"收藏删除数据");
                }else{
                    SLog(@"收藏删除失败");
                }
            }];
            //为了区分按钮的状态
            favoritesButton.titleLabel.alpha = 1;
        }
    }];
    UIBarButtonItem *fItem = [[UIBarButtonItem alloc] initWithCustomView:favoritesButton];
    self.navigationItem.rightBarButtonItems = @[fItem];
}

- (void)createWebView
{
    WKWebViewConfiguration *configur = [[WKWebViewConfiguration alloc] init];
    /*
     //设置configur对象的preferences属性的信息
     WKPreferences *preferences = [[WKPreferences alloc] init];
     configur.preferences = preferences;
     //是否允许与js进行交互，默认是YES的，如果设置为NO，js的代码就不起作用了
     preferences.javaScriptEnabled = YES;
     */
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    // 将UserConttentController设置到配置文件
    configur.userContentController = userContentController;
    
    // 高端的自定义配置创建WKWebView
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, ZB_STATUS_HEIGHT+44, SCREEN_WIDTH, SCREEN_HEIGHT-(ZB_TABBAR_HEIGHT+44)) configuration:configur];
     self.wkWebView.UIDelegate = self;
     self.wkWebView.navigationDelegate = self;

    SLog(@"新闻地址:%@",[NSString stringWithFormat:Datail_URL,self.model.newsId]);

    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:Datail_URL,self.model.newsId]]]];

    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
}
#pragma mark - WKNavigationDelegate
// 类似UIWebView的 -webViewDidStartLoad:页面开始加载时调用
- (void)webView:(WKWebView*)webView didStartProvisionalNavigation:(WKNavigation*)navigation {
    SLog(@"didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}
   //当内容开始返回时调用
- (void)webView:(WKWebView*)webView didCommitNavigation:(WKNavigation*)navigation {
    SLog(@"didCommitNavigation");
//    [self.wkWebView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '330%'" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
//    }];
}
//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.activity.isAnimating) {
        [self.activity stopAnimating];
    }
/*
    [self.wkWebView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.background='black'" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
    //white gray
    [self.wkWebView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
    }];
*/
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    SLog(@"加载成功");
}
 // 类似 UIWebView 的- webView:didFailLoadWithError:页面加载失败时调用
- (void)webView:(WKWebView*)webView didFailProvisionalNavigation:(WKNavigation*)navigation withError:(NSError*)error{
    if (self.activity.isAnimating) {
        [self.activity stopAnimating];
    }
    NSLog(@"didFailProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.wkWebView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
            if(self.wkWebView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (NSString *)getDate{
    NSDate *date = [NSDate date];
    // 时区类
    // 获取系统时区
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"UTC"];
    // 返回我们这个时区和GMT时间相差的秒数
    NSInteger seconds = [zone secondsFromGMTForDate:date];
    
    // 返回一个NSDate的对象，从date时间开始，间隔sconds秒后的时间!
    NSDate *localDate = [NSDate dateWithTimeInterval:seconds sinceDate:date];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *readCalendar= [self.dateFormatter stringFromDate:localDate];
    return readCalendar;
}

- (void)dealloc{
    self.wkWebView.UIDelegate=nil;
    self.wkWebView.navigationDelegate=nil;
    self.wkWebView=nil;
    SLog(@"%s",__func__);
}
- (UIProgressView*)progressView{
    if (_progressView == nil) {
        _progressView= [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.frame = CGRectMake(0, ZB_STATUS_HEIGHT+44, SCREEN_WIDTH, 5);
        _progressView.progressTintColor = [UIColor blueColor];
    }
    
    return _progressView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
