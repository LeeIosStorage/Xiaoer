//
//  TopicDetailsViewController.m
//  Xiaoer
//
//  Created by KID on 15/1/27.
//
//

#import "TopicDetailsViewController.h"
#import "XEShareActionSheet.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "TopicCommentViewCell.h"
#import "GMGridViewLayoutStrategies.h"
#import "GMGridViewCell+Extended.h"
#import "UIImageView+WebCache.h"
#import "XECommentInfo.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "HPGrowingTextView.h"
#import "XEAlertView.h"
#import "AppDelegate.h"
#import "XEActionSheet.h"
#import <objc/message.h>
#import "MWPhotoBrowser.h"
#import "ExpertIntroViewController.h"
#import "NSString+Value.h"

#define ONE_IMAGE_HEIGHT  93
#define item_spacing  4
#define growingTextViewMaxNumberOfLines 1

@interface TopicDetailsViewController ()<XEShareActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,GMGridViewDataSource, GMGridViewActionDelegate,HPGrowingTextViewDelegate,TopicCommentViewCellDelegate,MWPhotoBrowserDelegate>
{
    XEShareActionSheet *_shareAction;
    NSRange _textRange;
    
    int _maxReplyTextLength;
//    int _minReplyTextLength;
    XECommentInfo *_selCommentInfo;
}

@property (nonatomic, strong) XECommentInfo *expertComment;
@property (nonatomic, strong) NSMutableArray *topicComments;
@property (assign, nonatomic) int  nextCursor;
@property (assign, nonatomic) BOOL canLoadMore;
@property (strong, nonatomic) NSMutableDictionary* actionSheetIndexSelDic;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
/**
 *  headerView
 */
@property (nonatomic, strong) IBOutlet UIView *headView;
/**
 *   top View
 */
@property (strong, nonatomic) IBOutlet UIView *titleContainerView;
/**
 *  头部描述lable
 */
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
/**
 *  medium view
 */
@property (strong, nonatomic) IBOutlet UIView *contentContainerView;
/**
 *  人去头像
 */
@property (strong, nonatomic) IBOutlet UIImageView *authorAvatarImgView;
/**
 *  人物姓名 （头像右边）
 */
@property (strong, nonatomic) IBOutlet UILabel *authorNameLabel;
/**
 *  人物日期（头像右边）
 */
@property (strong, nonatomic) IBOutlet UILabel *authorHospitalLabel;
/**
 *  发表时间
 */
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
/**
 *  发表内容
 */
//@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong)UILabel *contentLabel;
/**
 *  展示图片 （描述内容下方）
 */
@property (nonatomic,strong)GMGridView *imageGridView;;
//@property (strong, nonatomic) IBOutlet GMGridView *imageGridView;
/**
 *  医生回答view
 */
@property (strong, nonatomic) IBOutlet UIView *expertCommentContainerView;
/**
 *  回答内容背景图片
 */
//@property (strong, nonatomic) IBOutlet UIImageView *expertCommentBgImgView;
/**
 *  回答内容btn
 */
@property (weak, nonatomic) IBOutlet UIButton *comContentBtn;
//@property (strong, nonatomic) IBOutlet UILabel *comContentLabel;
/**
 *  医生头像
 */
@property (strong, nonatomic) IBOutlet UIImageView *expertAvatarImgView;
/**
 *  医生姓名
 */
@property (strong, nonatomic) IBOutlet UILabel *expertNameLabel;
/**
 *  医院名称
 */
@property (strong, nonatomic) IBOutlet UILabel *expertHospitalLabel;
/**
 *  评论view
 */
@property (strong, nonatomic) IBOutlet UIView *toolbarContainerView;
/**
 *  评论输入框背景图
 */
@property (strong, nonatomic) IBOutlet UIImageView *inputViewBgImageView;
/**
 *  评论内容
 */
@property (strong, nonatomic) IBOutlet HPGrowingTextView *growingTextView;
/**
 *  评论提示label placeHolder
 */
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;
/**
 *  表情按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *expressionBtn;
/**
 *  发送按钮
 */
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
/**
 *  tableView sectionheader
 */
