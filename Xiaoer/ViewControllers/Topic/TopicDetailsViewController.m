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

#define ONE_IMAGE_HEIGHT  93
#define item_spacing  4

@interface TopicDetailsViewController ()<XEShareActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,GMGridViewDataSource, GMGridViewActionDelegate>
{
    XEShareActionSheet *_shareAction;
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
@property (strong, nonatomic) IBOutlet UILabel *comContentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *expertAvatarImgView;
@property (strong, nonatomic) IBOutlet UILabel *expertNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *expertHospitalLabel;

@property (nonatomic, strong) IBOutlet UIView *sectionView;
@property (nonatomic, strong) IBOutlet UIButton *commentButton;
@property (nonatomic, strong) IBOutlet UIButton *collectButton;

- (IBAction)commentAction:(id)sender;
- (IBAction)collectAction:(id)sender;
@end

@implementation TopicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _topicComments = [[NSMutableArray alloc] init];
    
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
        
        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
        [weakSelf.topicInfo.picIds addObject:@"00000000000000000000000000000032.jpg"];
        
        weakSelf.topicComments = [[NSMutableArray alloc] init];
        NSArray *comments = [[jsonRet objectForKey:@"object"] objectForKey:@"comments"];
//        NSArray *comments = @[@{@"content": @"微博微博微博微博微博微博微", @"name":@"刘备"},@{@"content": @"微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博微博", @"name":@"刘备"},@{@"content": @"", @"name":@"刘备"}];
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
        
        self.expertCommentContainerView.hidden = NO;
        frame = self.expertCommentContainerView.frame;
        frame.origin.y = self.contentContainerView.frame.origin.y + self.contentContainerView.frame.size.height + 10;
        self.expertCommentContainerView.frame = frame;
        
        headHeight += self.expertCommentContainerView.frame.origin.y + self.expertCommentContainerView.frame.size.height;
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

-(void)commitComment{
    __weak TopicDetailsViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] commitCommentTopicWithTopicId:_topicInfo.tId uid:[XEEngine shareInstance].uid content:@"123123" tag:tag];
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
        
        
        
        [weakSelf.tableView reloadData];
    } tag:tag];
    
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
    NSString *imgName = @"user_avatar_default";
    [imageView sd_setImageWithURL:[self.topicInfo.picURLs objectAtIndex:index] placeholderImage:[UIImage imageNamed:imgName]];
    return cell;
}
#pragma mark GMGridViewActionDelegate
- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    NSLog(@"Did tap at index %ld", position);
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    
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
