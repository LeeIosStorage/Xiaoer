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

#define ONE_IMAGE_HEIGHT  93
#define item_spacing  4
#define growingTextViewMaxNumberOfLines 3

@interface TopicDetailsViewController ()<XEShareActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,GMGridViewDataSource, GMGridViewActionDelegate,HPGrowingTextViewDelegate>
{
    XEShareActionSheet *_shareAction;
    NSRange _textRange;
    
    int _maxReplyTextLength;
//    int _minReplyTextLength;
}

@property (nonatomic, strong) XECommentInfo *expertComment;
@property (nonatomic, strong) NSMutableArray *topicComments;
@property (assign, nonatomic) int  nextCursor;
@property (assign, nonatomic) BOOL canLoadMore;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *titleContainerView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *contentContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *authorAvatarImgView;
@property (strong, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorHospitalLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet GMGridView *imageGridView;
@property (strong, nonatomic) IBOutlet UIView *expertCommentContainerView;
@property (strong, nonatomic) IBOutlet UIImageView *expertCommentBgImgView;
@property (strong, nonatomic) IBOutlet UILabel *comContentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *expertAvatarImgView;
@property (strong, nonatomic) IBOutlet UILabel *expertNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *expertHospitalLabel;

@property (strong, nonatomic) IBOutlet UIView *toolbarContainerView;
@property (strong, nonatomic) IBOutlet HPGrowingTextView *growingTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (strong, nonatomic) IBOutlet UIButton *expressionBtn;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property (nonatomic, strong) IBOutlet UIView *sectionView;
@property (nonatomic, strong) IBOutlet UIButton *commentButton;
@property (nonatomic, strong) IBOutlet UIButton *collectButton;

- (IBAction)commentAction:(id)sender;
- (IBAction)collectAction:(id)sender;
- (IBAction)expressionAction:(id)sender;
- (IBAction)sendAction:(id)sender;

@end

@implementation TopicDetailsViewController

- (void)dealloc{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _growingTextView.delegate = nil;
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
    _imageGridView.style = GMGridViewStyleSwap;
    _imageGridView.itemSpacing = spacing;
    _imageGridView.minEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _imageGridView.centerGrid = NO;
    _imageGridView.layoutStrategy = [GMGridViewLayoutStrategyFactory strategyFromType:GMGridViewLayoutVertical];
    _imageGridView.actionDelegate = self;
    _imageGridView.showsHorizontalScrollIndicator = NO;
    _imageGridView.showsVerticalScrollIndicator = NO;
    _imageGridView.dataSource = self;
    _imageGridView.scrollsToTop = NO;
    _imageGridView.delegate = self;
    
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
    
    [self refreshTopicInfoShow];
    [self refreshTopicInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNormalTitleNavBarSubviews{
    
    [self setTitle:@"话题详情"];
    [self setRightButtonWithImageName:@"nav_collect_un_icon" selector:@selector(moreAction:)];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
        NSDictionary *topicDic = [[jsonRet objectForKey:@"object"] objectForKey:@"topic"];
        [weakSelf.topicInfo setTopicInfoByJsonDic:topicDic];
        
//        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
//        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
//        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
//        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
//        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
//        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
//        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
//        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
        
        weakSelf.topicComments = [[NSMutableArray alloc] init];
        NSArray *comments = [[jsonRet objectForKey:@"object"] objectForKey:@"comments"];
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
                [XEProgressHUD AlertError:errorMsg];
                return;
            }
            [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
            
            NSArray *comments = [[jsonRet objectForKey:@"object"] objectForKey:@"comments"];
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
    
    self.expertAvatarImgView.layer.cornerRadius = self.expertAvatarImgView.frame.size.width/2;
    self.expertAvatarImgView.layer.masksToBounds = YES;
    self.expertAvatarImgView.clipsToBounds = YES;
    self.expertAvatarImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.expertCommentBgImgView.image = [[UIImage imageNamed:@"expert_comment_background"] stretchableImageWithLeftCapWidth:2 topCapHeight:1];
    
    [self.authorAvatarImgView sd_setImageWithURL:_topicInfo.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"user_avatar_default"]];
    self.authorNameLabel.text = _topicInfo.userName;
    self.authorHospitalLabel.text = _topicInfo.utitle;
    
    [self.commentButton setTitle:[NSString stringWithFormat:@"评论%d",_topicInfo.clicknum] forState:0];
    [self.collectButton setTitle:[NSString stringWithFormat:@"收藏%d",_topicInfo.favnum] forState:0];
    
    self.titleLabel.text = _topicInfo.title;
    CGSize textSize = [XECommonUtils sizeWithText:_topicInfo.title font:self.titleLabel.font width:SCREEN_WIDTH-13*2];
    CGRect frame = self.titleContainerView.frame;
    frame.size.height = (textSize.height + 5 + 5);
    self.titleContainerView.frame = frame;
    
    self.contentLabel.text = _topicInfo.content;
    self.contentLabel.hidden = NO;
    if (_topicInfo.content.length == 0) {
        self.contentLabel.hidden = YES;
    }
    textSize = [XECommonUtils sizeWithText:_topicInfo.content font:self.contentLabel.font width:SCREEN_WIDTH-13*2];
    frame = self.contentLabel.frame;
    frame.size.height = textSize.height;
    self.contentLabel.frame = frame;
    
    //图片view
    NSInteger imagesCount = self.topicInfo.picIds.count;
    if (imagesCount > 0) {
        self.imageGridView.hidden = NO;
        CGRect gridFrame = self.imageGridView.frame;
        gridFrame.origin.y = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + 6;
        if (self.contentLabel.hidden) {
            gridFrame.origin.y = self.contentLabel.frame.origin.y;
        }
        int lines = (int)((imagesCount/3) + (imagesCount%3?1:0));
        CGFloat gvHeight = ONE_IMAGE_HEIGHT*lines + item_spacing*(lines - 1);
        gridFrame.size.height = gvHeight;
        gridFrame.size.width = ONE_IMAGE_HEIGHT*3 + item_spacing*2;
        self.imageGridView.itemSpacing = item_spacing;
        
        self.imageGridView.frame = gridFrame;
        
    }else{
        self.imageGridView.hidden = YES;
    }
    [self.imageGridView reloadData];
    
    //content View
    frame = self.contentContainerView.frame;
    frame.origin.y = self.titleContainerView.frame.origin.y + self.titleContainerView.frame.size.height;
    if (!self.imageGridView.hidden) {
        frame.size.height = self.imageGridView.frame.origin.y + self.imageGridView.frame.size.height;
    }else{
        frame.size.height = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height;
    }
    self.contentContainerView.frame = frame;
    
    CGFloat headHeight = self.contentContainerView.frame.origin.y + self.contentContainerView.frame.size.height;
    
    //expertComment
    if (_expertComment.content) {
        
        [self.expertAvatarImgView sd_setImageWithURL:_expertComment.smallAvatarUrl placeholderImage:[UIImage imageNamed:@"user_avatar_default"]];
        self.expertNameLabel.text = _expertComment.userName;
        self.expertHospitalLabel.text = _expertComment.title;
        
        self.comContentLabel.text = _expertComment.content;
        textSize = [XECommonUtils sizeWithText:_expertComment.content font:self.comContentLabel.font width:SCREEN_WIDTH-100];
        frame = self.comContentLabel.frame;
        frame.size.height = textSize.height;
        self.comContentLabel.frame = frame;
        
        self.expertCommentContainerView.hidden = NO;
        frame = self.expertCommentContainerView.frame;
        frame.origin.y = self.contentContainerView.frame.origin.y + self.contentContainerView.frame.size.height + 10;
        frame.size.height = self.comContentLabel.frame.origin.y + self.comContentLabel.frame.size.height + 8;
        if (frame.size.height < 90) {
            frame.size.height = 90;
        }
        self.expertCommentContainerView.frame = frame;
        
        headHeight += (self.expertCommentContainerView.frame.size.height + 10);
    }else{
        self.expertCommentContainerView.hidden = YES;
        headHeight +=10;
    }
    
    
    //head view
    frame = self.headView.frame;
    frame.size.height = headHeight + 7;
    self.headView.frame = frame;
    
    self.tableView.tableHeaderView = self.headView;
}

-(void)moreAction:(id)sender{
    _shareAction = [[XEShareActionSheet alloc] init];
    _shareAction.owner = self;
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
}

- (IBAction)sendAction:(id)sender {
    [self commitComment];
}

-(void)commitComment{
    
    NSString *content = _growingTextView.text;
    if (content.length == 0) {
        return;
    }
    __weak TopicDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] commitCommentTopicWithTopicId:_topicInfo.tId uid:[XEEngine shareInstance].uid content:content tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        [XEProgressHUD AlertSuccess:[jsonRet stringObjectForKey:@"result"]];
        
        NSDictionary *dic = [jsonRet objectForKey:@"object"];
        XECommentInfo *commentInfo = [[XECommentInfo alloc] init];
        [commentInfo setCommentInfoByJsonDic:dic];
        commentInfo.cId = [dic stringObjectForKey:@"id"];
        commentInfo.uId = [dic stringObjectForKey:@"userId"];
        commentInfo.userName = [XEEngine shareInstance].userInfo.nickName;
        commentInfo.avatar = [XEEngine shareInstance].userInfo.avatar;
        
        id objectForKey = [dic objectForKey:@"time"];
        if (objectForKey && [objectForKey isKindOfClass:[NSString class]]) {
            NSDateFormatter *dateFormatter = [XEUIUtils dateFormatterOFUS];
            commentInfo.time = [dateFormatter dateFromString:objectForKey];
        }
        [weakSelf.topicComments addObject:commentInfo];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf growingTextViewResignFirstResponder];
        
    } tag:tag];
    
}