@property (nonatomic, strong) IBOutlet UIView *sectionView;
/**
 *  评论数量
 */
@property (nonatomic, strong) IBOutlet UIButton *commentButton;
/**
 *  收藏数量
 */
@property (nonatomic, strong) IBOutlet UIButton *collectButton;

- (IBAction)commentAction:(id)sender;
- (IBAction)collectAction:(id)sender;
- (IBAction)expressionAction:(id)sender;
/**
 *  发送评论
 */
- (IBAction)sendAction:(id)sender;
/**
 *  医生头像点击
 */
- (IBAction)expertAvatarAction:(id)sender;

@end

@implementation TopicDetailsViewController

- (void)dealloc{
    NSLog(@"delloc");
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _growingTextView.delegate = nil;
//    self.imageGridView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _topicComments = [[NSMutableArray alloc] init];
    
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.masksToBounds = YES;
    
    NSInteger spacing = item_spacing;
    self.imageGridView = [[GMGridView alloc]init];
    self.imageGridView.style = GMGridViewStyleSwap;
    self.imageGridView.itemSpacing = spacing;
    self.imageGridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.imageGridView.centerGrid = NO;
    self.imageGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
    self.imageGridView.actionDelegate = self;
    self.imageGridView.showsHorizontalScrollIndicator = NO;
    self.imageGridView.showsVerticalScrollIndicator = NO;
    self.imageGridView.dataSource = self;
    self.imageGridView.scrollsToTop = NO;
    self.imageGridView.delegate = self;
    
    _maxReplyTextLength = 1000;
    _growingTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _growingTextView.minNumberOfLines = 1;
    _growingTextView.maxNumberOfLines = growingTextViewMaxNumberOfLines;
    _growingTextView.returnKeyType = UIReturnKeySend; //just as an example
    _growingTextView.font = [UIFont systemFontOfSize:15.0f];
    _growingTextView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0);
    _growingTextView.delegate = self;
    _growingTextView.backgroundColor = [UIColor clearColor];
    _growingTextView.internalTextView.backgroundColor = [UIColor clearColor];
    self.placeHolderLabel.hidden = NO;
    
    self.commentButton.selected = YES;
    self.collectButton.selected = NO;
    
    self.nextCursor = 1;
    /**
     *  获取评论数组 内容（tableview）
     */
    [self getCommentInfos];
    /**
     *  布局headerview
     */
    [self refreshTopicInfoShow];
    
    [self getCacheTopicInfo];//cache
    [self refreshTopicInfo];
    
    CGRect fram = self.growingTextView.frame;
    fram.size.height = 35;
    self.growingTextView.frame = fram;
    
    
}


-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"话题详情"];
    [self setRightButtonWithImageName:@"more_icon" selector:@selector(moreAction:)];
}


