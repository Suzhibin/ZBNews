//
//  RACChannelViewController.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "RACChannelViewController.h"
#import "MenuInfo.h"
#import  <VTMagic/VTMagic.h>
#import "DataManager.h"
#import "RACChannelFirstCell.h"
#import "RACChannelSecondCell.h"
#import "RACChannelViewModel.h"
@interface RACChannelViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,strong) MJRefreshNormalHeader *header;
@property (nonatomic ,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic ,strong) RACChannelViewModel *viewModel;
@end
@implementation RACChannelViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.scrollsToTop = YES;
    NSInteger pageIndex = [self vtm_pageIndex];
    SLog(@"当前页面索引: %ld", (long)pageIndex);
    [self requestListData];//加载数据
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel cancelRequestWithMenuInfo:_menuInfo]; // 取消不必要的网络请求
    [self endRefresh];
    self.tableView.scrollsToTop = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //   [self savePageInfo];  // //保存页面数据 VTMagic官方Dome 的方法
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTable];
    [self createRefresh];
}
#pragma mark -data
- (void)requestListData{
    NSTimeInterval currentStamp = [[NSDate date] timeIntervalSince1970];
    if (self.dataArray.count&& currentStamp - _menuInfo.lastTime < timeOut) {
        return; //必须加此判断  否则会出现数据重复加载
    }
    _menuInfo.lastTime = currentStamp;
    [self.header beginRefreshing];// 进入刷新状态
}
- (void)loadRefresh{
    _page=1;
    [self request:_page requestType:ZBRequestTypeRefresh];
}
- (void)loadMoreData{
    _page++;
    [self request:_page requestType:ZBRequestTypeRefreshMore];
}
- (void)request:(NSInteger)page requestType:(apiType)requestType{
    [[self.viewModel requestListDataWithPage:page menuInfo:_menuInfo requestType:requestType]subscribeNext:^(id  _Nullable x) {
        self.dataArray=x;
        [self.tableView reloadData];
        [self endRefresh];
    }error:^(NSError * _Nullable error) {
        SLog(@"请求失败%@",error);
        [self endRefresh];
    }];
}
#pragma mark tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RACChannelModel *model=self.dataArray[indexPath.row];
    NSString *identifier=[self.viewModel dataCellIdentifier:model];
    BaseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.channelModel=model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RACChannelModel *model=[self.dataArray objectAtIndex:indexPath.row];
    [self.viewModel pushModel:model controller:self completion:^(id  _Nullable x) {
            SLog(@"离开了详情页 接收到信号:%@",x);
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset>0) {
        self.magicController.magicView.againstStatusBar = YES;
        [self.magicController.magicView setHeaderHidden:YES duration:0.35];
    }else{
        self.magicController.magicView.againstStatusBar = NO;
        [self.magicController.magicView setHeaderHidden:NO duration:0.35];
    }
}
#pragma mark - UI
- (void)endRefresh{
    [self.header endRefreshing];// 下拉结束刷新
    [self.footer endRefreshing];// 上拉结束刷新
}
- (void)createRefresh{
    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadRefresh];
    }];
    header.automaticallyChangeAlpha = YES;
    self.tableView.mj_header=header;
    self.header=header;
    //=====================================================
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.tableView.mj_footer=footer;
    self.footer=footer;
}
- (void)createTable{
    UITableView* tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(ZB_STATUS_HEIGHT+44)) style:UITableViewStylePlain];

    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.rowHeight=124;
    tableView.tableFooterView=[UIView new];
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView registerClass:[RACChannelFirstCell class] forCellReuseIdentifier:NSStringFromClass([RACChannelFirstCell class])];
    [tableView registerClass:[RACChannelSecondCell class] forCellReuseIdentifier:NSStringFromClass([RACChannelSecondCell class])];
    if (@available(iOS 11.0,*))  {
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
    }
}
- (RACChannelViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[RACChannelViewModel alloc] init];
    }
    return _viewModel;
 
    
}
#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
   // SLog(@"clear old data if needed:%@", self);
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero];
}
#pragma mark - accessor methods
- (void)setMenuInfo:(MenuInfo *)menuInfo {
    _menuInfo = menuInfo;
    /*
    if(有缓存){
     //   读取缓存 刷新列表
    }else{
     //   重新请求 刷新列表 存缓存
    }
    */
    _page=1;
    [self request:_page requestType:ZBRequestTypeCache]; //如有缓存使用缓存，无缓存重新加载
    SLog(@"预加载: %@",_menuInfo.title);
    
    //VTMagic官方Dome 加载列表缓存的方法  [self loadLocalData];
}
/*
 //VTMagic官方Dome 的方法
 - (void)savePageInfo {
 [[DataManager sharedInstance] savePageInfo:self.dataArray menuId:_mainModel.menu_id];
 }
 - (void)loadLocalData {
 NSArray *cacheList = [[DataManager sharedInstance] pageInfoWithMenuId:_mainModel.menu_id];
 [self.dataArray addObjectsFromArray:cacheList];
 [self.tableView reloadData];
 }
 */
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
