//
//  ChannelViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "ChannelViewController.h"
#import "MainModel.h"
#import  <VTMagic/VTMagic.h>
#import "DataManager.h"
#import <MJRefresh.h>
#import "ChannelTableViewCell.h"
#import "ChannelBranchTableViewCell.h"
#import "ChannelModel.h"
#import <SDAutoLayout.h>
#import "MJChiBaoZiHeader.h"
#import <MJRefresh.h>
#import "CKShimmerLabel.h"
#import "MyControlTool.h"
#import "Masonry.h"
#import "ZBWeatherAnimatedView.h"
#import "DetailViewController.h"
#import "GlobalSettingsTool.h"
#import "MyViewTool.h"
#import "ZBNetworking.h"
#import <UMMobClick/MobClick.h>
@interface ChannelViewController ()<UITableViewDelegate,UITableViewDataSource,ZBURLSessionDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong)UIActivityIndicatorView *aiv;
@property (nonatomic,strong)MyViewTool *myView;

@end
@implementation ChannelViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tabBarController.tabBar.hidden=NO;
    //VTMagic框架 数据 UI 要放到viewDidAppear里
    _page=1;
    [self getData];//加载数据
    self.tableView.mj_footer.hidden = NO;    //显示当前的上拉刷新控件
    self.tableView.scrollsToTop = YES;
    NSInteger pageIndex = [self vtm_pageIndex]; NEWSLog(@"当前页面索引: %ld", (long)pageIndex);
    [MobClick beginLogPageView:_mainModel.name];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 取消不必要的网络请求
    [[ZBURLSessionManager sharedManager]requestToCancel:YES];
    [[SDWebImageManager sharedManager] cancelAll];
    [self.tableView.mj_header endRefreshing]; // 下拉结束刷新
    [self.tableView.mj_footer endRefreshing];// 上拉结束刷新
    self.tableView.mj_footer.hidden = YES;// 隐藏当前的上拉刷新控件
    self.tableView.scrollsToTop = NO;
    [MobClick endLogPageView:_mainModel.name];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self savePageInfo];  // 保存页面数据
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NIGHT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editNightView) name:NIGHT object:nil];//夜间模式通知
    [self getNightPattern];
    [self.view addSubview:self.tableView];
}
#pragma mark -data
- (void)getData{
    static const NSInteger timeOut = 60*60;
    NSTimeInterval currentStamp = [[NSDate date] timeIntervalSince1970];
    //必须加此判断  否则会出现数据重复加载
    if (self.dataArray.count&& currentStamp - _mainModel.lastTime < timeOut) {
        return;
    }
    _mainModel.lastTime = currentStamp;
    
    NSString *httpArg =[NSString stringWithFormat:NEWS_ARG,_mainModel.channelId,(long)_page];
    NSString *urlString=[NSString stringWithFormat:@"%@?%@",NEWS_URL,httpArg];
    NEWSLog(@"urlString:%@",urlString);
    NEWSLog(@"正常请求栏目名字:%@ 正常请求栏目名字id:%@",_mainModel.name,_mainModel.channelId);
   
    [[ZBURLSessionManager sharedManager] setValue:APIKEY forHTTPHeaderField:@"apikey"];
    [[ZBURLSessionManager sharedManager]getRequestWithUrlString:urlString target:self apiType:ZBRequestTypeDefault];
     //=====================================================
    __weak __typeof(self) weakSelf = self;
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadRefresh];
    
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    if (self.dataArray.count>0) {
        [self.tableView.mj_header beginRefreshing];// 马上进入刷新状态
    }
    //=====================================================
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];  // 上拉加载
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}
- (void)loadRefresh{
    NSString *httpArg =[NSString stringWithFormat:NEWS_ARG,_mainModel.channelId,(long)_page];
    NSString *urlString=[NSString stringWithFormat:@"%@?%@",NEWS_URL,httpArg];
    [[ZBURLSessionManager sharedManager] setValue:APIKEY forHTTPHeaderField:@"apikey"];
    [[ZBURLSessionManager sharedManager]getRequestWithUrlString:urlString target:self apiType:ZBRequestTypeRefresh];
}
- (void)loadMoreData{
    _page++;
    NSString *httpMoreArg =[NSString stringWithFormat:NEWS_ARG,_mainModel.channelId,(long)_page];
    NSString *urlMoreString=[NSString stringWithFormat:@"%@?%@",NEWS_URL,httpMoreArg];
    NEWSLog(@"上拉加载栏目名字:%@ 上拉加载url:%@",_mainModel.name,urlMoreString);
    [[ZBURLSessionManager sharedManager] setValue:APIKEY forHTTPHeaderField:@"apikey"];
    [[ZBURLSessionManager sharedManager]getRequestWithUrlString:urlMoreString target:self apiType:ZBRequestTypeLoadMore];
}
#pragma mark - ZBURLSessionDelegate
- (void)urlRequestFinished:(ZBURLSessionManager *)request{
    if (request.apiType==ZBRequestTypeRefresh) {
        [self.dataArray removeAllObjects];//清除数据 等待新数据的到来
        [self.tableView.mj_header endRefreshing];// 下拉结束刷新
    }
    if (request.apiType==ZBRequestTypeLoadMore) {
        [self.tableView.mj_footer endRefreshing];// 上拉结束刷新
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
       // NSLog(@"dict:%@",dict);
    NSDictionary *body=[dict objectForKey:@"showapi_res_body"];
    NSDictionary *pagebean=[body objectForKey:@"pagebean"];
    NSMutableArray *contentlist=[pagebean objectForKey:@"contentlist"];
   // NSLog(@"contentlist:%@",contentlist);
    for (NSDictionary *dic in contentlist) {
        ChannelModel *model=[[ChannelModel alloc]initWithDict:dic];
        model.imageurls=[dic objectForKey:@"imageurls"];
        if ( model.imageurls.count>0) {
            for (NSDictionary *imagedict in model.imageurls) {
                model.url=[imagedict objectForKey:@"url"];
            }
        }
         [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}
- (void)urlRequestFailed:(ZBURLSessionManager *)request{
    if (request.error.code==NSURLErrorCancelled)return;
    if (request.error.code==NSURLErrorTimedOut) {
        NEWSLog(@"请求超时");
        if (request.apiType==ZBRequestTypeRefresh) {
            [self TimedOutAlert];
            [self.tableView.mj_header endRefreshing];// 下拉结束刷新
        }else if (request.apiType==ZBRequestTypeLoadMore){
            [self TimedOutAlert];
            [self.tableView.mj_footer endRefreshing];// 上拉结束刷新
        }
    }else{
        NEWSLog(@"请求失败");
    }
}
#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     ChannelModel *model=self.dataArray[indexPath.row];
    if (model.url==nil) {
        static NSString *channelCell=@"channelCell";
        ChannelTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:channelCell];
        if (cell==nil) {
            cell=[[ChannelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:channelCell];
        }
        [cell setChannelModel:model];
        return cell;
    }else{
        static NSString *ChannelBranchCell=@"channelBranchCell";
        ChannelBranchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ChannelBranchCell];
        if (cell==nil) {
            cell=[[ChannelBranchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ChannelBranchCell];
        }
        [cell setChannelModel:model];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChannelModel *model=[self.dataArray objectAtIndex:indexPath.row];
    DetailViewController *detailsVC=[[DetailViewController alloc]init];
   // detailsVC.urlString=model.link; //detailsVC.html=model.html;
    detailsVC.model=model;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //ChannelModel *model=[self.dataArray objectAtIndex:indexPath.row];
    return 80;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    float deltY = scrollView.contentOffset.y;
    if (deltY<-60) {
      //   [[NSNotificationCenter defaultCenter] postNotificationName:STARTANIMATING object:nil];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float deltY = scrollView.contentOffset.y;
    if (deltY<-80) {
        [UIView animateWithDuration:0.25 animations:^{
            self.magicController.magicView.againstStatusBar = NO;
            self.magicController.magicView.headerHidden =NO;
        }];
    }
    if(deltY>=80){
        [UIView animateWithDuration:0.25 animations:^{
            self.magicController.magicView.againstStatusBar = YES;
            self.magicController.magicView.headerHidden =YES;
        }];
    }
}
- (void)TimedOutAlert{

    [UIView animateWithDuration:0.4 animations:^{
        self.myView=[[MyViewTool alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        [self.view addSubview:self.myView];
    }];
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.myView hide];
    });
}
- (void)getNightPattern{
    if ([GlobalSettingsTool getNightPattern]==YES) {
        self.view.backgroundColor=[UIColor colorWithRed:0.07 green:0.11 blue:0.07 alpha:1.00];
        self.tableView.backgroundColor=[UIColor colorWithRed:0.07 green:0.11 blue:0.07 alpha:1.00];
    }else{
        self.view.backgroundColor=[UIColor whiteColor];
        self.tableView.backgroundColor=[UIColor whiteColor];
    }
}
- (void)editNightView{
    [self getNightPattern];
}

//=============================================================================
#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
    // reset content offset
    NEWSLog(@"clear old data if needed:%@", self);
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero];
}
- (void)savePageInfo {
    [[DataManager sharedInstance] savePageInfo:self.dataArray menuId:_mainModel.channelId];
}
- (void)loadLocalData {
    NSArray *cacheList = [[DataManager sharedInstance] pageInfoWithMenuId:_mainModel.channelId];
    [self.dataArray addObjectsFromArray:cacheList];
    [self.tableView reloadData];
}
#pragma mark - accessor methods
- (void)setMainModel:(MainModel *)model {
    _mainModel = model;
    [self loadLocalData];
}
//=============================================================================
//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
        //self.aiv=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
         //self.aiv.center = CGPointMake(160, 190);
         //self.aiv.color=[UIColor blackColor];
         //[self.aiv startAnimating];
       // _tableView.backgroundView=self.aiv;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.contentInset =UIEdgeInsetsMake(0, 0,0,0);
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