- (void)getCacheTopicInfo{
    __weak TopicDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] addGetCacheTag:tag];
    [[XEEngine shareInstance] getTopicDetailsInfoWithTopicId:_topicInfo.tId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] getCacheReponseDicForTag:tag complete:^(NSDictionary *jsonRet){
        if (jsonRet == nil) {
            //...
        }else{
            NSDictionary *topicDic = [[jsonRet objectForKey:@"object"] dictionaryObjectForKey:@"topic"];
            [weakSelf.topicInfo setTopicInfoByJsonDic:topicDic];
            
            weakSelf.topicComments = [[NSMutableArray alloc] init];
            NSArray *comments = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"comments"];
            for (NSDictionary *dic in comments) {
                XECommentInfo *commentInfo = [[XECommentInfo alloc] init];
                [commentInfo setCommentInfoByJsonDic:dic];
                [weakSelf.topicComments addObject:commentInfo];
            }
            
            NSDictionary *exComment = [[jsonRet objectForKey:@"object"] dictionaryObjectForKey:@"expertcomment"];
            if (exComment) {
                weakSelf.expertComment = [[XECommentInfo alloc] init];
                [weakSelf.expertComment setCommentInfoByJsonDic:exComment];
            }
            
            [weakSelf refreshTopicInfoShow];
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)refreshTopicInfo{
    
    __weak TopicDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getTopicDetailsInfoWithTopicId:_topicInfo.tId uid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
//        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
        NSDictionary *topicDic = [[jsonRet objectForKey:@"object"] objectForKey:@"topic"];
        [weakSelf.topicInfo setTopicInfoByJsonDic:topicDic];
        
        weakSelf.topicComments = [[NSMutableArray alloc] init];
        NSArray *comments = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"comments"];
        for (NSDictionary *dic in comments) {
            XECommentInfo *commentInfo = [[XECommentInfo alloc] init];
            [commentInfo setCommentInfoByJsonDic:dic];
            [weakSelf.topicComments addObject:commentInfo];
        }
        
        NSDictionary *exComment = [[jsonRet objectForKey:@"object"] dictionaryObjectForKey:@"expertcomment"];
        if (exComment) {
            weakSelf.expertComment = [[XECommentInfo alloc] init];
            [weakSelf.expertComment setCommentInfoByJsonDic:exComment];
        }
        
        weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
        if (!weakSelf.canLoadMore) {
            weakSelf.tableView.showsInfiniteScrolling = NO;
        }else{
            weakSelf.tableView.showsInfiniteScrolling = YES;
            weakSelf.nextCursor ++;
        }
        
        [weakSelf refreshTopicInfoShow];
        [weakSelf.tableView reloadData];
        
    }tag:tag];
    
}

-(void)getCommentInfos{
    
    __weak TopicDetailsViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        if (!weakSelf) {
            return;
        }
        
        if (!weakSelf.canLoadMore) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            weakSelf.tableView.showsInfiniteScrolling = NO;
            return ;
        }
        
        int tag = [[XEEngine shareInstance] getConnectTag];
        [[XEEngine shareInstance] getTopicCommentListWithWithTopicId:weakSelf.topicInfo.tId pagenum:weakSelf.nextCursor tag:tag];
        [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
            if (!weakSelf) {
                return;
            }
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
            if (!jsonRet || errorMsg) {
                if (!errorMsg.length) {
                    errorMsg = @"请求失败";
                }
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
                return;
            }
//            [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
            
            NSArray *comments = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"comments"];
            for (NSDictionary *dic in comments) {
                XECommentInfo *commentInfo = [[XECommentInfo alloc] init];
                [commentInfo setCommentInfoByJsonDic:dic];
                [weakSelf.topicComments addObject:commentInfo];
            }
            
            weakSelf.canLoadMore = [[[jsonRet objectForKey:@"object"] objectForKey:@"end"] boolValue];
            if (!weakSelf.canLoadMore) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }else{
                weakSelf.tableView.showsInfiniteScrolling = YES;
                weakSelf.nextCursor ++;
            }
            [weakSelf.tableView reloadData];
            
        } tag:tag];
    }];
    
}

