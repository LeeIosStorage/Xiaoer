//
//  ExpertIntroViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/15.
//
//

#import "ExpertIntroViewController.h"
#import "XECateTopicViewCell.h"
#import "UIImageView+WebCache.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XETopicInfo.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "XEPublicViewController.h"
#import "XEShareActionSheet.h"
#import "TopicDetailsViewController.h"

#import "ExpextPublicController.h"

@interface ExpertIntroViewController () <UITableViewDelegate,UITableViewDataSource,XEShareActionSheetDelegate,UIWebViewDelegate>
{
    XEShareActionSheet *_shareAction;
}
@property (assign, nonatomic) int  nextCursor;
@property (assign, nonatomic) BOOL canLoadMore;
//@property (nonatomic, strong) NSMutableArray *doctorTopics;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) IBOutlet UIView *headView;
/**
 *  人物头像
 */
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
/**
 *  点赞数量
 */
@property (strong, nonatomic) IBOutlet UILabel *hotLabel;
/**
 *  医生姓名
 */
@property (strong, nonatomic) IBOutlet UILabel *doctorNameLabel;
/**
 *  医院名称
 */
@property (strong, nonatomic) IBOutlet UILabel *doctorCollegeLabel;


/**
 *  话题
 */
@property (strong, nonatomic) IBOutlet UIButton *topicButton;
/**
 *  粉丝
 */
@property (strong, nonatomic) IBOutlet UIButton *fansButton;

@property (nonatomic, strong) IBOutlet UIView *sectionView;
@property (strong, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UIButton *askBtn;

- (IBAction)consultAction:(id)sender;
- (IBAction)topicAction:(id)sender;
- (IBAction)fansAction:(id)sender;
@end

@implementation ExpertIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    self.askBtn.layer.cornerRadius = 5;
    self.askBtn.layer.masksToBounds = YES;
    
    
    [self refreshDoctorInfoShow];
    //网页加载
    NSString *url = [NSString stringWithFormat:@"%@/expert/detailh5?expertid=%@",[[XEEngine shareInstance] baseUrl],_doctorInfo.doctorId];
//    NSString *url = [NSString stringWithFormat:@"%@/goods/h5detail/%@",[[XEEngine shareInstance] baseUrl],@"1"];

    NSLog(@"url == %@",url);
    [self loadWebViewWithUrl:[NSURL URLWithString:url]];
    
    
//    [self getCacheExpertInfo];//cache
//    [self refreshExpertInfo];
//    
//    [self getCacheTopicList];
//    [self getExpertTopicList];
    
    
//    __weak ExpertIntroViewController *weakSelf = self;
//    [self.tableView addInfiniteScrollingWithActionHandler:^{
//        if (!weakSelf) {
//            return;
//        }
//        if (!weakSelf.canLoadMore) {
//            [weakSelf.tableView.infiniteScrollingView stopAnimating];
//            weakSelf.tableView.showsInfiniteScrolling = NO;
//            return ;
//        }
//        
//        int tag = [[XEEngine shareInstance] getConnectTag];
//        [[XEEngine shareInstance] getMyPublishTopicListWithUid:weakSelf.doctorInfo.doctorId page:weakSelf.nextCursor tag:tag];
//        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//            if (!weakSelf) {
//                return;
//            }
//            [weakSelf.tableView.infiniteScrollingView stopAnimating];
//            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//            if (!jsonRet || errorMsg) {
//                if (!errorMsg.length) {
//                    errorMsg = @"请求失败";
//                }
//                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
//                return;
//            }
//            
//            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"pubs"];
//            for (NSDictionary *dic in object) {
//                XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
//                [topicInfo setTopicInfoByJsonDic:dic];
//                [weakSelf.doctorTopics addObject:topicInfo];
//            }
//            
//            weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
//            if (!weakSelf.canLoadMore) {
//                weakSelf.tableView.showsInfiniteScrolling = NO;
//            }else{
//                weakSelf.tableView.showsInfiniteScrolling = YES;
//                weakSelf.nextCursor ++;
//            }
//            [weakSelf.tableView reloadData];
//            
//        } tag:tag];
//    }];
    
}
#pragma mark  web delegate

- (void)loadWebViewWithUrl:(NSURL *)url {
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    [XEProgressHUD AlertLoading:@"正在加载"];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [XEProgressHUD AlertSuccess:@"加载成功"];
    CGRect frame = self.footerView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    self.footerView.frame = frame;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView reloadData];
    
}


-(void)initNormalTitleNavBarSubviews{
    [self setTitle:@"专家介绍"];
    [self setRightButtonWithImageName:@"more_icon" selector:@selector(collectAction:)];
    
//    [self setRight2ButtonWithImageName:@"share_icon" selector:@selector(shareAction:)];
}



