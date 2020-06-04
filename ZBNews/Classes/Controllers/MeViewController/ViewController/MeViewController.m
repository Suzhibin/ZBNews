//
//  MeViewController.m
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#import "MeViewController.h"
#import "ZBNetworking.h"
#import "SDImageCache.h"
#import "CalendarViewController.h"
#import "offlineViewController.h"
#import "RACChannelModel.h"
#import "DatabaseViewController.h"
@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,offlineDelegate>{
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
@end

@implementation MeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
     [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
     */
    self.view.backgroundColor=[UIColor whiteColor];
    [self backImageView];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIde=@"cellIde";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIde];
    }

    if (indexPath.row==0) {
        cell.textLabel.text=@"阅读日历";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row==1) {
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text=@"我的收藏";
        
    }

    if (indexPath.row==2) {
        cell.textLabel.text=@"离线下载";
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    

    }
    if (indexPath.row==3) {
        cell.textLabel.text=@"清除缓存";
        CGFloat cacheSize=[[ZBCacheManager sharedInstance]getCacheSize];//json缓存文件大小
        CGFloat sdimageSize = [[SDImageCache sharedImageCache]totalDiskSize];//图片缓存大小
        CGFloat AppCacheSize=cacheSize+sdimageSize;
        AppCacheSize=AppCacheSize/1000.0/1000.0;
        
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2fM",AppCacheSize];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (indexPath.row==0) {
  
        CalendarViewController *calendar=[[CalendarViewController alloc]init];
        [self.navigationController pushViewController:calendar animated:YES];
    }
    if (indexPath.row==1) {
        DatabaseViewController *databaseVC=[[DatabaseViewController alloc]init];
        [self.navigationController pushViewController:databaseVC animated:YES];
        
    }
    if (indexPath.row==2) {
        offlineViewController *offlineVC=[[offlineViewController alloc]init];
        offlineVC.delegate=self;
        [self.navigationController pushViewController:offlineVC animated:YES];
        
    }
    if (indexPath.row==3) {
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            
            [[ZBCacheManager sharedInstance]clearCache];
            
            [[SDImageCache sharedImageCache] clearMemory];
            //清除系统内存文件
            [[NSURLCache sharedURLCache]removeAllCachedResponses];
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
            
        }];
    }
    
}
#pragma mark offlineDelegate
- (void)downloadWithArray:(NSMutableArray *)offlineArray{

   [ZBRequestManager sendBatchRequest:^(ZBBatchRequest *  batchRequest){
        
        for (MenuInfo *model in offlineArray) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"id"] = model.menu_id;
            parameters[@"p"] = @(1).stringValue;
            ZBURLRequest *request=[[ZBURLRequest alloc]init];
            request.URLString=@"/wnl/tag/page";
            request.parameters=parameters;
            [batchRequest.requestArray addObject:request];
        }
        
    }  success:^(id responseObject,ZBURLRequest *request){
            NSLog(@"添加了几个url  就会走几遍");
        if ([responseObject isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)responseObject;
            //NEWSLog(@"contentlist:%@",contentlist);
            for (NSDictionary *dic in array) {
                RACChannelModel *model=[[RACChannelModel alloc]initWithDict:dic];
                model.icon=[dic objectForKey:@"icon"];
                if ([model.icon isKindOfClass:[NSDictionary class]]){
                    model.icon_small1=[model.icon objectForKey:@"icon_small1"];
                    model.icon_small2=[model.icon objectForKey:@"icon_small2"];
                    model.icon_small3=[model.icon objectForKey:@"icon_small3"];
                }
                [self.imageArray addObject:model];
                           
                if ([model.icon isKindOfClass:[NSDictionary class]]){
                    NSArray *imageArray=[NSArray arrayWithObjects:model.icon_small1,model.icon_small2,model.icon_small3, nil];
                    for (NSInteger i=0; i<imageArray.count; i++) {
                        [[SDImageCache sharedImageCache]diskImageExistsWithKey:[imageArray objectAtIndex:i] completion:^(BOOL isInCache){
                            if (isInCache) {
                                SLog(@"已经下载了");
                    
                            }else{
                                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                       
                                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                       
                                }];
                                                   
                                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                                                       
                                    SLog(@"%@",[self progressStrWithSize:(double)receivedSize/expectedSize]);
                                    SLog(@"targetURL:%@",targetURL);                 
                                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                    SLog(@"单个图片下载完成");
                                                  
                                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
                                                       
                                    //让 下载的url与模型的最后一个比较，如果相同证明下载完毕。
                                    NSString *imageURLStr = [imageURL absoluteString];
                                    NSString *lastImage=[NSString stringWithFormat:@"%@",((RACChannelModel *)[self.imageArray lastObject]).icon_small3];
                                                       
                                    if ([imageURLStr isEqualToString:lastImage]) {
                                        SLog(@"下载完成");
                                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
                                                           
                                        self.imageArray=nil;
                                    }
                                                       
                                    if (error) {
                                        SLog(@"下载失败");
                                    }
                                                       
                                }];
                                     
                            }

                        }];
                          
                   }
            }else{
                             
                [[SDImageCache sharedImageCache]diskImageExistsWithKey:model.icon completion:^(BOOL isInCache) {
                    if (isInCache) {
                        SLog(@"已经下载了");

                    }else{
                        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:model.icon] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                            SLog(@"%@",[self progressStrWithSize:(double)receivedSize/expectedSize]);
                            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                SLog(@"单个图片下载完成");
                                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
                                //让 下载的url与模型的最后一个比较，如果相同证明下载完毕。
                                NSString *imageURLStr = [imageURL absoluteString];
                                NSString *lastImage=[NSString stringWithFormat:@"%@",((RACChannelModel *)[self.imageArray lastObject]).icon];
                                        
                                if ([imageURLStr isEqualToString:lastImage]) {
                                    SLog(@"下载完成");
                                       
                                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:3 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
                                               
                                    self.imageArray=nil;
                                }
                                           
                                if (error) {
                                    SLog(@"下载失败");
                                }

                            }];
                                      
                        }

                    }];
                }
            }
        }
    } failure:^(NSError *error){
        if (error.code==NSURLErrorCancelled)return;
        if (error.code==NSURLErrorTimedOut){
           
        }else{
       
        }
    }finished:nil];
}

- (void)cancelClick{
    [ZBRequestManager cancelAllRequest];//取消所有网络请求
    [[SDWebImageManager sharedManager] cancelAll];

    [self.imageArray removeAllObjects];
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, ZB_STATUS_HEIGHT+44, SCREEN_WIDTH, SCREEN_HEIGHT-(ZB_STATUS_HEIGHT+44)) style:UITableViewStylePlain];
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
    _backgroundImgV.backgroundColor=[UIColor redColor];
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
        
        [_headerImg setImage:[UIImage imageNamed:@"Andi"]];

        [_headerImg.layer setMasksToBounds:YES];
        [_headerImg.layer setCornerRadius:35];
        _headerImg.backgroundColor=[UIColor whiteColor];
        _headerImg.userInteractionEnabled=YES;
        [_headImageView addSubview:_headerImg];
        
        _headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 170,SCREEN_WIDTH-20, 20)];
        _headerlabel.text=@"https://github.com/Suzhibin/ZBNews";
        _headerlabel.textColor=[UIColor whiteColor];
        _headerlabel.textAlignment=NSTextAlignmentCenter;
        [_headImageView addSubview:_headerlabel];

    }
    return _headImageView;
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