#pragma mark - custom
-(void)refreshTopicInfoShow{
    
    self.authorAvatarImgView.layer.cornerRadius = self.authorAvatarImgView.frame.size.width/2;
    self.authorAvatarImgView.layer.masksToBounds = YES;
    self.authorAvatarImgView.clipsToBounds = YES;
    self.authorAvatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    _inputViewBgImageView.image = [[UIImage imageNamed:@"verify_commit_bg"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
    
    [self.authorAvatarImgView sd_setImageWithURL:_topicInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_avatar_icon"]];
    self.authorNameLabel.text = _topicInfo.uname;
    self.authorHospitalLabel.text = _topicInfo.utitle;
    self.timeLabel.text = [XEUIUtils dateDiscriptionFromNowBk:_topicInfo.time];

    [self.commentButton setTitle:[NSString stringWithFormat:@"评论%d",_topicInfo.commentnum] forState:0];
    [self.collectButton setTitle:[NSString stringWithFormat:@"收藏%d",_topicInfo.favnum] forState:0];
    
    /**
     *  头
     */
    self.titleLabel.text = _topicInfo.title;

    /**
     *  中间
     */
    if (_topicInfo.content) {
        
        /**
         有中间文字
         */
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, SCREEN_WIDTH - 20, 0)];
        self.contentLabel.textColor = [UIColor darkGrayColor];
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.text = _topicInfo.content;
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
        CGRect rect = [self.contentLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        CGRect frame = self.contentLabel.frame;
        frame.size.height = rect.size.height ;
        self.contentLabel.frame = frame;
        [self.contentContainerView addSubview:self.contentLabel];
        self.contentContainerView.frame = CGRectMake(0, 40, SCREEN_WIDTH, 75 + frame.size.height + 10);
        NSLog(@"rect.size.height == %f",rect.size.height);
    }else{
        
        self.contentContainerView.frame = CGRectMake(0, 40, SCREEN_WIDTH, 75 );
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 75, SCREEN_WIDTH - 20, 0)];

    }

    
//    //图片view
    /**
     *  中间有图片
     */
    NSInteger imagesCount = self.topicInfo.picIds.count;
    if (imagesCount > 0) {
        self.imageGridView.hidden = NO;
        CGRect gridFrame = self.imageGridView.frame;
        if (self.contentLabel.frame.size.height > 0) {
            gridFrame.origin.y = 75 + self.contentLabel.frame.size.height + 20;
        }else{
            gridFrame.origin.y = 75;
        }
        int lines = (int)((imagesCount/3) + (imagesCount%3?1:0));
        CGFloat gvHeight = ONE_IMAGE_HEIGHT*lines + item_spacing*(lines - 1);
        gridFrame.size.height = gvHeight;
        gridFrame.size.width = ONE_IMAGE_HEIGHT*3 + item_spacing*2;
        gridFrame.origin.x = 15;
        self.imageGridView.itemSpacing = item_spacing;
        self.imageGridView.frame = gridFrame;
        [self.contentContainerView addSubview:self.imageGridView];
        self.contentContainerView.frame = CGRectMake(0, 40, SCREEN_WIDTH, 75 + self.contentLabel.frame.size.height + gridFrame.size.height + 30);

    }else{
        
        self.imageGridView.hidden = YES;
        self.imageGridView.frame = CGRectMake(0, 0, 0, 0);
        
    }
    
    NSLog(@"self.imageGridView==%@",NSStringFromCGRect(self.imageGridView.frame));
    NSLog(@"contentContainerView==%@",NSStringFromCGRect(self.contentContainerView.frame));

    [self.imageGridView reloadData];
    NSLog(@"self.imageGridView.frame.origin.y == %f %f %f",self.imageGridView.frame.origin.y,self.imageGridView.frame.size.height,self.contentContainerView.frame.size.height);
    
    self.expertCommentContainerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.expertCommentContainerView.hidden = YES;
    
    UIView *bottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.contentContainerView.frame.origin.y +self.contentContainerView.frame.size.height , SCREEN_WIDTH, 0)];
    UIImageView *bobImage = [[UIImageView alloc]init];
    
    bobImage.image = [[UIImage imageNamed:@"expert_comment_background"] stretchableImageWithLeftCapWidth:40 topCapHeight:48];
    //expertComment
    self.expertCommentContainerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    if (_expertComment.content) {
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH - 130, 0)];
        contentLab.numberOfLines = 0;
        contentLab.font = [UIFont systemFontOfSize:14];
        contentLab.text =  _expertComment.content;
        contentLab.textColor = [UIColor whiteColor];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
        CGRect rect = [contentLab.text boundingRectWithSize:CGSizeMake(contentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
        CGRect fram = contentLab.frame;
        fram.size.height = rect.size.height;
        contentLab.frame = fram;
        
        bobImage.frame = CGRectMake(10, 20, SCREEN_WIDTH  -100, contentLab.frame.size.height + 20);
        [bobImage addSubview:contentLab];
        
        [bottom addSubview:bobImage];
        bottom.frame = CGRectMake(0, self.contentContainerView.frame.origin.y +self.contentContainerView.frame.size.height , SCREEN_WIDTH, bobImage.frame.size.height + 50);
        
        UIImageView *expertAvatar = [[UIImageView alloc]init];
        [expertAvatar sd_setImageWithURL:_expertComment.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"topic_avatar_icon"]];
        expertAvatar.frame = CGRectMake(SCREEN_WIDTH - 22 - 50,15, 50, 50);
        expertAvatar.layer.cornerRadius = 25;
        expertAvatar.layer.masksToBounds = YES;
        [bottom addSubview:expertAvatar];
        
        expertAvatar.clipsToBounds = YES;
        expertAvatar.contentMode = UIViewContentModeScaleAspectFill;
        
        UILabel *hospital = [[UILabel alloc]init];
        hospital.text = _expertComment.title;
        hospital.textColor = [UIColor darkGrayColor];
        hospital.frame = CGRectMake(SCREEN_WIDTH - 100, 55, 100, 40);
        hospital.numberOfLines = 2;
        hospital.font = [UIFont systemFontOfSize:13];
        hospital.textAlignment = NSTextAlignmentCenter;
        [bottom addSubview:hospital];
        
        UIButton *showExpect = [UIButton buttonWithType:UIButtonTypeCustom];
        [showExpect addTarget:self action:@selector(showExpectDetail) forControlEvents:UIControlEventTouchUpInside];
        showExpect.backgroundColor = [UIColor clearColor];
        showExpect.frame = CGRectMake(SCREEN_WIDTH - 100, 15, 100, 100);
        [bottom addSubview:showExpect];
        

        
    }else{
        bottom.frame = CGRectMake(0, self.contentContainerView.frame.origin.y +self.contentContainerView.frame.size.height , 0,0);
    }
    
    NSLog(@"bottom%@",NSStringFromCGRect(bottom.frame));


    
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.titleContainerView.frame.size.height + self.contentContainerView.frame.size.height + bottom.frame.size.height +20);
    [self.headView addSubview:bottom];
    NSLog(@"headView%@",NSStringFromCGRect(self.headView.frame));
    self.tableView.tableHeaderView = self.headView;
    [self.tableView reloadData];
}
- (void)showExpectDetail{
    NSLog(@"分过");
    XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
    doctorInfo.doctorId = _expertComment.uId;
    doctorInfo.doctorName = _expertComment.userName;
    doctorInfo.avatar = _expertComment.avatar;
    doctorInfo.title = _expertComment.title;
    ExpertIntroViewController *vc = [[ExpertIntroViewController alloc] init];
    vc.doctorInfo = doctorInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)moreAction:(id)sender{

    _shareAction = [[XEShareActionSheet alloc] init];
    _shareAction.owner = self;
    _shareAction.selectShareType = XEShareType_Topic;
    _shareAction.topicInfo = _topicInfo;
    [_shareAction showShareAction];
    
}
- (IBAction)commentAction:(id)sender {
    if (self.commentButton.selected) {
        return;
    }
    self.commentButton.selected = !self.commentButton.selected;
    self.collectButton.selected = !self.collectButton.selected;
}

