//
//  BabyImpressPrintController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import "BabyImpressPrintController.h"
#import "BabyImpressCollectCell.h"
#import "XEEngine.h"
#import "XEBabyImpressMonthListInfo.h"
#import "XEProgressHUD.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "BabyImpressVerifyController.h"
#import "ImageScrollWithDataController.h"
@interface BabyImpressPrintController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,babyImpressShowBtnTouched,imageScrolldeleteDataDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *printCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *printBtn;
@property (nonatomic,strong)NSMutableArray *dataSources;
@end

@implementation BabyImpressPrintController

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        self.dataSources = [NSMutableArray array];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.info) {
        if (self.info.month) {
            self.title = [NSString stringWithFormat:@"%@月份照片",self.info.month];
        }
    }
    
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.printCollectionView.backgroundColor = [UIColor clearColor];
    self.printBtn.layer.borderColor = SKIN_COLOR.CGColor;
    self.printBtn.layer.borderWidth = 1;
    self.printBtn.layer.cornerRadius = 5;
    
    [self configureCollectionView];
    [self getMonthDetailListData];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 获取数据
- (void)getMonthDetailListData{
    __weak BabyImpressPrintController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    [[XEEngine shareInstance]qiNiuGetMolthListInfoWith:tag cat:@"1" objid:[XEEngine shareInstance].uid year:self.info.year month:self.info.month];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"获取上传照片数据失败" At:weakSelf.view];
            return;
        }
        

        if ([jsonRet[@"object"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"获取上传照片失败" At:weakSelf.view];
            return;
            
        }
        NSArray *array = jsonRet[@"object"];
        if (array.count == 0) {
            [XEProgressHUD AlertError:@"获取上传照片数据失败" At:weakSelf.view];
            return;
        }
        if (self.dataSources.count > 0) {
            [self.dataSources removeAllObjects];
        }
        for (NSDictionary *dic in array) {
            XEBabyImpressMonthListInfo *listInfo = [XEBabyImpressMonthListInfo objectWithKeyValues:dic];
            [self.dataSources addObject:listInfo];
        }
        [self.printCollectionView reloadData];
        

    } tag:tag];

}
- (void)configureCollectionView{
    self.printCollectionView.delegate = self;
    self.printCollectionView.dataSource = self;
    [self.printCollectionView registerNib:[UINib nibWithNibName:@"BabyImpressCollectCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    UICollectionViewFlowLayout *flowOut = [[UICollectionViewFlowLayout alloc]init];
    flowOut.scrollDirection =  UICollectionViewScrollDirectionVertical;
    flowOut.minimumLineSpacing = 10;
    flowOut.minimumInteritemSpacing = 0;
    self.printCollectionView.collectionViewLayout = flowOut;
    [self.printCollectionView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
}
- (void)headerRefresh{
    [self getMonthDetailListData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.printCollectionView headerEndRefreshing];
    });

}
- (IBAction)printBtnTouched:(id)sender {
    BabyImpressVerifyController *verify = [[BabyImpressVerifyController alloc]init];
    verify.dataSources = self.dataSources;
    [self.navigationController pushViewController:verify animated:YES];
}

#pragma mark collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSources.count;
    
}
//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BabyImpressCollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell configureCellWith:self.dataSources[indexPath.row]];
    return cell;
}

//每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    return CGSizeMake((self.view.frame.size.width - 20)/3, (self.view.frame.size.width - 20)/3);
    
}

//每个Item的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void)babyImpressShowBtnTouchedWith:(NSInteger)index{
    ImageScrollWithDataController *dataImage = [[ImageScrollWithDataController alloc]init];
    dataImage.array = [NSMutableArray arrayWithArray:self.dataSources];
    dataImage.moveIndex = index;
    dataImage.ifHaveDelete = YES;
    dataImage.delegate = self;
    [self.navigationController pushViewController:dataImage animated:YES];
}

- (void)imageScrolldeleteDataResultWith:(NSInteger)index{
    [self.dataSources removeObjectAtIndex:index];
    [self.printCollectionView reloadData];
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