//- (void)getCacheExpertInfo{
//    __weak ExpertIntroViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] addGetCacheTag:tag];
//    [[XEEngine shareInstance] getExpertDetailWithUid:[XEEngine shareInstance].uid expertId:_doctorInfo.doctorId tag:tag];
//    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
//        if (jsonRet == nil) {
//            //...
//        }else{
//            NSDictionary *expertDic = [jsonRet dictionaryObjectForKey:@"object"];
//            [_doctorInfo setDoctorInfoByJsonDic:expertDic];
//            [weakSelf refreshDoctorInfoShow];
//            [weakSelf.tableView reloadData];
//        }
//    }];
//}
//
//- (void)getCacheTopicList{
//    __weak ExpertIntroViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] addGetCacheTag:tag];
//    [[XEEngine shareInstance] getMyPublishTopicListWithUid:_doctorInfo.doctorId page:1 tag:tag];
//    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
//        if (jsonRet == nil) {
//            //...
//        }else{
//            weakSelf.doctorTopics = [[NSMutableArray alloc] init];
//            NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"pubs"];
//            for (NSDictionary *dic in object) {
//                XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
//                [topicInfo setTopicInfoByJsonDic:dic];
//                [weakSelf.doctorTopics addObject:topicInfo];
//            }
//            [weakSelf refreshDoctorInfoShow];
//            [weakSelf.tableView reloadData];
//        }
//    }];
//}