- (IBAction)collectAction:(id)sender {
    if (self.collectButton.selected) {
        return;
    }
    self.commentButton.selected = !self.commentButton.selected;
    self.collectButton.selected = !self.collectButton.selected;
}

- (IBAction)expressionAction:(id)sender {
    if ([_growingTextView isFirstResponder]) {
        [_growingTextView resignFirstResponder];
    }
}

- (IBAction)sendAction:(id)sender {
    [self commitComment];
}

- (IBAction)expertAvatarAction:(id)sender {
    XEDoctorInfo *doctorInfo = [[XEDoctorInfo alloc] init];
    doctorInfo.doctorId = _expertComment.uId;
    doctorInfo.doctorName = _expertComment.userName;
    doctorInfo.avatar = _expertComment.avatar;
    doctorInfo.title = _expertComment.title;
    ExpertIntroViewController *vc = [[ExpertIntroViewController alloc] init];
    vc.doctorInfo = doctorInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)commitComment{
    if ([[XEEngine shareInstance] needUserLogin:nil]) {
        return;
    }
    NSString *content = _growingTextView.text;
    if (content.length == 0) {
        return;
    }
    if (!self.sendButton.enabled) {
        return;
    }
    self.sendButton.enabled = NO;
    __weak TopicDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] commitCommentTopicWithTopicId:_topicInfo.tId uid:[XEEngine shareInstance].uid content:content tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        self.sendButton.enabled = YES;
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"] At:weakSelf.view];
        
        NSDictionary *dic = [jsonRet objectForKey:@"object"];
        XECommentInfo *commentInfo = [[XECommentInfo alloc] init];
        [commentInfo setCommentInfoByJsonDic:dic];
        [weakSelf.topicComments insertObject:commentInfo atIndex:0];
        
        [weakSelf.tableView reloadData];
        [weakSelf growingTextViewResignFirstResponder];
        _topicInfo.commentnum ++;
        [self refreshTopicInfoShow];
        [self.tableView setContentOffset:CGPointMake(0, 0 - self.tableView.contentInset.top) animated:YES];
        
    } tag:tag];
    
}

