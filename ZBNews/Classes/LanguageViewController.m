//
//  LanguageViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "LanguageViewController.h"
#import "Constants.h"
#import "GlobalSettingsTool.h"
@interface LanguageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation LanguageViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editchangeNightView) name:NIGHT object:nil];//夜间模式通知
 
    [self.view addSubview:self.tableView];
    [self getNightPattern];
}

- (void)editchangeNightView{
   [self getNightPattern];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIde];
    }
    if (indexPath.row==0) {
        cell.textLabel.text= Localized(@"content1");
    }
    
    if (indexPath.row==1) {
        cell.textLabel.text=Localized(@"content2");
        
    }
    if (indexPath.row==2) {
        cell.textLabel.text=Localized(@"content3");
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        [self.tableView reloadData];
    }
    if (indexPath.row==1) {
        [[NSUserDefaults standardUserDefaults] setObject:Chinese forKey:LanguageKey];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }
    if (indexPath.row==2) {
        [[NSUserDefaults standardUserDefaults] setObject:English forKey:LanguageKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.tableView reloadData];
    }
}

//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
}
- (void)getNightPattern
{
    if ([GlobalSettingsTool getNightPattern]==YES) {
        self.view.backgroundColor=[UIColor colorWithRed:0.07 green:0.11 blue:0.07 alpha:1.00];
    }else{
        self.view.backgroundColor=[UIColor whiteColor];
    }
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
