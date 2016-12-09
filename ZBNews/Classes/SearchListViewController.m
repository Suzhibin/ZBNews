//
//  SearchListViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/29.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "SearchListViewController.h"
#import "ZBNetworking.h"
#import "ChannelModel.h"
#import "ChannelTableViewCell.h"
#import "ChannelBranchTableViewCell.h"
#import "DetailViewController.h"
#import <MJRefresh.h>
@interface SearchListViewController ()<ZBURLSessionDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIActivityIndicatorView *aiv;
@end

@implementation SearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    _page=1;
    NEWSLog(@"urlString:%@",self.urlString);
    NSString *httpArg =[NSString stringWithFormat:search_ARG,self.urlString,(long)_page];
    NSString *urlString=[NSString stringWithFormat:@"%@?%@",NEWS_URL,httpArg];
    NEWSLog(@"urlString:%@",urlString);
    NEWSLog(@"正常请求栏目名字:%@ ",self.urlString);
    [[ZBURLSessionManager sharedManager] setValue:APIKEY forHTTPHeaderField:@"apikey"];
    [[ZBURLSessionManager sharedManager]getRequestWithUrlString:urlString target:self apiType:ZBRequestTypeRefresh];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];  // 上拉加载
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;

}
- (void)loadMoreData{
    _page++;
    NSString *httpMoreArg =[NSString stringWithFormat:search_ARG,self.urlString,(long)_page];
    NSString *urlMoreString=[NSString stringWithFormat:@"%@?%@",NEWS_URL,httpMoreArg];

    NEWSLog(@" 上拉加载url:%@",urlMoreString);
    [[ZBURLSessionManager sharedManager] setValue:APIKEY forHTTPHeaderField:@"apikey"];
    [[ZBURLSessionManager sharedManager]getRequestWithUrlString:urlMoreString target:self apiType:ZBRequestTypeLoadMore];
}

#pragma mark - ZBURLSessionDelegate
- (void)urlRequestFinished:(ZBURLSessionManager *)request{
    if (request.apiType==ZBRequestTypeRefresh) {
        [self.dataArray removeAllObjects];//清除数据 等待新数据的到来
      //  [self.tableView.mj_header endRefreshing];// 下拉结束刷新
    }
    if (request.apiType==ZBRequestTypeLoadMore) {
        [self.tableView.mj_footer endRefreshing];// 上拉结束刷新
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *body=[dict objectForKey:@"showapi_res_body"];
    NSDictionary *pagebean=[body objectForKey:@"pagebean"];
    NSArray *contentlist=[pagebean objectForKey:@"contentlist"];
  //  NEWSLog(@"contentlist:%@",contentlist);
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
    [self.aiv removeFromSuperview];
}
- (void)urlRequestFailed:(ZBURLSessionManager *)request{
   // [self.tableView.mj_header endRefreshing];  // 下拉结束刷新
   // [self.tableView.mj_footer endRefreshing]; // 上拉结束刷新
    if (request.error.code==NSURLErrorCancelled)return;
    if (request.error.code==NSURLErrorTimedOut) {
        NEWSLog(@"请求超时");
        if (request.apiType==ZBRequestTypeRefresh) {
          //  [self timeOut:YES];
        }else if (request.apiType==ZBRequestTypeLoadMore){
          //  [self timeOut:NO];
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

//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        self.aiv=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.aiv.center = CGPointMake(160, 190);
        self.aiv.color=[UIColor blackColor];
        [self.aiv startAnimating];
        _tableView.backgroundView=self.aiv;
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