-(void)doDeleteCommentSheetAction{
    
    __weak TopicDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] deleteCommentTopicWithCommentId:_selCommentInfo.cId uid:[XEEngine shareInstance].uid topicId:_topicInfo.tId tag:tag];
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
        
        weakSelf.topicInfo.clicknum --;
        _topicInfo.commentnum--;
//        [weakSelf ]
        [weakSelf.topicComments removeObject:_selCommentInfo];
        [weakSelf refreshTopicInfoShow];
        [weakSelf.tableView reloadData];
        
    } tag:tag];
    
}

-(void)growingTextViewResignFirstResponder{
    if ([_growingTextView isFirstResponder]) {
        [_growingTextView resignFirstResponder];
    }
    _growingTextView.text = nil;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController * menuCtl = ((AppDelegate *)[UIApplication sharedApplication].delegate).appMenu;
    BOOL bSameMenuInst = menuCtl == sender;
    
    if (action == @selector(doDeleteCommentSheetAction))
    {
        if (bSameMenuInst) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - NSNotification
-(void) keyboardWillShow:(NSNotification *)note{
    
//    // get keyboard size and loctaion
//    CGRect keyboardBounds;
//    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    // Need to translate the bounds to account for rotation.
//    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
//    
//    // get a rect for the textView frame
//    CGRect toolbarFrame = _toolbarContainerView.frame;
//    
//    CGRect tableViewFrame = _tableView.frame;
//    tableViewFrame.size.height = self.view.bounds.size.height - keyboardBounds.size.height - toolbarFrame.size.height;
//    _tableView.frame = tableViewFrame;
//    
//    CGPoint offset = _tableView.contentOffset;
//    
//    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//    
//    toolbarFrame.origin.y = self.view.bounds.size.height - keyboardBounds.size.height - toolbarFrame.size.height;
//    _toolbarContainerView.frame = toolbarFrame;
//    
//    if (_tableView.contentSize.height > _tableView.frame.size.height) {
//        offset = CGPointMake(0, _tableView.contentSize.height -  _tableView.frame.size.height);
//        _tableView.contentOffset = offset;
//    }
//    
//    // commit animations
//    [UIView commitAnimations];
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect keyBoardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(keyBoardFrame));
    CGFloat transFormY = keyBoardFrame.size.height ;
    [UIView animateWithDuration:duration animations:^{
        self.toolbarContainerView.transform = CGAffineTransformMakeTranslation(0,  -transFormY);
    } completion:^(BOOL finished) {
    }];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
//    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//    
//    // get a rect for the textView frame
//    
//    CGRect toolbarFrame = _toolbarContainerView.frame;
//    
//    CGRect tableViewFrame = _tableView.frame;
//    tableViewFrame.size.height = self.view.bounds.size.height - toolbarFrame.size.height;
//    
//    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
//    
//    toolbarFrame.origin.y = self.view.bounds.size.height - toolbarFrame.size.height;
//    _toolbarContainerView.frame = toolbarFrame;
//    
//    _tableView.frame = tableViewFrame;
//    
//    // commit animations
//    [UIView commitAnimations];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect keyBoardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat transFormY = keyBoardFrame.size.height ;
    [UIView animateWithDuration:duration animations:^{
                self.toolbarContainerView.transform = CGAffineTransformMakeTranslation(0, transFormY-keyBoardFrame.size.height);

    } completion:^(BOOL finished) {
    }];
}

#pragma mark -HPGrowingTextViewDelegate
#define MAX_REPLY_TEXT_LENGTH 256
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    
    if (growingTextView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
        [_sendButton setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        self.placeHolderLabel.hidden = YES;
        [_sendButton setBackgroundColor:SKIN_COLOR];
    }
    return YES;
}
- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView{
    
    if (_growingTextView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
        [_sendButton setBackgroundColor:[UIColor lightGrayColor]];
    }else{
        self.placeHolderLabel.hidden = YES;
        [_sendButton setBackgroundColor:SKIN_COLOR];
    }
    _textRange = growingTextView.selectedRange;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    NSLog(@"height == %f  %f",height,growingTextView.frame.size.height);
    float diff = (growingTextView.frame.size.height - height);
    NSLog(@"diff== %f",diff);
//    CGRect r = _toolbarContainerView.frame;
//    r.size.height -= diff;
//    r.origin.y += diff;
//    _toolbarContainerView.frame = r;
//    
//    
//    
//    CGRect growFrame = growingTextView.frame;
//    growFrame.size.height = r.size.height;
//    growingTextView.frame = growFrame;

}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    _textRange = growingTextView.selectedRange;
    if (growingTextView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
        [_sendButton setBackgroundColor:SKIN_COLOR];
    } else {
        self.placeHolderLabel.hidden = NO;
        [_sendButton setBackgroundColor:[UIColor lightGrayColor]];
    }
    if ([XECommonUtils getHanziTextNum:growingTextView.text] > _maxReplyTextLength && growingTextView.internalTextView.markedTextRange == nil) {
        growingTextView.text = [XECommonUtils getHanziTextWithText:growingTextView.text maxLength:_maxReplyTextLength];
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"评论文字不可以超过%d个字符,已截断", _maxReplyTextLength] cancelButtonTitle:@"确定"];
        
        [alertView show];
    }
}


- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([XECommonUtils getHanziTextNum:growingTextView.text] > _maxReplyTextLength) {
        
        XEAlertView *alertView = [[XEAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"评论文字不可以超过%d个字符", _maxReplyTextLength] cancelButtonTitle:@"确定"];
        [alertView show];
        
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [self sendAction:nil];
        return NO;
        
    }
    return YES;
}

- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView{
    _textRange = growingTextView.selectedRange;
}
- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView{
    [self sendAction:nil];
    return YES;
}

#pragma mark - GMGridViewDataSource
- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return _topicInfo.picIds.count;
    
}
- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation {
    
    return CGSizeMake(ONE_IMAGE_HEIGHT, ONE_IMAGE_HEIGHT);
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        UIImageView* imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        cell.contentView = imageView;
        
    }
    UIImageView* imageView = (UIImageView* )cell.contentView;
    NSString *imgName = @"topic_load_icon";
    [imageView sd_setImageWithURL:[self.topicInfo.picURLs objectAtIndex:index] placeholderImage:[UIImage imageNamed:imgName]];
    return cell;
}
#pragma mark GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
//    NSLog(@"Did tap at index %ld", position);
//    NSString *url = [self.topicInfo.picURLs objectAtIndex:position];
//    XELog(@"url===%@",url);
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:position];
    [self.navigationController pushViewController:browser animated:YES];
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
//    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:nc animated:YES completion:nil];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.topicInfo.picIds.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSArray* picUrls = self.topicInfo.originalPicURLs;
    if (index < picUrls.count){
        MWPhoto* mwPhoto = [[MWPhoto alloc] initWithURL:[picUrls objectAtIndex:index]];
        return mwPhoto;
    }
    return nil;
}

