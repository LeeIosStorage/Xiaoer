//
//  ExpectSearchViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/8/29.
//
//

#import "ExpectSearchViewController.h"
#import "ExpectSearchCell.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XETopicInfo.h"
#import "XECateTopicViewCell.h"
#import "XEQuestionViewCell.h"
#import "TopicDetailsViewController.h"
#import "QuestionDetailsViewController.h"
#import "XEQuestionInfo.h"
@interface ExpectSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;

@property (strong, nonatomic) IBOutlet UIView *chooseTypeView;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *searchImage;

@property (weak, nonatomic) IBOutlet UIButton *rollBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchContentLab;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;


@property (strong, nonatomic) IBOutlet UIView *headerViewB;
@property (weak, nonatomic) IBOutlet UITextField *searchExpectContent;

@property (weak, nonatomic) IBOutlet UIButton *searchEcpectCancle;

@property (nonatomic,assign)int pageNum;
@property (nonatomic,assign)BOOL ifToEnd;
@property (nonatomic,assign)BOOL ifRemoveData;

/**
 *  保存模型的数组
 */
@property (nonatomic,strong)NSMutableArray *dataSoures;
/**
 *  入园
 */
- (IBAction)getInTouched:(id)sender;
/**
 *  营养
 */
- (IBAction)nurationTouched:(id)sender;
/**
 *  养育
 */
- (IBAction)raiseTouched:(id)sender;
/**
 *  心理
 */
- (IBAction)heartTouched:(id)sender;


- (IBAction)typeBtnTouched:(id)sender;
- (IBAction)cancleBtnTouched:(id)sender;
- (IBAction)cancleExpectBtnTouched:(id)sender;

@end

@implementation ExpectSearchViewController

- (NSMutableArray *)dataSoures
{
    if (!_dataSoures) {
        self.dataSoures = [NSMutableArray array];
    }
    return _dataSoures;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"搜索";
    self.pageNum = 1;
    self.ifToEnd = NO;
    self.ifRemoveData = NO;
    
    
    [self configureTableView];
    [self configureTypeView];
    [self.rollBtn setBackgroundImage:[UIImage imageNamed:@"expect_rowDown"] forState:UIControlStateNormal];
    NSLog(@"searchType == %u",self.searchType);

}
#pragma mark 搜索
- (void)searchDataWith:(NSString *)string{
    
    [XEProgressHUD AlertLoading:@"正在搜索请稍候"];
    if (self.searchType == SearchTopic) {
        [self exactSearchWith:string];
    }else{
        [self blurSearchWith:string];
    }
    
}



/**
 *  模糊搜索
 */

- (void)blurSearchWith:(NSString *)string
{
    
    int tag = [[XEEngine shareInstance]getConnectTag];
    [[XEEngine shareInstance]getQuestionListWithPagenum:self.pageNum tag:tag title:string];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {

        [XEProgressHUD AlertSuccess:@"搜索完成"];
        
        if ([jsonRet[@"object"][@"end"] isEqual:@0]) {
            self.ifToEnd = YES;
        }
        
        NSArray *array = jsonRet[@"object"][@"questions"];
        
        if (array.count == 0)
        {
            if (self.ifRemoveData == YES) {
                [self.dataSoures removeAllObjects];
                [XEProgressHUD lightAlert:@"无搜索内容"];
                
            }else
                
                [XEProgressHUD lightAlert:@"无搜索内容"];
        }
        else
        {
            
            if (self.ifRemoveData == YES)
            {
                [self.dataSoures removeAllObjects];
            }
            for (NSDictionary *dic in array)
            {
                XEQuestionInfo *info = [[XEQuestionInfo alloc]init];
                [info setQuestionInfoByJsonDic:dic];
                
                [self.dataSoures addObject:info];
            }
            
        }
        [self.tableView reloadData];
        
    } tag:tag];
}


/**
 *  精确种类搜索
 */