-(void)growingTextViewResignFirstResponder{
    if ([_growingTextView isFirstResponder]) {
        [_growingTextView resignFirstResponder];
    }
    _growingTextView.text = nil;
}

#pragma mark - NSNotification
-(void) keyboardWillShow:(NSNotification *)note{
    
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect toolbarFrame = _toolbarContainerView.frame;
    
    CGRect tableViewFrame = _tableView.frame;
    tableViewFrame.size.height = self.view.bounds.size.height - keyboardBounds.size.height - toolbarFrame.size.height;
    _tableView.frame = tableViewFrame;
    
    CGPoint offset = _tableView.contentOffset;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    toolbarFrame.origin.y = self.view.bounds.size.height - keyboardBounds.size.height - toolbarFrame.size.height;
    _toolbarContainerView.frame = toolbarFrame;
    
    offset = CGPointMake(0, _tableView.contentSize.height -  _tableView.frame.size.height);
    _tableView.contentOffset = offset;
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    
    CGRect toolbarFrame = _toolbarContainerView.frame;
    
    CGRect tableViewFrame = _tableView.frame;
    tableViewFrame.size.height = self.view.bounds.size.height - toolbarFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    toolbarFrame.origin.y = self.view.bounds.size.height - toolbarFrame.size.height;
    _toolbarContainerView.frame = toolbarFrame;
    
    _tableView.frame = tableViewFrame;
    
    // commit animations
    [UIView commitAnimations];
}

#pragma mark -HPGrowingTextViewDelegate
#define MAX_REPLY_TEXT_LENGTH 256
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView{
    
    if (growingTextView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
    return YES;
}
- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView{
    
    if (_growingTextView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
    _textRange = growingTextView.selectedRange;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = _toolbarContainerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    _toolbarContainerView.frame = r;
}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    _textRange = growingTextView.selectedRange;
    if (growingTextView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    } else {
        self.placeHolderLabel.hidden = NO;
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
    NSString *imgName = @"content_pic_default";
    [imageView sd_setImageWithURL:[self.topicInfo.picURLs objectAtIndex:index] placeholderImage:[UIImage imageNamed:imgName]];
    return cell;
}
#pragma mark GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %ld", position);
    NSString *url = [self.topicInfo.picURLs objectAtIndex:position];
    XELog(@"url===%@",url);
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    
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
    return self.sectionView.frame.size.height;
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
}

@end
