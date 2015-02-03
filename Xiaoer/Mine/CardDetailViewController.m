//
//  CardDetailViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/3.
//
//

#import "CardDetailViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "PerfectInfoViewController.h"

@interface CardDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *cardImageView;
@property (strong, nonatomic) IBOutlet UILabel *cardTitle;
@property (strong, nonatomic) IBOutlet UILabel *cardDes;
@property (strong, nonatomic) IBOutlet UILabel *cardPrice;
@property (strong, nonatomic) IBOutlet UILabel *leftNum;

- (IBAction)receiveAction:(id)sender;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshDetailUI];
    [self refreshCardInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    [self setTitle:@"卡包详情"];
}

- (void)refreshCardInfo{
    __weak CardDetailViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getCardDetailInfoWithUid:[XEEngine shareInstance].uid cid:self.cardInfo.cid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        
        [self.pullRefreshView finishedLoading];
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg];
            return;
        }
        
        NSDictionary *dic = [jsonRet objectForKey:@"object"];
        [weakSelf.cardInfo setCardInfoByJsonDic:dic];
        [weakSelf refreshDetailUI];
    }tag:tag];
}

- (void)refreshDetailUI{
    _cardPrice.text = [NSString stringWithFormat:@"￥%@",_cardInfo.price];
    if (![_cardInfo.img isEqual:[NSNull null]]) {
        [_cardImageView sd_setImageWithURL:[NSURL URLWithString:_cardInfo.img] placeholderImage:[UIImage imageNamed:@"activity_load_icon"]];
    }else{
        [_cardImageView sd_setImageWithURL:nil];
        [_cardImageView setImage:[UIImage imageNamed:@"topic_load_icon"]];
    }
    _cardTitle.text = _cardInfo.title;
    _cardDes.text = _cardInfo.des;
    _leftNum.text = [NSString stringWithFormat:@"%d",_cardInfo.leftNum];
}

- (IBAction)receiveAction:(id)sender {
    PerfectInfoViewController *piVc = [[PerfectInfoViewController alloc] init];
    piVc.userInfo = [XEEngine shareInstance].userInfo;
    [self.navigationController pushViewController:piVc animated:YES];
}

@end
