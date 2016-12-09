//
//  MeViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "MeViewController.h"
#import "MeTableViewCell.h"
#import "ZBNetworking.h"
#import <SDImageCache.h>
#import "MyControlTool.h"
#import "GlobalSettingsTool.h"
#import "LanguageViewController.h"
#import <PYSearch.h>
#import "SearchListViewController.h"
#import "SettingsViewController.h"
#import "CalendarViewController.h"
#import "HeadsPicture.h"
#import "offlineViewController.h"
#import "OfflineView.h"
#import "ChannelModel.h"
#import "DatabaseViewController.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,offlineDelegate,ZBURLSessionDelegate>{
    UIImagePickerController *_thePicker;
}
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImageView *backgroundImgV;
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;
@property(nonatomic,strong) UIImageView* headerImg;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *headerlabel;
@property (nonatomic,strong)NSMutableArray *imageArray;
@property (nonatomic,strong)OfflineView *offlineView;
@end

@implementation MeViewController
- (void)dealloc
{
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
     */

    
    [self meVCgetNightPattern];
    [self backImageView];
    [self.view addSubview:self.tableView];
}

- (void)meVCgetNightPattern{
    if ([GlobalSettingsTool getNightPattern]==YES) {
        // self.view.backgroundColor=[UIColor blackColor];;
        self.view.backgroundColor=[UIColor colorWithRed:0.07 green:0.11 blue:0.07 alpha:1.00];
    }else{
        self.view.backgroundColor=[UIColor whiteColor];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"cellIde";
    MeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[MeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
     if (indexPath.row==0) {
        cell.titleLabel.text=@"搜索新闻";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
     }
    
    if (indexPath.row==1) {
        cell.titleLabel.text=@"阅读日历";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==2) {
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text=@"我的收藏";
        
    }
    if (indexPath.row==3) {
        cell.titleLabel.text=Localized(@"language");
        
    }
    if (indexPath.row==4) {
        
        if ([GlobalSettingsTool getNightPattern]==YES) {
            
            cell.titleLabel.text=Localized(@"daytimemode");
        }else{
            
            cell.titleLabel.text=Localized(@"nightmode");
        }
    }
    if (indexPath.row==5) {
        cell.titleLabel.text=@"离线下载";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    

    }
    if (indexPath.row==6) {
        cell.titleLabel.text=@"设置";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        
        NSArray*hotArr=@[@"特朗普",@"朴槿惠"];
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotArr searchBarPlaceholder:@"搜索新闻" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            // 开始搜索执行以下代码
            // 如：跳转到指定控制器
            
            SearchListViewController *SearchListVC=[[SearchListViewController alloc]init];
            SearchListVC.urlString=searchText;
            SearchListVC.title=searchText;
            [searchViewController.navigationController pushViewController:SearchListVC animated:YES];;
        }];
        
        searchViewController.hotSearchStyle =PYHotSearchStyleDefault; // 热门搜索风格根据选择
        searchViewController.searchHistoryStyle = PYHotSearchStyleARCBorderTag; // 搜索历史风格为default
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
        [self presentViewController:nav  animated:YES completion:nil];
        
    }
    if (indexPath.row==1) {
  
        CalendarViewController *calendar=[[CalendarViewController alloc]init];
        [self.navigationController pushViewController:calendar animated:YES];
    }
    if (indexPath.row==2) {
        DatabaseViewController *databaseVC=[[DatabaseViewController alloc]init];
        [self.navigationController pushViewController:databaseVC animated:YES];
        
    }
    if (indexPath.row==3) {
        LanguageViewController *langVC=[[LanguageViewController alloc]init];
        [self.navigationController pushViewController:langVC animated:YES];
    }
    if (indexPath.row==4) {
        BOOL night = [[NSUserDefaults standardUserDefaults]boolForKey:@"readStyle"];
        [[NSUserDefaults standardUserDefaults]setBool:!night forKey:@"readStyle"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NIGHT object:[NSString stringWithFormat:@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:@"readStyle"]]];
        [self meVCgetNightPattern];
        [self.tableView reloadData];
    }
    if (indexPath.row==5) {
        offlineViewController *offlineVC=[[offlineViewController alloc]init];
        offlineVC.delegate=self;
        [self.navigationController pushViewController:offlineVC animated:YES];
        
    }
    if (indexPath.row==6) {
        SettingsViewController *settingVC=[[SettingsViewController alloc]init]; 
        [self.navigationController pushViewController:settingVC animated:YES];
    }
    
}
#pragma mark offlineDelegate
- (void)downloadWithArray:(NSMutableArray *)offlineArray{
    //离线请求 apiType:ZBRequestTypeOffline
    [[ZBURLSessionManager sharedManager] offlineDownload:offlineArray target:self apiType:ZBRequestTypeOffline];
    
    self.offlineView=[[OfflineView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    [self.offlineView.cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.offlineView];
}
#pragma mark - ZBURLSessionManager Delegate
- (void)urlRequestFinished:(ZBURLSessionManager *)request{
    //如果是离线数据
    if (request.apiType==ZBRequestTypeOffline) {
        NSLog(@"添加了几个url  就会走几遍");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.downloadData options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *body=[dict objectForKey:@"showapi_res_body"];
        NSDictionary *pagebean=[body objectForKey:@"pagebean"];
        NSArray *contentlist=[pagebean objectForKey:@"contentlist"];
        //NEWSLog(@"contentlist:%@",contentlist);
        for (NSDictionary *dic in contentlist) {
            ChannelModel *model=[[ChannelModel alloc]initWithDict:dic];
            model.imageurls=[dic objectForKey:@"imageurls"];
            if ( model.imageurls.count>0) {
                for (NSDictionary *imagedict in model.imageurls) {
                    model.url=[imagedict objectForKey:@"url"];
                }
            }
            [self.imageArray addObject:model];
            //使用SDWebImage 下载图片
            BOOL isKey=[[SDImageCache sharedImageCache]diskImageExistsWithKey:model.url];
            if (isKey) {
                
                NSLog(@"已经下载了");
                 self.offlineView.progressLabel.text=@"已经下载了";
       
            } else{
                
                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:model.url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize){
                    
                    NSLog(@"%@",[self progressStrWithSize:(double)receivedSize/expectedSize]);
                    
                       self.offlineView.progressLabel.text=[self progressStrWithSize:(double)receivedSize/expectedSize];
                    
                      self.offlineView.pv.progress =(double)receivedSize/expectedSize;
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,BOOL finished,NSURL *imageURL){
                    
                    NSLog(@"单个图片下载完成");
                    
                       self.offlineView.progressLabel.text=[self progressStrWithSize:0.0];
          
                      self.offlineView.pv.progress = 0.0;
    
                    //让 下载的url与模型的最后一个比较，如果相同证明下载完毕。
                    NSString *imageURLStr = [imageURL absoluteString];
                    NSString *lastImage=[NSString stringWithFormat:@"%@",((ChannelModel *)[self.imageArray lastObject]).url];
                    
                    if ([imageURLStr isEqualToString:lastImage]) {
                        NSLog(@"下载完成");
                            [self.offlineView hide];
                            self.imageArray=nil;
                    }
                    
                    if (error) {
                        NSLog(@"下载失败");
                        
                    }
                }];
                
            }

        }

    }
}
- (void)urlRequestFailed:(ZBURLSessionManager *)request{
    
    if (request.error.code==NSURLErrorCancelled)return;
    if (request.error.code==NSURLErrorTimedOut) {
      //  [self alertTitle:@"请求超时" andMessage:@""];
    }else{
      //  [self alertTitle:@"请求失败" andMessage:@""];
    }
    
    
}