//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
//    if (index < _thumbs.count)
//        return [_thumbs objectAtIndex:index];
//    return nil;
//}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([_growingTextView isFirstResponder]) {
        [_growingTextView resignFirstResponder];
    }
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _topicComments.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XECommentInfo *commentInfo = _topicComments[indexPath.row];
    return [TopicCommentViewCell heightForCommentInfo:commentInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TopicCommentViewCell";
    TopicCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        cell.delegate = self;
//        cell.backgroundColor = [UIColor clearColor];
    }
    XECommentInfo *commentInfo = _topicComments[indexPath.row];
    cell.commentInfo = commentInfo;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath* selIndexPath = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selIndexPath animated:YES];
    
    XECommentInfo* commentInfo = [_topicComments objectAtIndex:indexPath.row];
    _selCommentInfo = commentInfo;
    
    NSString* myUid = [[XEEngine shareInstance] userInfo].uid;
    
    if ([commentInfo.uId isEqualToString:myUid]) {
        _actionSheetIndexSelDic = [[NSMutableDictionary alloc] init];
        
        __weak TopicDetailsViewController *weakSelf = self;
        XEActionSheet *sheet = [[XEActionSheet alloc] initWithTitle:nil actionBlock:^(NSInteger buttonIndex) {
            SEL sel = NSSelectorFromString([weakSelf.actionSheetIndexSelDic objectForKey:[NSNumber numberWithInt:(int)buttonIndex]]);
            if ([weakSelf respondsToSelector:sel]) {
                objc_msgSend(self, sel);
            }
        }];
        [_actionSheetIndexSelDic setObject:@"doDeleteCommentSheetAction" forKey:[NSNumber numberWithInt:(int)sheet.numberOfButtons]];
        [sheet addButtonWithTitle:@"删除"];
        sheet.destructiveButtonIndex = sheet.numberOfButtons - 1;
        
        [sheet addButtonWithTitle:@"取消"];
        sheet.cancelButtonIndex = sheet.numberOfButtons -1;
        [sheet showInView:self.view];
    }
}

#pragma mark -TopicCommentViewCellDelegate
- (void)topicCommentCellCommentLongPressWithCell:(TopicCommentViewCell*)cell;{
    
    if ([_growingTextView isFirstResponder]) {
        [_growingTextView resignFirstResponder];
    }
    
    [self becomeFirstResponder];
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    XECommentInfo *commentInfo = _topicComments[indexPath.row];
    
    UIMenuController * menuCtl = ((AppDelegate *)[UIApplication sharedApplication].delegate).appMenu;
    NSArray *popMenuItems = nil;
    
    NSString* myUid = [[XEEngine shareInstance] userInfo].uid;
    if ([commentInfo.uId isEqualToString:myUid]) {
        popMenuItems = [NSArray arrayWithObjects:[[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(doDeleteCommentSheetAction)], nil];
    }
//    else{
//        popMenuItems = [NSArray arrayWithObjects:[[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyReplyTextAction:)], nil];
//    }
    _selCommentInfo = commentInfo;
    
    [menuCtl setMenuVisible:NO];
    [menuCtl setMenuItems:popMenuItems];
    [menuCtl setArrowDirection:UIMenuControllerArrowDown];
    
    CGRect showRect = cell.frame;
    showRect.origin.y += 30;
    [menuCtl setTargetRect:showRect inView:self.tableView];
    [menuCtl setMenuVisible:YES animated:YES];
}

#pragma mark - XEShareActionSheetDelegate
-(void) deleteTopicAction:(id)info{
    if ([self.delegate respondsToSelector:@selector(topicDetailViewController:deleteTopic:)]) {
        [self.delegate topicDetailViewController:self deleteTopic:info];
        [super backAction:nil];
    }
}

@end