//- (void)refreshExpertInfo{
//    
//    __weak ExpertIntroViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] getExpertDetailWithUid:[XEEngine shareInstance].uid expertId:_doctorInfo.doctorId tag:tag];
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            if (!errorMsg.length) {
//                errorMsg = @"请求失败";
//            }
//            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
//            return;
//        }
////        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
//        
//        NSDictionary *expertDic = [jsonRet objectForKey:@"object"];
//        [_doctorInfo setDoctorInfoByJsonDic:expertDic];
//        
//        
////        weakSelf.doctorTopics = [[NSMutableArray alloc] init];
////        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"topics"];
////        for (NSDictionary *dic in object) {
////            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
////            [topicInfo setTopicInfoByJsonDic:dic];
////            [weakSelf.doctorTopics addObject:topicInfo];
////        }
//        [weakSelf refreshDoctorInfoShow];
//        [weakSelf.tableView reloadData];
//        
//    }tag:tag];
//}

//-(void)getExpertTopicList{
//    
//    _nextCursor = 1;
//    __weak ExpertIntroViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] getMyPublishTopicListWithUid:_doctorInfo.doctorId page:_nextCursor tag:tag];
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            if (!errorMsg.length) {
//                errorMsg = @"请求失败";
//            }
//            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
//            return;
//        }
////        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
//        
//        weakSelf.doctorTopics = [[NSMutableArray alloc] init];
//        NSArray *object = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"pubs"];
//        for (NSDictionary *dic in object) {
//            XETopicInfo *topicInfo = [[XETopicInfo alloc] init];
//            [topicInfo setTopicInfoByJsonDic:dic];
//            [weakSelf.doctorTopics addObject:topicInfo];
//        }
//        
//        weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
//        if (!weakSelf.canLoadMore) {
//            weakSelf.tableView.showsInfiniteScrolling = NO;
//        }else{
//            weakSelf.tableView.showsInfiniteScrolling = YES;
//            weakSelf.nextCursor ++;
//        }
//        
//        [weakSelf refreshDoctorInfoShow];
//        [weakSelf.tableView reloadData];
//        
//    }tag:tag];
//}

#pragma mark - Judge
-(BOOL)isCollect{
    if (_doctorInfo.faved != 0) {
        return YES;
    }
    return NO;
}

#pragma mark - custom
-(void)refreshDoctorInfoShow{
    
//    if (![self isCollect]) {
//        [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_un_icon"] forState:UIControlStateNormal];
//    }else{
//        [self.titleNavBarRightBtn setImage:[UIImage imageNamed:@"nav_collect_icon"] forState:UIControlStateNormal];
//    }
    self.topicLabel.text = @"她的话题";
    
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatarImageView sd_setImageWithURL:_doctorInfo.largeAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_load_icon"]];
    
    
    float titleLength = [XECommonUtils widthWithText:_doctorInfo.title font:_doctorNameLabel.font lineBreakMode:NSLineBreakByCharWrapping]/16;
    float maxTitleWidth = SCREEN_WIDTH-64-[XECommonUtils widthWithText:_doctorInfo.doctorName font:_doctorNameLabel.font lineBreakMode:NSLineBreakByCharWrapping]-[XECommonUtils widthWithText:[NSString stringWithFormat:@"%d岁",_doctorInfo.age] font:_doctorNameLabel.font lineBreakMode:NSLineBreakByCharWrapping];
    int maxTitleLength = maxTitleWidth/16;
    NSString *title = _doctorInfo.title;
    if (titleLength > maxTitleLength) {
        title = [NSString stringWithFormat:@"%@...",[XECommonUtils getHanziTextWithText:_doctorInfo.title maxLength:maxTitleLength-1]];
    }
    
    self.doctorNameLabel.text = [NSString stringWithFormat:@"%@ %@ %d岁",_doctorInfo.doctorName,title,_doctorInfo.age];
    self.doctorCollegeLabel.text = _doctorInfo.hospital;

    [self.topicButton setTitle:[NSString stringWithFormat:@"话题%d",_doctorInfo.topicnum] forState:0];
    [self.fansButton setTitle:[NSString stringWithFormat:@"粉丝%d",_doctorInfo.favnum] forState:0];
    self.hotLabel.text = [NSString stringWithFormat:@"%d",_doctorInfo.popularscore];
    
    UILabel *desLable  = [[UILabel alloc]initWithFrame:CGRectMake(15,  243, SCREEN_WIDTH - 30, 0)];
    desLable.backgroundColor = [UIColor whiteColor];
    desLable.numberOfLines = 0;
    desLable.font = [UIFont systemFontOfSize:15];
    
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil];
    desLable.text = [NSString stringWithFormat:@"     %@ \n \n     %@",_doctorInfo.professional,_doctorInfo.des];
    
    CGRect rect = [desLable.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    
    CGRect desFrame = desLable.frame;
    desFrame.size.height = rect.size.height ;
    desLable.frame = desFrame;
    
    self.headView.frame  = CGRectMake(0, 0, SCREEN_WIDTH, 243 + rect.size.height + 10);
    [self.headView addSubview:desLable];
    

    
    self.tableView.tableHeaderView = self.headView;
}

-(void)collectAction:(id)sender{
    
//    if ([[XEEngine shareInstance] needUserLogin:nil]) {
//        return;
//    }
    _shareAction = [[XEShareActionSheet alloc] init];
    _shareAction.owner = self;
    _shareAction.selectShareType = XEShareType_Expert;
    _shareAction.doctorInfo = _doctorInfo;
    [_shareAction showShareAction];
    
//    __weak ExpertIntroViewController *weakSelf = self;
//    int tag = [[XEEngine shareInstance] getConnectTag];
//    if ([self isCollect]) {
//        [[XEEngine shareInstance] unCollectExpertWithExpertId:_doctorInfo.doctorId uid:[XEEngine shareInstance].uid tag:tag];
//    }else{
//        [[XEEngine shareInstance] collectExpertWithExpertId:_doctorInfo.doctorId uid:[XEEngine shareInstance].uid tag:tag];
//    }
//    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
//        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
//        if (!jsonRet || errorMsg) {
//            if (!errorMsg.length) {
//                errorMsg = @"请求失败";
//            }
//            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
//            return;
//        }
//        if ([self isCollect]) {
//            _doctorInfo.faved = 0;
//        }else{
//            _doctorInfo.faved = 1;
//        }
//        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
//        
//        [weakSelf refreshDoctorInfoShow];
//        [weakSelf.tableView reloadData];
//        
//    }tag:tag];
    
}

-(void)shareAction:(id)sender{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    __weak ExpertIntroViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] shareExpertWithExpertId:_doctorInfo.doctorId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
}

- (IBAction)consultAction:(id)sender {
    NSLog(@"123");
//    XEPublicViewController *vc = [[XEPublicViewController alloc] init];
//    vc.publicType = Public_Type_Expert;
//    vc.doctorInfo = _doctorInfo;
//    [self.navigationController pushViewController:vc animated:YES];
    ExpextPublicController *public = [[ExpextPublicController alloc]init];
    public.publicType = publicExpert;
    public.doctorInfo =self.doctorInfo;
    [self.navigationController pushViewController:public animated:YES];
}

- (IBAction)topicAction:(id)sender {
    
}

- (IBAction)fansAction:(id)sender {
    
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return self.sectionView.frame.size.height;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    return self.sectionView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    XETopicInfo *topicInfo = _doctorTopics[indexPath.row];
//    return [XECateTopicViewCell heightForTopicInfo:topicInfo];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"XECateTopicViewCell";
    XECateTopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
    }
//    XETopicInfo *topicInfo = _doctorTopics[indexPath.row];
//    cell.topicInfo = topicInfo;
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
//    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
//    
//    XETopicInfo *topicInfo = _doctorTopics[indexPath.row];
//    TopicDetailsViewController *topicVc = [[TopicDetailsViewController alloc] init];
//    topicVc.topicInfo = topicInfo;
//    [self.navigationController pushViewController:topicVc animated:YES];
//}

@end
