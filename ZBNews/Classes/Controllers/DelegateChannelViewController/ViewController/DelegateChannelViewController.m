//
//  DelegateChannelViewController.m
//  ZBNews
//
//  Created by NQ UEC on 2018/6/13.
//  Copyright © 2018年 Suzhibin. All rights reserved.
//

#import "DelegateChannelViewController.h"
#import "MenuInfo.h"
#import "DataManager.h"
#import "DelegateChannelViewModel.h"
#import "DelegateChannelFirstCell.h"
#import "DelegateChannelSecondCell.h"
@interface DelegateChannelViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,delegateChannelViewModelDelegate>
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,strong) MJRefreshNormalHeader *header;
@property (nonatomic ,strong) MJRefreshAutoNormalFooter *footer;
@property (nonatomic ,strong) DelegateChannelViewModel *viewModel;
@end
@implementation DelegateChannelViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.scrollsToTop = YES;
    NSInteger pageIndex = [self vtm_pageIndex];
    SLog(@"当前页面索引: %ld", (long)pageIndex);
    [self requestListData];//加载数据
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.viewModel cancelRequestWithMenuInfo:_menuInfo]; // 取消不必要的网络请求
    [self endRefresh];
    self.collectionView.scrollsToTop = NO;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //   [self savePageInfo];  // //保存页面数据 VTMagic官方Dome 的方法
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createCollectionView];
    [self createRefresh];
}
#pragma mark -data
- (void)requestListData{
    NSTimeInterval currentStamp = [[NSDate date] timeIntervalSince1970];
    if (self.dataArray.count&& currentStamp - _menuInfo.lastTime < timeOut){
        return;  //必须加此判断  否则会出现数据重复加载
    }
    _menuInfo.lastTime = currentStamp;
    [self.header beginRefreshing];
}
- (void)loadRefresh{
    _page=1;
    [self.viewModel requestListDataWithPage:_page menuInfo:_menuInfo requestType:ZBRequestTypeRefresh];
}
- (void)loadMoreData{
    _page++;
    [self.viewModel requestListDataWithPage:_page menuInfo:_menuInfo requestType:ZBRequestTypeRefreshMore];
}
#pragma mark - delegateChannelViewModelDelegate
- (void)requestFinished:(NSMutableArray *)dataArray{
    self.dataArray=dataArray;
    [self.collectionView reloadData];
    [self endRefresh];
}
- (void)requestFailed:(NSError *)error{
    SLog(@"请求失败%@",error);
    [self endRefresh];
}
#pragma mark - UICollectionViewDelegate
#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RACChannelModel *model = self.dataArray[indexPath.item];
    NSString *identifier=[self.viewModel dataCellIdentifier:model];
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.channelModel=model;
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 15, 5, 15);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    RACChannelModel *model=[self.dataArray objectAtIndex:indexPath.item];
    [self.viewModel pushModel:model controller:self completion:nil];
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
- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(100,100);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(ZB_STATUS_HEIGHT+44)) collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:collectionView];
    self.collectionView =collectionView;
    [collectionView registerClass:[DelegateChannelFirstCell class] forCellWithReuseIdentifier:NSStringFromClass([DelegateChannelFirstCell class])];
    [collectionView registerClass:[DelegateChannelSecondCell class] forCellWithReuseIdentifier:NSStringFromClass([DelegateChannelSecondCell class])];
}
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
    self.collectionView.mj_header=header;
    self.header=header;
    //=====================================================
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.collectionView.mj_footer=footer;
    self.footer=footer;
}
- (DelegateChannelViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[DelegateChannelViewModel alloc] init];
        _viewModel.viewModelDelegate=self;
    }
    return _viewModel;
}
#pragma mark - VTMagicReuseProtocol
- (void)vtm_prepareForReuse {
  //  SLog(@"clear old data if needed:%@", self);
    [self.dataArray removeAllObjects];
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointZero];
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
    [self.viewModel requestListDataWithPage:_page menuInfo:_menuInfo requestType:ZBRequestTypeCache];
    SLog(@"预加载: %@",_menuInfo.title);
    //VTMagic官方Dome 的方法  [self loadLocalData]; 
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
