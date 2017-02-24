//
//  CalendarViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/12/2.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "CalendarViewController.h"
#import <FSCalendar.h>
#import "ZBDataBaseManager.h"
#import "ChannelModel.h"
#import "ChannelTableViewCell.h"
#import "ChannelBranchTableViewCell.h"
#import "DetailViewController.h"
@interface CalendarViewController ()<UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate,FSCalendarDelegateAppearance>{
    CGFloat height;
}
@property (weak , nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (nonatomic, strong) NSArray* dataArray;

@property (strong, nonatomic) NSMutableArray *datesWithEvent;
@end

@implementation CalendarViewController
- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;//隐藏tabbar
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.datesWithEvent=[[NSMutableArray array]init];
    
    height=390;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 300)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;//周一、一
   // calendar.scrollDirection = FSCalendarScrollDirectionVertical;//滚动方向
    [self.view addSubview:calendar];
    self.calendar = calendar;


    [_calendar selectDate:[NSDate date]];
    _calendar.scopeGesture.enabled = YES;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy/MM/dd";
    NSLog(@"aa%@",[self.dateFormatter stringFromDate:[NSDate date]]);
    [[ZBDataBaseManager sharedInstance]getAllDataWithTable:@"calendar" itemId:[self.dateFormatter stringFromDate:[NSDate date]] data:^(NSArray *dataArray,BOOL isExist){
        if (isExist) {
            NSLog(@"存在");
        }
        self.dataArray =dataArray;
        [self.tableView reloadData];
    }];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - <FSCalendarDelegate>
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"should select date %@",[self.dateFormatter stringFromDate:date]);
    NSLog(@"should  %@",[self.dateFormatter stringFromDate:calendar.currentPage]);

    return YES;
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};

    self.tableView.frame=CGRectMake(0, CGRectGetMaxY(calendar.frame), self.view.frame.size.width, SCREEN_HEIGHT-64);
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select date %@",[self.dateFormatter stringFromDate:date]);
    
    NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
    [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
    }];
    NSLog(@"selected dates is %@",selectedDates);
    if (monthPosition == FSCalendarMonthPositionNext || monthPosition == FSCalendarMonthPositionPrevious) {
        [calendar setCurrentPage:date animated:YES];
    }
    
    [[ZBDataBaseManager sharedInstance]getAllDataWithTable:@"calendar" itemId:[self.dateFormatter stringFromDate:date] data:^(NSArray *dataArray,BOOL isExist){
        if (isExist) {
            NSLog(@"存在");
        }
        self.dataArray =dataArray;
        [self.tableView reloadData];
    }];
    
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"%s %@", __FUNCTION__, [self.dateFormatter stringFromDate:calendar.currentPage]);
}
#pragma mark - <FSCalendarDataSource>
/*
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    return 2;
}
 */

#pragma mark - <FSCalendarDelegateAppearance>

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    if ([_datesWithEvent containsObject:dateString]) {
        return [UIColor blackColor];
    }
    return nil;
 
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChannelModel *model=self.dataArray[indexPath.row];
    
    if ([model.icon isKindOfClass:[NSDictionary class]]){
        static NSString *ChannelBranchCell=@"channelBranchCell";
        ChannelBranchTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ChannelBranchCell];
        if (cell==nil) {
            cell=[[ChannelBranchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ChannelBranchCell];
        }
        [cell setChannelModel:model];
        return cell;
        
    }else{
        static NSString *channelCell=@"channelCell";
        ChannelTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:channelCell];
        if (cell==nil) {
            cell=[[ChannelTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:channelCell];
        }
        [cell setChannelModel:model];
        return cell;
    }
}
#pragma mark - <UITableViewDelegate>
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor clearColor];

    UILabel *InfoLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 30)];
    InfoLabel.textAlignment=NSTextAlignmentCenter;
    
    NSString *count=[NSString stringWithFormat:@"您今天阅读了%zd条新闻",[self.dataArray count]];
    NSString *lengthStr=[NSString stringWithFormat:@"%zd",[self.dataArray count]];

    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:count];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:20.0]
     
                          range:NSMakeRange(6, [lengthStr length])];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor redColor]
     
                          range:NSMakeRange(6, [lengthStr length])];
    
    InfoLabel.attributedText = AttributedStr;    
    
    [view addSubview:InfoLabel];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChannelModel *model=[self.dataArray objectAtIndex:indexPath.row];
    if ([model.icon isKindOfClass:[NSDictionary class]]){
        return 100;
    }else{
        return 70;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChannelModel *model=[self.dataArray objectAtIndex:indexPath.row];
    DetailViewController *detailsVC=[[DetailViewController alloc]init];
    detailsVC.model=model;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
/**
 * 当用户手松开(停止拖拽),就会调用这个代理方法
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    int contentOffsety = scrollView.contentOffset.y;
    if (contentOffsety<30) {
        [self.calendar setScope:FSCalendarScopeMonth animated:YES];
    }else{
        [self.calendar setScope:FSCalendarScopeWeek animated:YES];
       
    }
}
- (UITableView *)tableView
{
    if (!_tableView) {
      
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_calendar.frame), self.view.frame.size.width, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        _tableView.tableFooterView=[[UIView alloc]init];
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
