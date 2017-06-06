//
//  DetailViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "DetailViewController.h"
#import "MyControlTool.h"
#import <WebKit/WebKit.h>
#import "ZBDataBaseManager.h"
#import "CommentsViewController.h"
NSString *const collection =@"collection";
NSString *const calendar =@"calendar";
@interface DetailViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>
//,
/** 浏览器 */
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,strong )UIView *toobarView;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation DetailViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     //   self.hidesBottomBarWhenPushed=YES;//隐藏tabbar
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];

    [[MyControlTool sharedManager] loading:self.view];

    [[ZBDataBaseManager sharedInstance]createTable:collection];
    
  
    //储存的model 对象必须准守Codeing协议
    NEWSLog(@"阅读时间：%@",[self getDate]);
    NSString *TableName=[NSString stringWithFormat:@"%@%@",calendar,[self getDate]];
    [[ZBDataBaseManager sharedInstance]createTable:TableName];
    NSLog(@"表名：%@",TableName);
    if ([[ZBDataBaseManager sharedInstance] isCollectedWithTable:TableName itemId:self.model.newslId]) {
        NEWSLog(@"已阅读");
    }else{
        [[ZBDataBaseManager sharedInstance] table:TableName insertDataWithObj:self.model ItemId:self.model.newslId];
    }


    //创建一个WKWebView的配置对象
    [self createWebView];
    [self createToobar];
   

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
- (void)createToobar
{
    self.toobarView =[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    self.toobarView.backgroundColor=[UIColor whiteColor];
    self.toobarView.hidden=YES;
    
    [self.view addSubview:self.toobarView];
    
    NSArray *titleArr=[NSArray arrayWithObjects:@"评论",@"收藏",@"转发", nil];
    for (int i=0; i<titleArr.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(50+i*85, 5, 50, 34);
        [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        // [btn setImage:[UIImage imageNamed:[imagesArr objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag=i+100;
        
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i==1) {
            //看该条数据是否被收藏过
            
            if ([[ZBDataBaseManager sharedInstance] isCollectedWithTable:collection itemId:self.model.newslId]) {
                
                btn.selected=YES;
                //  [btn setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
                btn.titleLabel.alpha = 0.5;
            }
            
            
        }
        
        [self.toobarView addSubview:btn];
    }

}
- (void)btnClicked:(UIButton *)btn
{
    
    CommentsViewController *commentVC=[[CommentsViewController alloc]init];
    switch (btn.tag) {
        case 100:
            [self.navigationController pushViewController:commentVC animated:YES];
            
            break;
        case 101:
            if (btn.selected==NO) {
                btn.selected = YES;
                NSLog(@"收藏文章:%@",_model.title);
                 NSLog(@"nid:%@",_model.newslId);
                //收藏数据
                //储存的model 对象必须准守Codeing协议  
                [[ZBDataBaseManager sharedInstance]table:collection insertDataWithObj:self.model ItemId:self.model.newslId];
    
                //  btn.enabled = NO;
                // [btn setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
                //为了区分按钮的状态
                btn.titleLabel.alpha = 0.5;
            }else{
                btn.selected =NO;
                NSLog(@"删除文章:%@",_model.title);
                //删除数据
                [[ZBDataBaseManager sharedInstance]table:collection deleteDataWithItemId:self.model.newslId];
                //btn.enabled = YES;
                //  [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                //为了区分按钮的状态
                btn.titleLabel.alpha = 1;
                
            }

            break;
        case 102:
            
            break;
        default:
            break;
    }
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
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    [userContentController addScriptMessageHandler:self name:@"openBigPicture"];
    [userContentController addScriptMessageHandler:self name:@"openVideoPlayer"];
    [userContentController addScriptMessageHandler:self name:@"NativeMethod"];
    // 将UserConttentController设置到配置文件
    configur.userContentController = userContentController;
    
    // 高端的自定义配置创建WKWebView
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) configuration:configur];
     self.wkWebView.UIDelegate = self;
     self.wkWebView.navigationDelegate = self;
    self.wkWebView.backgroundColor=[UIColor whiteColor];
   // if (!self.model.link) {
     //   self.model.link = @"https://github.com/Suzhibin/ZBNews";
   // }
    
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:Datail_URL,self.model.newslId]]]];
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
    [self.view insertSubview:[[MyControlTool sharedManager]loadingLabel] aboveSubview:self.wkWebView];
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.wkWebView  addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    //[self.wkWebView loadHTMLString:self.urlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
    
    /*
     // JS发送POST的Flag，为真的时候会调用JS的POST方法（仅当第一次的时候加载本地JS）
     self.needLoadJSPOST = YES;
     // 创建WKWebView
     self.webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
     //设置代理
     self.webView.navigationDelegate = self;
     // 获取JS所在的路径
     NSString *path = [[NSBundle mainBundle] pathForResource:@"JSPOST" ofType:@"html"];
     // 获得html内容
     NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
     // 加载js
     [self.webView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
     // 将WKWebView添加到当前View
     [self.view addSubview:self.webView];
     */

}
#pragma mark - WKNavigationDelegate
// 类似UIWebView的 -webViewDidStartLoad:页面开始加载时调用
- (void)webView:(WKWebView*)webView didStartProvisionalNavigation:(WKNavigation*)navigation {
    
    NEWSLog(@"didStartProvisionalNavigation");
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;

}
   //当内容开始返回时调用
