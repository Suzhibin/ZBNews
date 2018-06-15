//
//  DatabaseViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/9.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "DatabaseViewController.h"
#import "RACChannelModel.h"
#import "DetailViewController.h"
#import "ZBKit.h"
#import "RACChannelFirstCell.h"
#import "RACChannelSecondCell.h"
#import "BaseViewModel.h"
@interface DatabaseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation DatabaseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self.view addSubview:self.tableView];

     NSArray *allData = [[ZBDataBaseManager sharedInstance]getAllDataWithTable:Sfavorites];
    [allData enumerateObjectsUsingBlock:^(ZBDataBaseModel *dbModel, NSUInteger idx, BOOL * _Nonnull stop) {
        //   SLog(@"object:%@",dbModel.object);
        RACChannelModel *model=[[RACChannelModel alloc]initWithDict:dbModel.object];
        [self.dataArray addObject:model];
    }];

    SLog(@"收藏新闻:%@",self.dataArray );
 
    [self.tableView reloadData];

}
- (void)editItemClick:(UIBarButtonItem *)item
{
    // 判断_tableView是否处于编辑状态!
    if (self.tableView.isEditing) {
        // 将_tableView 转为非编辑状态
        // _tableView.editing = NO;
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}
#pragma mark tableView
// 返回indexPath对应的cell是什么编辑状态! (默认是删除)
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //返回删除
    return UITableViewCellEditingStyleDelete;
    
}
// 点击cell的编辑按钮时候调用!!
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    RACChannelModel *model=[_dataArray objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 如果类型是删除
        NSMutableArray *array = (NSMutableArray *)self.dataArray;
        [array removeObjectAtIndex:indexPath.row];
        [[ZBDataBaseManager sharedInstance]table:Sfavorites deleteObjectItemId:model.newsId isSuccess:^(BOOL isSuccess) {
            if (isSuccess) {
                SLog(@"删除数据");
            }else{
                SLog(@"删除失败");
            }
        }];
        // [tableView beginUpdates];
        // 用_tableView 删除行刷新方法刷新显示
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        //  [tableView endUpdates];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RACChannelModel *model=self.dataArray[indexPath.row];
    NSString *identifier=[self newsCellIdentifier:model];
    BaseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.channelModel=model;
    return cell;
}
- (NSString *)newsCellIdentifier:(RACChannelModel *)model{
    if ([model.icon isKindOfClass:[NSDictionary class]]){
        return NSStringFromClass([RACChannelFirstCell class]);
    }else{
        return NSStringFromClass([RACChannelSecondCell class]);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RACChannelModel *model=[self.dataArray objectAtIndex:indexPath.row];
    [self.baseVM pushModel:model controller:self completion:nil];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ZB_STATUS_HEIGHT+44, SCREEN_WIDTH, SCREEN_HEIGHT-(ZB_STATUS_HEIGHT+44)) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight=124;
        _tableView.tableFooterView=[UIView new];
        [_tableView registerClass:[RACChannelFirstCell class] forCellReuseIdentifier:NSStringFromClass([RACChannelFirstCell class])];
        [_tableView registerClass:[RACChannelSecondCell class] forCellReuseIdentifier:NSStringFromClass([RACChannelSecondCell class])];
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
