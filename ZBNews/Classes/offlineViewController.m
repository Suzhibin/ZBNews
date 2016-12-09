//
//  offlineViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/8.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "offlineViewController.h"
#import "ZBNetworking.h"
#import "MainModel.h"
#import "API_Constants.h"
@interface offlineViewController ()<UITableViewDelegate,UITableViewDataSource,ZBURLSessionDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic,strong)ZBURLSessionManager *manager;

@end

@implementation offlineViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;//隐藏tabbar
    }
    return self;
}
- (ZBURLSessionManager *)session {
    
    return [ZBURLSessionManager sharedManager];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray=[[NSMutableArray alloc]init];
    
    //创建单例
    self.manager=[self session];
    [self generateData];
    [self.view addSubview:self.tableView];
    [self addItemWithTitle:@"离线下载" selector:@selector(offlineBtnClick) location:NO];
}
- (void)generateData{
    //保证频道是最新的 不要取缓存
    [[ZBURLSessionManager sharedManager] setValue:APIKEY forHTTPHeaderField:@"apikey"];
    [[ZBURLSessionManager sharedManager]getRequestWithUrlString:MENU_URL target:self apiType:ZBRequestTypeDefault];

}
- (void)urlRequestFinished:(ZBURLSessionManager *)request{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
    // NEWSLog(@"dict%@",dict);

        NSDictionary *body=[dict objectForKey:@"showapi_res_body"];
        NSArray *array=[body objectForKey:@"channelList"];
        //    NEWSLog(@"%@",array);
        for (NSDictionary *dic in array) {
            MainModel *model=[[MainModel alloc]initWithDict:dic];
            [self.dataArray addObject:model];
            // NEWSLog(@"栏目:%@",model.name);
        }
        
    
    [self.tableView reloadData];
    
}
- (void)urlRequestFailed:(ZBURLSessionManager *)request{
    if (request.error.code==NSURLErrorCancelled)return;
    if (request.error.code==NSURLErrorTimedOut) {
        NEWSLog(@"请求超时");
    }else{
        NEWSLog(@"请求失败");
    }
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
    
    MainModel *model=[self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text=model.name;

    return cell;
}
- (void)switchValueChanged:(UISwitch *)sw{
    NSInteger page=1;
    MainModel *model=[self.dataArray objectAtIndex:sw.tag];
 
    NSString *httpheadArg =[NSString stringWithFormat:NEWS_ARG,model.channelId,(long)page];
    NSString *url=[NSString stringWithFormat:@"%@?%@",NEWS_URL,httpheadArg];
    if (sw.isOn == YES) {
        //添加请求列队
        [self.manager addObjectWithUrl:url];
        [self.manager addObjectWithName:model.name];
        NSLog(@"离线请求的url:%@",self.manager.offlineUrlArray);
    }else{
        //删除请求列队
        [self.manager removeObjectWithUrl:url];
        [self.manager removeObjectWithName:model.name];
        NSLog(@"离线请求的url:%@",self.manager.offlineUrlArray);
    }
}


- (void)offlineBtnClick{
    
    if (self.manager.offlineUrlArray.count==0) {
        NSLog(@"请添加栏目");

    }else{
        
        NSLog(@"离线请求的栏目/url个数:%ld",self.manager.offlineUrlArray.count);
        
        for (NSString *name in self.manager.offlineNameArray) {
            NSLog(@"离线请求的name:%@",name);
        }
        
        [self.delegate downloadWithArray:self.manager.offlineUrlArray];
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
