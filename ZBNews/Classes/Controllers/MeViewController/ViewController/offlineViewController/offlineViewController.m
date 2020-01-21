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
#import "ZBMacros.h"
@interface offlineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *offlineArray;
@end

@implementation offlineViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray=[[NSMutableArray alloc]init];

    [self.view addSubview:self.tableView];
    
    //复用MainViewModel
    MainViewModel *viewModel=[[MainViewModel alloc]init];
    RACSignal *signal =[viewModel.command execute:nil];
    [signal subscribeNext:^(id  _Nullable x) {
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
//    NSInteger page=1;
//    NSString *url=[NSString stringWithFormat:NEWS_URL,model.menu_id,page];
    if (sw.isOn == YES) {
        //添加请求列队
        if ([self.offlineArray containsObject:model]==NO) {
             [self.offlineArray addObject:model];
        }
    }else{
        //删除请求列队
        if ([self.offlineArray containsObject:model]==YES) {
             [self.offlineArray removeObject:model];
        }
    }
}
//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ZB_STATUS_HEIGHT+44, SCREEN_WIDTH, SCREEN_HEIGHT-(ZB_STATUS_HEIGHT+44)) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
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
        if (self.offlineArray.count==0) {
            NSLog(@"请添加栏目");
            
        }else{
            NSLog(@"离线请求的栏目/url个数:%ld",self.offlineArray.count);
            
            for (MenuInfo *model in self.offlineArray) {
                NSLog(@"离线请求的name:%@",model.title);
            }
            [self.delegate downloadWithArray:self.offlineArray];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    UIBarButtonItem *downloadItem = [[UIBarButtonItem alloc] initWithCustomView:downloadButton];
    self.navigationItem.rightBarButtonItems = @[downloadItem];
}
- (NSMutableArray *)offlineArray{
    if (!_offlineArray) {
        _offlineArray=[[NSMutableArray alloc]init];
    }
    return _offlineArray;
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