- (void)exactSearchWith:(NSString *)string
{
    int tag = [[XEEngine shareInstance]getConnectTag];
    NSString *cat = nil;
    if ([self.typeBtn.titleLabel.text isEqualToString:@"全部"]) {
        cat = @"0";
    }
    if ([self.typeBtn.titleLabel.text isEqualToString:@"心理"]) {
        cat = @"1";
    }
    if ([self.typeBtn.titleLabel.text isEqualToString:@"养育"]) {
        cat = @"2";
    }
    if ([self.typeBtn.titleLabel.text isEqualToString:@"营养"]) {
        cat = @"3";
    }
    if ([self.typeBtn.titleLabel.text isEqualToString:@"入园"]) {
        cat = @"4";
    }
    
    
    
    [[XEEngine shareInstance]getHotTopicWithWithPagenum:self.pageNum tag:tag cat:cat title:string];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        

        [XEProgressHUD AlertSuccess:@"搜索完成"];
        if ([jsonRet[@"object"][@"end"] isEqual:@0]) {
            self.ifToEnd = YES;
        }
        NSArray *array = jsonRet[@"object"][@"topics"];
        
        if (array.count == 0)
        {
            if (self.ifRemoveData == YES) {
                [self.dataSoures removeAllObjects];
                [XEProgressHUD lightAlert:@"无搜索内容"];

            }else
            
            [XEProgressHUD lightAlert:@"无搜索内容"];
        }
        else
        {
            
            if (self.ifRemoveData == YES) {
                [self.dataSoures removeAllObjects];
            }
            for (NSDictionary *dic in array)
            {
               
                XETopicInfo *info = [[XETopicInfo alloc]init];
                [info setTopicInfoByJsonDic:dic];
                
                [self.dataSoures addObject:info];
            }
            
        }
        [self.tableView reloadData];
        
    } tag:tag];
}

- (void)footerRefresh
{
    if (self.searchType == SearchTopic && self.searchContentLab.text.length == 0) {
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView footerEndRefreshing];
        });
        return;
    }
    
    if (self.searchType == SearchEcpect && self.searchExpectContent.text.length == 0) {
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView footerEndRefreshing];
        });
        return;
    }
    
    self.ifRemoveData = NO;
    if (self.ifToEnd == YES ) {
        [XEProgressHUD lightAlert:@"已经到最后一页了"];
    }else{
        self.pageNum++;
        if (self.searchType == SearchTopic) {
            [self searchDataWith:self.searchContentLab.text];
        }else{
            [self searchDataWith:self.searchExpectContent.text];
        }
        
    }
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView footerEndRefreshing];
    });
}
- (void)headerRefresh{
    if (self.searchType == SearchTopic && self.searchContentLab.text.length == 0) {
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView headerEndRefreshing];
        });
        return;
    }
    
    if (self.searchType == SearchEcpect && self.searchExpectContent.text.length == 0) {
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView headerEndRefreshing];
        });
        return;
    }
    self.ifRemoveData = YES;
    self.pageNum = 1;
    self.ifToEnd = NO;
    if (self.searchType == SearchTopic) {
        [self searchDataWith:self.searchContentLab.text];
    }else{
        [self searchDataWith:self.searchExpectContent.text];
    }

    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView headerEndRefreshing];
    });
}
- (void)configureTypeView{
    self.chooseTypeView.frame = CGRectMake(10, 100, 100, 180);
    [self.view addSubview:self.chooseTypeView];
    self.chooseTypeView.hidden = YES;
    self.searchContentLab.delegate = self;
    self.searchExpectContent.delegate = self;
    self.searchContentLab.returnKeyType = UIReturnKeySearch;
    self.searchExpectContent.returnKeyType = UIReturnKeySearch;
}