- (void)cancelClick{
    [[ZBURLSessionManager sharedManager] requestToCancel:YES];
    [[SDWebImageManager sharedManager] cancelAll];
    [self.offlineView hide];
    self.imageArray=nil;
    NSLog(@"取消下载");
}
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

//懒加载
- (UITableView *)tableView
{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableHeaderView=[self headImageView];
        _tableView.tableFooterView=[[UIView alloc]init];
        
    }
    
    return _tableView;
}

-(void)backImageView{
    UIImage *image=[UIImage imageNamed:@"back.png"];
    
    _backgroundImgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, image.size.height*0.8)];
    //  _backgroundImgV.backgroundColor=[UIColor redColor];
    _backgroundImgV.image=image;
    _backgroundImgV.userInteractionEnabled=YES;
    [self.view addSubview:_backgroundImgV];
    _backImgHeight=_backgroundImgV.frame.size.height;
    _backImgWidth=_backgroundImgV.frame.size.width;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView=[[UIImageView alloc]init];
        _headImageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 240);
        _headImageView.backgroundColor=[UIColor clearColor];
        _headImageView.userInteractionEnabled = YES;
        
        _headerImg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-35, 120, 70, 70)];
        _headerImg.center=CGPointMake(SCREEN_WIDTH/2, 120);
        
       UIImage *image=[[HeadsPicture sharedHeadsPicture]imageForKey:@"HeadsPicture"];
        if (image) {
            [_headerImg setImage:image];

        }else{
            [_headerImg setImage:[UIImage imageNamed:@"dropdown_anim__0001"]];

        }
        [_headerImg.layer setMasksToBounds:YES];
        [_headerImg.layer setCornerRadius:35];
        
        _headerImg.backgroundColor=[UIColor whiteColor];
        _headerImg.userInteractionEnabled=YES;
        UITapGestureRecognizer *header_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(header_tap_Click:)];
        [_headerImg addGestureRecognizer:header_tap];
        [_headImageView addSubview:_headerImg];
        
        _headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-50, 170, 100, 20)];
        _headerlabel.text=@"Andi";
        _headerlabel.textColor=[UIColor whiteColor];
        _headerlabel.textAlignment=NSTextAlignmentCenter;
        [_headImageView addSubview:_headerlabel];

    }
    return _headImageView;
}
-(void)header_tap_Click:(UITapGestureRecognizer *)tap
{
    __weak typeof(self) weakSelf = self;
    
    //UIImagePickerController 封装了系统的相机和相册库资源
    _thePicker=[[UIImagePickerController alloc]init];
    //设置代理
    _thePicker.delegate=self;
    
    //是否对拿到的图片资源进行自动处理
    _thePicker.allowsEditing = YES;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *_Nonnull action){
       
    }];
    UIAlertAction *defult = [UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *_Nonnull action){
        
       _thePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [weakSelf presentViewController:_thePicker animated:YES completion:nil];
    }];
    UIAlertAction *defult1 = [UIAlertAction actionWithTitle:@"手机相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *_Nonnull action){
            _thePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [weakSelf presentViewController:_thePicker animated:YES completion:nil];
        
      }];
    
    [alert addAction:cancel];
    [alert addAction:defult];
    [alert addAction:defult1];
    [self presentViewController:alert animated:YES completion:nil]; //呈现

   
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *seleImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    //以itemKey为键，将照片存入ImageStore对象中
    [[HeadsPicture sharedHeadsPicture] setImage:seleImage forKey:@"HeadsPicture"];
    [_headerImg setImage:seleImage];
    //把一张照片保存到图库中，此时无论是这张照片是照相机拍的还是本身从图库中取出的，都会保存到图库中；
  //  UIImageWriteToSavedPhotosAlbum(seleImage, self, nil, nil);
    //压缩图片,如果图片要上传到服务器或者网络，则需要执行该步骤（压缩），第二个参数是压缩比例，转化为NSData类型；
   // NSData *fileData = UIImageJPEGRepresentation(image, 1.0);
    [_thePicker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsety = scrollView.contentOffset.y;
    
    if (contentOffsety<0) {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight-contentOffsety;
        rect.size.width = _backImgWidth* (_backImgHeight-contentOffsety)/_backImgHeight;
        rect.origin.x =  -(rect.size.width-_backImgWidth)/2;
        rect.origin.y = 0;
        _backgroundImgV.frame = rect;
    }else{
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -contentOffsety;
        _backgroundImgV.frame = rect;
        
    }
}
- (NSString *)progressStrWithSize:(double)size{
    NSString *progressStr = [NSString stringWithFormat:@"图片:%.1f",size* 100];
    return  progressStr = [progressStr stringByAppendingString:@"%"];
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