- (void)webView:(WKWebView*)webView didCommitNavigation:(WKNavigation*)navigation {
    NEWSLog(@"didCommitNavigation");
    [[MyControlTool sharedManager] removeloadingLabel];
    self.toobarView.hidden=NO;
}
//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSString *executeString = @"$(document).ready(function(){$('.guanliansearch').removeClass(\"hide\").addClass(\"show\") });";
    
    [self.wkWebView evaluateJavaScript:executeString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
    }];
     [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    NEWSLog(@"加载成功");
 
}
 // 类似 UIWebView 的- webView:didFailLoadWithError:页面加载失败时调用
- (void)webView:(WKWebView*)webView didFailProvisionalNavigation:(WKNavigation*)navigation withError:(NSError*)error{
 
    NSLog(@"didFailProvisionalNavigation");
    [[MyControlTool sharedManager] removeloadingLabel];
}

#pragma mark - WKScriptMessageHandler
/*
 1、js调用原生的方法就会走这个方法
 2、message参数里面有2个参数我们比较有用，name和body，
 2.1 :其中name就是之前已经通过addScriptMessageHandler:name:方法注入的js名称
 2.2 :其中body就是我们传递的参数了，我在js端传入的是一个字典，所以取出来也是字典，字典里面包含原生方法名以及被点击图片的url
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // 判断是否是调用原生的
    if ([@"openBigPicture" isEqualToString:message.name]) {
        NEWSLog(@"openBigPicture");
    }
    if ([@"openVideoPlayer" isEqualToString:message.name]) {
        NEWSLog(@"openVideoPlayer");
    }
    if ([@"NativeMethod" isEqualToString:message.name]) {
         NEWSLog(@"NativeMethod");
    }
     NSDictionary *imageDict = message.body;
    NEWSLog(@"imageDict%@",imageDict);
    /*
   
    NSString *src = [NSString string];
    if (imageDict[@"imageSrc"]) {
        src = imageDict[@"imageSrc"];
    }else{
        src = imageDict[@"videoSrc"];
    }
    NSString *name = imageDict[@"methodName"];
    */
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
    }else if ([keyPath isEqualToString:@"title"]){
        if (object == self.wkWebView) {
            self.title = self.wkWebView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - WKUIDelegate
/**
 *  web界面中有弹出警告框时调用
 *
 *  @param webView           实现该代理的webview
 *  @param message           警告框中的内容
 *  @param frame             主窗口
 *  @param completionHandler 警告框消失调用
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    NEWSLog(@"webView.URL---%@",webView.URL);
    
    UIAlertController *alertController1 = [UIAlertController alertControllerWithTitle:message message: nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
        
    }];
    
    [alertController1 addAction:noAction];
    
    [self presentViewController:alertController1 animated:YES completion:^{
        
    }];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message: nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(WKNavigationResponsePolicyCancel);
        
    }];
    
    [alertController addAction:cancelAction];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(WKNavigationResponsePolicyAllow);
        
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
    
}


- (void)dealloc
{
    self.wkWebView.UIDelegate=nil;
    self.wkWebView.navigationDelegate=nil;
    self.wkWebView=nil;
    
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"openVideoPlayer"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"openBigPicture"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"NativeMethod"];
    
}
- (UIProgressView*)progressView
{
    if (_progressView == nil) {
        _progressView= [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 5);
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