- (void)configureTableView{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.searchType == SearchTopic) {
        [self.tableView registerNib:[UINib nibWithNibName:@"XECateTopicViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }else{
        [self.tableView registerNib:[UINib nibWithNibName:@"XEQuestionViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    self.headerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.headerViewB.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];


}


#pragma mark  tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoures.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.searchType == SearchTopic) {
        return self.headerView.frame.size.height;
    }else{
        return self.headerViewB.frame.size.height;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.searchType == SearchTopic) {
        return self.headerView;
    }else{
        return self.headerViewB;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.searchType == SearchTopic) {
        
        XECateTopicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        XETopicInfo *topicInfo = self.dataSoures[indexPath.row];
        cell.isExpertChat = YES;
        [cell configureCellTitleDesWithSameStr:self.searchContentLab.text topicInfo:topicInfo];
        
        return cell;
    }else{
        
        XEQuestionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        XEQuestionInfo *info = self.dataSoures[indexPath.row];
        cell.isExpertChat = NO;
        cell.isMineChat = YES;
//        cell.questionInfo = info;
        [cell configureCellTitleDesWithSameStr:self.searchExpectContent.text topicInfo:info];

        return cell;
        
    }
    return nil;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchType == SearchTopic) {
        TopicDetailsViewController *detail = [[TopicDetailsViewController alloc]init];
        detail.topicInfo = self.dataSoures[indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        XEQuestionInfo *info = self.dataSoures[indexPath.row];
        QuestionDetailsViewController *vc = [[QuestionDetailsViewController alloc] init];
        vc.questionInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)changeTypeBtnTitleWith:(UIButton *)button{
    self.chooseTypeView.hidden =! self.chooseTypeView.hidden;
    [self.typeBtn setTitle:button.titleLabel.text forState:UIControlStateNormal];
    
}
- (IBAction)getInTouched:(id)sender {
    NSLog(@"入园");
    UIButton *button = (UIButton *)sender;
    [self changeTypeBtnTitleWith:button];
    [self configureRollBtnBackGroundImage];

}

- (IBAction)nurationTouched:(id)sender {
    NSLog(@"营养");
    UIButton *button = (UIButton *)sender;
    [self changeTypeBtnTitleWith:button];
    [self configureRollBtnBackGroundImage];

}

- (IBAction)raiseTouched:(id)sender {
    NSLog(@"养育");
    UIButton *button = (UIButton *)sender;
    [self changeTypeBtnTitleWith:button];

    [self configureRollBtnBackGroundImage];

}

- (IBAction)heartTouched:(id)sender {
    NSLog(@"心理");
    UIButton *button = (UIButton *)sender;
    [self changeTypeBtnTitleWith:button];
    [self configureRollBtnBackGroundImage];

}

- (IBAction)typeBtnTouched:(id)sender {
    
    self.chooseTypeView.hidden =! self.chooseTypeView.hidden;
    if (self.chooseTypeView.hidden == NO) {
        [self.rollBtn setBackgroundImage:[UIImage imageNamed:@"expect_rowDown"] forState:UIControlStateNormal];
    }else{
        [self.rollBtn setBackgroundImage:[UIImage imageNamed:@"expect_rowUp"] forState:UIControlStateNormal];
    }
    [self configureRollBtnBackGroundImage];

}
- (void)configureRollBtnBackGroundImage{

    if (self.chooseTypeView.hidden == YES) {
        [self.rollBtn setBackgroundImage:[UIImage imageNamed:@"expect_rowDown"] forState:UIControlStateNormal];
    }else{
        [self.rollBtn setBackgroundImage:[UIImage imageNamed:@"expect_rowUp"] forState:UIControlStateNormal];
    }

}
- (IBAction)cancleBtnTouched:(id)sender {
    [self.searchExpectContent resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancleExpectBtnTouched:(id)sender {
    
    [self.searchExpectContent resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];}


#pragma mark texeFiled delagate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.ifToEnd = NO;
    self.pageNum = 1;
    self.ifRemoveData = YES;
    if (textField.text.length == 0) {
        [XEProgressHUD lightAlert:@"请输入搜索关键字"];
    }else{
        [self searchDataWith:textField.text];
    }
    NSLog(@"%@",textField.text);
    return YES;
}
@end
