//
//  TaskViewController.m
//  Xiaoer
//
//  Created by KID on 15/2/12.
//
//

#import "TaskViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XETrainInfo.h"
#import "XELinkerHandler.h"
#import "EvaluationViewController.h"

@interface TaskViewController (){
    BOOL _isData;
}

@property (strong, nonatomic) NSMutableArray *trainArray;
@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreTitleLabel;


@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.titleNavBar setHidden:YES];
    [self getTrainInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews{
    [self setTitle:@"妈妈任务"];
}

- (void)getTrainInfo{
    __weak TaskViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance] getTrainIngosWithUid:[XEEngine shareInstance].uid tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            if ([errorMsg isEqualToString:@"暂无评测结果信息"]) {
                [weakSelf refreshUIWithData:_isData];
            }else{
                [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            }
            return;
        }
        _isData = YES;
        //解析数据
        weakSelf.trainArray = [NSMutableArray array];
        
        NSArray *themeDicArray = [jsonRet arrayObjectForKey:@"object"];
        for (NSDictionary *dic in themeDicArray) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            XETrainInfo *trainInfo = [[XETrainInfo alloc] init];
            [trainInfo setTrainInfoByJsonDic:dic];
            [weakSelf.trainArray addObject:trainInfo];
        }
        
        if (weakSelf.trainArray.count) {
            [weakSelf refreshUIWithData:_isData];
        }
    }tag:tag];
}

- (void)refreshUIWithData:(BOOL)bData{
    if (bData) {
        XETrainInfo *trainInfo = [[XETrainInfo alloc] init];
        trainInfo = [self.trainArray objectAtIndex:0];
        _scoreLabel.text = [[trainInfo.resultsInfo objectAtIndex:0]objectForKey:@"score"];
    }else {
        [_startBtn setTitle:@"开始测评" forState:UIControlStateNormal];
        _scoreTitleLabel.text = @"当前关键期还没有评测记录";
    }
}


- (IBAction)startTrainAction:(id)sender {
    if (_isData) {
        XETrainInfo *trainInfo = [[XETrainInfo alloc] init];
        trainInfo = [self.trainArray objectAtIndex:0];
        id vc = [XELinkerHandler handleDealWithHref:[NSString stringWithFormat:@"%@/train/cat/%@/%@/%@",[XEEngine shareInstance].baseUrl,trainInfo.stage,trainInfo.cat,_scoreLabel.text] From:self.navigationController];
        if (vc) {
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        EvaluationViewController *eVc = [[EvaluationViewController alloc] init];
        [self.navigationController pushViewController:eVc animated:YES];
    }
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
