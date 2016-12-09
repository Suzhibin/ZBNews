//
//  DatabaseViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/9.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "DatabaseViewController.h"
#import "ZBDataBaseManager.h"
#import "ChannelModel.h"
#import "ChannelTableViewCell.h"
#import "ChannelBranchTableViewCell.h"
#import "DetailViewController.h"
@interface DatabaseViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation DatabaseViewController
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
    self.dataArray = [[ZBDataBaseManager sharedManager] fetchAllUsers];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    NSLog(@"收藏新闻个数:%ld",self.dataArray.count );
    
    [self addItemWithTitle:@"编辑" selector:@selector(editItemClick:) location:NO];
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
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //返回删除
    return UITableViewCellEditingStyleDelete;
    
}
// 点击cell的编辑按钮时候调用!!
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelModel *model=[_dataArray objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 如果类型是删除
        NSMutableArray *array = (NSMutableArray *)self.dataArray;
        [array removeObjectAtIndex:indexPath.row];
        
        [[ZBDataBaseManager sharedManager] deleteDataWithItemId:model.title];//删除对应文章id
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
    
        _tableView.tableFooterView=[[UIView alloc]init];
    }
    return _tableView;
}
/*
- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
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
