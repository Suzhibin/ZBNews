//
//  offlineViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/8.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "offlineViewController.h"
#import "ZBNetworking.h"
#import "MenuInfo.h"
#import "API_Constants.h"
#import "MainViewModel.h"
@interface offlineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)ZBBatchRequest *request;
@end

@implementation offlineViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray=[[NSMutableArray alloc]init];
    
    self.request=[[ZBBatchRequest alloc]init];

    [self.view addSubview:self.tableView];
    
    //复用MainViewModel
    MainViewModel *viewModel=[[MainViewModel alloc]init];
    [[viewModel requestMenuData]subscribeNext:^(id  _Nullable x) {
        self.dataArray=x;
        [self.tableView reloadData];
    }];
    [self createDownloadButton];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    UISwitch *sw = [[UISwitch alloc] init];
    sw.center = CGPointMake(160, 90);
    sw.tag = indexPath.row;
    [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = sw;
    
    MenuInfo *model=[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=model.title;

    return cell;
}
- (void)switchValueChanged:(UISwitch *)sw{

    MenuInfo *model=[self.dataArray objectAtIndex:sw.tag];
    NSInteger page=1;
    NSString *url=[NSString stringWithFormat:NEWS_URL,model.menu_id,page];
    if (sw.isOn == YES) {
        //添加请求列队
        [self.request addObjectWithUrl:url];
        [self.request addObjectWithKey:model.title];
        NSLog(@"离线请求的url:%@",self.request.batchUrlArray);
    }else{
        //删除请求列队
        [self.request removeObjectWithUrl:url];
        [self.request removeObjectWithKey:model.title];
        NSLog(@"离线请求的url:%@",self.request.batchUrlArray);
    }
}
//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
         _tableView.contentInset =UIEdgeInsetsMake(0, 0,40,0);
    }
    
    return _tableView;
}
- (void)createDownloadButton{
    UIButton * downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [downloadButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downloadButton setTitle:@"离线下载" forState:UIControlStateNormal];
    @weakify(self);
    [[downloadButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.request.batchUrlArray.count==0) {
            NSLog(@"请添加栏目");
            
        }else{
            NSLog(@"离线请求的栏目/url个数:%ld",self.request.batchUrlArray.count);
            
            for (NSString *name in self.request.batchKeyArray) {
                NSLog(@"离线请求的name:%@",name);
            }
            [self.delegate downloadWithArray:self.request.batchUrlArray];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    UIBarButtonItem *downloadItem = [[UIBarButtonItem alloc] initWithCustomView:downloadButton];
    self.navigationItem.rightBarButtonItems = @[downloadItem];
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
