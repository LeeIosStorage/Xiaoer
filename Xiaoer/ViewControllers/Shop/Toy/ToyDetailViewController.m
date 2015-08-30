//
//  ToyDetailViewController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/6/19.
//
//

#import "ToyDetailViewController.h"
#import "ToyListViewController.h"
#import "VerifyIndentViewController.h"
#import "ShopCarViewController.h"
#import "ToyLunBoView.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XEShopDetailInfo.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "ToyDetailCollectiCell.h"
#import "ToyDetailCollectHeaderView.h"
#import "ToyDetailCollectTopCell.h"
#import "ToyDetailCollectionFooterView.h"
#import "XEShopCarInfo.h"
#define collectH 350


@interface ToyDetailViewController ()<UIWebViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,btnTouchDelegate,topCancleBtnTouched>
@property (strong, nonatomic) IBOutlet UIView *naviLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

/**
 *    遮罩
 */
@property (nonatomic,strong)UIView *hideView;

/**
 *  选择的view
 */
@property (strong, nonatomic) IBOutlet UIView *chooseView;

@property (weak, nonatomic) IBOutlet UICollectionView *chooseCollectView;
@property (nonatomic,strong)UICollectionViewFlowLayout *layOut;

/**
 *  choose的tableview的headerview
 */
@property (strong, nonatomic) IBOutlet UIView *chooseTabHeader;

/**
 *  区头的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *chooseHeaderImage;
/**
 *  显示价格的lable
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

/**
 *  网页数据请求
 */
@property (nonatomic, retain) NSURLRequest *request;

/**
 *  用户ID
 */
@property (nonatomic,strong)NSString *userID;

/**
 *  左边的数组（例如：颜色，尺寸，材质）
 */
@property (nonatomic,strong)NSMutableArray *leftArray;
/**
 *  右边的数组（红色,蓝色,白色,卡其色,水洗蓝 ／ S,M,L,XL,XXL,XXXL）
 */
@property (nonatomic,strong)NSMutableArray *rightArray;


/**
 *  保存每一个分区点击了那个button
 */
@property (nonatomic,strong)NSMutableArray *strArray;


@property (nonatomic,strong)XEShopDetailInfo *detailInfo;
/**
 *  区尾显示购买数量的lable
 */
@property (nonatomic,strong)UILabel *buyNum;


@property (nonatomic,strong)NSMutableString *standardStr;

@end

@implementation ToyDetailViewController
- (UILabel *)buyNum{
    if (!_buyNum) {
        self.buyNum = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 20, 40, 40, 20)];
        _buyNum.textAlignment = NSTextAlignmentCenter;
    }
    return _buyNum;
}
- (NSMutableArray *)strArray{
    if (!_strArray) {
        self.strArray = [NSMutableArray array];
    }
    return _strArray;
}
- (UICollectionViewFlowLayout *)layOut{
        if (!_layOut) {
            self.layOut = [[UICollectionViewFlowLayout alloc]init];
            _layOut.scrollDirection =  UICollectionViewScrollDirectionVertical;
            _layOut.minimumLineSpacing = 10;
            _layOut.minimumInteritemSpacing = 15;
        
    }
        return _layOut;
}
- (NSMutableArray *)leftArray{
    if (!_leftArray) {
        self.leftArray = [NSMutableArray array];
    }
    return _leftArray;
}
- (NSMutableArray *)rightArray{
    if (!_rightArray) {
        self.rightArray = [NSMutableArray array];
    }
    return _rightArray;
}
- (UIView *)hideView{
    if (!_hideView) {
        self.hideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _hideView.backgroundColor = [UIColor lightGrayColor];
        _hideView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideViewTapAction:)];
        //设置点击次数
        tap.numberOfTapsRequired = 1;
        //这是点击的手指个数
        tap.numberOfTouchesRequired = 1;
        //添加手势
        [_hideView addGestureRecognizer:tap];
    }
    return _hideView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.webView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    self.webView.delegate = self;
    
    
    
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"正在建设中6p"]];
//    imageView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 120);
//    [self.view addSubview:imageView];

    self.buyNum.text = @"1";
    
    
    //注意添加顺序
    [self.view addSubview:self.hideView];
    self.hideView.hidden = YES;
    
    //    布局导航条
    [self confugureNaviTitle];
    [self addBottomView];

    //网页加载
    NSString *url = [NSString stringWithFormat:@"%@/goods/h5detail/%@",[[XEEngine shareInstance] baseUrl],self.shopId];
    [self loadWebViewWithUrl:[NSURL URLWithString:url]];
    //获取商品详情
    [self getShopDetailInfomation];
    
    //添加登陆通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfo:) name:XE_USERINFO_CHANGED_NOTIFICATION object:nil];


}
- (void)hideViewTapAction:(UITapGestureRecognizer *)sender{
    [self animationChooseView];
}
/*
- (UIView *)creatFooterView{

    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor redColor];
    
    //确定按钮
    UIButton *VerifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [VerifyBtn setTitle:@"确定" forState:UIControlStateNormal];
    [VerifyBtn setBackgroundColor:SKIN_COLOR];
    [VerifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [VerifyBtn addTarget:self action:@selector(toucheChooseVerifyBtn) forControlEvents:UIControlEventTouchUpInside];
    if (self.leftArray.count == 0) {
        NSLog(@"无选项");
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        VerifyBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    }else{
        
        for (int i = 0; i < self.leftArray.count; i++) {
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 20)];
            titleLab.text = self.leftArray[i];
            
            UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layOut];
            collectView.delegate = self;
            collectView.dataSource = self;
            [collectView registerNib:[UINib nibWithNibName:@"ToyDetailCollectiCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
            collectView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            collectView.tag = i + 10;
            collectView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 80);
            
            
            UIView *collectBack = [[UIView alloc]initWithFrame:CGRectMake(0, i * 100, SCREEN_WIDTH, 100)];
            collectBack.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
            [collectBack addSubview:titleLab];
            [collectBack addSubview:collectView];
            
            [footerView addSubview:collectBack];
            
        }
        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 350);
        VerifyBtn.frame = CGRectMake(0, 300, SCREEN_WIDTH, 50);

        
        
    }
    
    

//    if (self.leftArray.count == 0) {
//        
//        NSLog(@"无选项");
//        footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//        VerifyBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//        [footerView addSubview:VerifyBtn];
//    }else{
//        
//        for (int i = 0; i < self.leftArray.count; i++) {
//            UIView *view = [[UIView alloc]init];
//            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 20)];
//            lable.text = self.leftArray[i];
//            lable.textColor = [UIColor blackColor];
//            lable.font = [UIFont systemFontOfSize:15];
//            NSArray *comRightArr = [self.rightArray[i] componentsSeparatedByString:@","];
//            [view addSubview:lable];
//            
//            for (int j = 0; j < comRightArr.count; j++) {
//                NSLog(@"%@",comRightArr[j]);
//                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                [button setBackgroundColor:SKIN_COLOR];
//                [button setTitle:comRightArr[j] forState:UIControlStateNormal];
//                button.frame = CGRectMake(15 + (smBtnW + 10) * j, 40, smBtnW, smBtnH);
//                view.frame = CGRectMake(0, 100 * i, SCREEN_WIDTH, 100);
//                [view addSubview:button];
//                [footerView addSubview:view];
//                if (j == comRightArr.count - 1) {
//                    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 350);
//                    VerifyBtn.frame = CGRectMake(0, 300,SCREEN_WIDTH ,50);
//                    [footerView addSubview:VerifyBtn];
//                }
//            }
//            
//            
//            
//        }
//
//    }
//
    [footerView addSubview:VerifyBtn];

    return footerView;
}
*/

- (void)toucheChooseVerifyBtn{
    [self animationChooseView];
}

#pragma mark 添加到购物车
- (void)addShopInfoToShopCar{
    __weak ToyDetailViewController *weakSelf = self;
    
    int tag = [[XEEngine shareInstance] getConnectTag];
    if (![XEEngine shareInstance].uid) {
        self.userID = @"";
    } else {
        self.userID = [XEEngine shareInstance].uid;
    }
    if (!self.standardStr) {
        self.standardStr = [NSMutableString stringWithFormat:@""];
    }

    
    [[XEEngine shareInstance]refreshShopCarWithTag:tag del:@"0" idNum:@"" num:self.buyNum.text userid:self.userID goodsid:self.detailInfo.id standard:self.standardStr];
    
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        
        if ([[jsonRet[@"code"] stringValue] isEqualToString:@"0"]) {
            [XEProgressHUD AlertSuccess:@"加入购物车成功" At:self.view];
        }else{
            [XEProgressHUD AlertError:@"加入购物车失败" At:self.view];
        }
        
    } tag:tag];
    
    
}
#pragma mark  获取商品详情
- (void)getShopDetailInfomation{
    __weak ToyDetailViewController *weakSelf = self;
    
    int tag = [[XEEngine shareInstance] getConnectTag];
    if (![XEEngine shareInstance].uid) {
        self.userID = @"";
    } else {
        self.userID = [XEEngine shareInstance].uid;
    }

    [[XEEngine shareInstance]getShopDetailInfomationWithTag:tag shopId:self.shopId userId:self.userID];
    [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        //获取失败信息
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (errorMsg) {
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return ;
        }
        if (![[jsonRet objectForKey:@"code"] isEqual:@0]) {
            [XEProgressHUD AlertError:@"数据获取失败，请检查网络设置" At:weakSelf.view];
            return;
            
        }
        if ([jsonRet[@"object"][@"goods"] isKindOfClass:[NSNull class]]) {
            [XEProgressHUD AlertError:@"获取商品详情失败，请检查网络设置" At:weakSelf.view];
            return;
        }
        
        self.detailInfo = [XEShopDetailInfo objectWithKeyValues:jsonRet[@"object"][@"goods"]];

        
        NSMutableString *muStr = [self.detailInfo.standard copy];
        NSArray *array = [muStr componentsSeparatedByString:@";"];
        if (array.count >= 1 && muStr.length > 0) {
            for (NSString *str in array) {
                NSMutableString * muStrB = [str copy];
                NSArray *arrayB = [muStrB componentsSeparatedByString:@":"];
                [self.leftArray addObject:arrayB[0]];
                [self.rightArray addObject:arrayB[1]];
                
            }
        }

        [self configureChoosecollectionView];
        
    } tag:tag];


}

#pragma mark 布局collectionView

- (void)configureChoosecollectionView{
    self.chooseCollectView.delegate = self;
    self.chooseCollectView.dataSource = self;
    self.chooseCollectView.collectionViewLayout = self.layOut;
    self.chooseHeaderImage.layer.cornerRadius = 10;
    
    [self.chooseCollectView registerNib:[UINib nibWithNibName:@"ToyDetailCollectiCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    
    [self.chooseCollectView registerNib:[UINib nibWithNibName:@"ToyDetailCollectTopCell" bundle:nil] forCellWithReuseIdentifier:@"top"];

    [self.chooseCollectView registerNib:[UINib nibWithNibName:@"ToyDetailCollectHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    

    [self.chooseCollectView registerClass:[ToyDetailCollectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    self.chooseHeaderImage.layer.masksToBounds = YES;

    
    self.chooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, collectH + 50);
    
    UIButton *verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyBtn.frame = CGRectMake(0, collectH, SCREEN_WIDTH, 50);
    verifyBtn.backgroundColor = SKIN_COLOR;
    [verifyBtn setTitle:@"确定" forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(chooseVetifyBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseView addSubview:verifyBtn];
    
    
    [self.view addSubview:self.chooseView];
    
    if (self.leftArray.count > 0) {
        for (int i = 0; i < self.leftArray.count; i++) {
            NSMutableString *str = [NSMutableString stringWithFormat:@""];
            [self.strArray addObject:str];
        }
    }
}


- (void)chooseVetifyBtnTouched{
    NSLog(@"确定");
    if ([[XEEngine shareInstance] needUserLogin:@"登录或注册后才能查阅卡券"]) {
        return;
    }
    [self addShopInfoToShopCar];
}



#pragma mark 布局导航条
- (void)confugureNaviTitle{
    self.titleNavBar.alpha = 0;
    self.naviLable.frame = CGRectMake(0, 20, SCREEN_WIDTH, 40);
    
    UIButton *shopCar = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCar.backgroundColor = [UIColor clearColor];
    [shopCar setBackgroundImage:[UIImage imageNamed:@"toyCar"] forState:UIControlStateNormal];
    [shopCar addTarget:self action:@selector(toShopCar) forControlEvents:UIControlEventTouchUpInside];
    shopCar.frame = CGRectMake(SCREEN_WIDTH - 40, 0, 40, 40);
    [self.naviLable addSubview:shopCar];
    [self.view addSubview:self.naviLable];
}

#pragma mark 返回按钮
//返回按钮
- (IBAction)back:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 右上角前往购物车按钮
- (void)toShopCar{
    NSLog(@"前往购物车");

    if ([[XEEngine shareInstance] needUserLogin:@"登录或注册后才能查看购物车"]) {
        return;
    }

    ShopCarViewController *car = [[ShopCarViewController alloc]init];
    [self.navigationController pushViewController:car animated:YES];
}


#pragma mark  收藏按钮
- (IBAction)collect:(id)sender {
    NSLog(@"收藏");
}

#pragma mark  web下面点击加入到购物车
- (IBAction)bottomAddToShopCar:(id)sender {
    if ([[XEEngine shareInstance] needUserLogin:@"登录或注册后才能加入购物车"]) {
        return;
    }
    
    [self animationChooseView];

}



#pragma mark  立即购买
- (IBAction)buy:(id)sender {
    if ([[XEEngine shareInstance] needUserLogin:@"登录或注册后才能购买"]) {
        return;
    }
    VerifyIndentViewController *verify = [[VerifyIndentViewController alloc]init];
    
    XEShopCarInfo *carInfo = [[XEShopCarInfo alloc]init];
    carInfo.origPrice = self.detailInfo.origPrice;
    carInfo.goodsId = self.detailInfo.id;
    carInfo.num = [NSString stringWithFormat:@"%ld",[self.buyNum.text integerValue]];
    carInfo.price = self.detailInfo.price;
    if (self.standardStr) {
        carInfo.standard = self.standardStr;
    }
    carInfo.serieId = self.detailInfo.serieId;
    carInfo.name = self.detailInfo.name;
    carInfo.userId = [XEEngine shareInstance].uid;
    carInfo.url = self.detailInfo.url;
    carInfo.carriage = self.detailInfo.carriage;
    carInfo.providerId = self.detailInfo.providerId;
    
    verify.shopArray = [NSMutableArray arrayWithObjects:carInfo, nil];
    
    
    [self.navigationController pushViewController:verify animated:YES];
}

#pragma mark 选择界面取消按钮点击
- (IBAction)cancleBtnTouched:(id)sender {
    NSLog(@"取消按钮点击");
    [self animationChooseView];
}




#pragma mark 选择界面透明头部点击之后执行动画
- (IBAction)headerClearBtnTouched:(id)sender {
    
    [self animationChooseView];
}

#pragma mark collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }

    if (self.rightArray.count > 0) {
        NSArray *array = [self.rightArray[section - 1] componentsSeparatedByString:@","];
        return array.count;
    }

    return 0;
}
//设置分区数量
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.leftArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        ToyDetailCollectTopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"top" forIndexPath:indexPath];
        self.standardStr = [NSMutableString string];
        for (int i = 0; i < self.strArray.count; i++) {
            
            if ([self.strArray[i] isEqualToString:@""]) {
                
            }else{
                
            NSString *str = [NSString stringWithFormat:@"%@:%@ ",self.leftArray[i],self.strArray[i]];
            [self.standardStr appendString:str];
                
            }
        }
        [cell configureCellWithmodel:self.detailInfo chooseStr:self.standardStr];
        cell.delegate = self;
        return cell;
        
        
    }
        ToyDetailCollectiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
        
        cell.delegate = self;
        NSArray *com = [self.rightArray[indexPath.section - 1] componentsSeparatedByString:@","];
        cell.tag = indexPath.section;
        if ( self.strArray &&[self.strArray[indexPath.section - 1] isEqualToString:com[indexPath.row]] ) {
            [cell configureCellWithStr:com[indexPath.row]indexPath:indexPath ifChangeBackColorToSkc:YES];
        }else{
            [cell configureCellWithStr:com[indexPath.row]indexPath:indexPath ifChangeBackColorToSkc:NO];
        }
        
        return cell;
    
}

//每个Item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 150);
    }
    return CGSizeMake(80, 30);
}

//每个Item的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
      return UIEdgeInsetsMake(0, 10, 0, 10);

    }
    return UIEdgeInsetsMake(10 , 15, 10, 10);
}

//区头的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(SCREEN_WIDTH, 0);
    }
    return CGSizeMake(0, 30);
}
//区尾的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == self.rightArray.count ) {
        return CGSizeMake(SCREEN_WIDTH, 70);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 0);
    }
    
}



//点击item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{


}
//定义 header Footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        ToyDetailCollectHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        NSString *str = self.leftArray[indexPath.section -  1];
        for ( UIView *view  in header.subviews) {
            if (view.tag  == 100) {
                for (UIView *vi in view.subviews) {
                    if (vi.tag == 101) {
                        UILabel *lable = (UILabel *)vi;
                        lable.textColor = [UIColor blackColor];
                        lable.text = str;
                    }
                }

            }
        }
        return header;
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
    }

    ToyDetailCollectionFooterView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    //加
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"jian-6p"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(SCREEN_WIDTH/2 + 25, 35, 30, 30);
    [addBtn addTarget:self action:@selector(addBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *deleImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jian"]];
    
    //减
    deleImage.frame = CGRectMake(SCREEN_WIDTH/2 -25 - 30, 49, 30, 2);
    UIButton *deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleBtn.backgroundColor = [UIColor clearColor];
    deleBtn.frame = CGRectMake(SCREEN_WIDTH/2  - 25 - 30, 35, 30, 30);
    [deleBtn addTarget:self action:@selector(deleteBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [reusableview addSubview:deleImage];
    [reusableview addSubview:addBtn];
    [reusableview addSubview:deleBtn];
    [reusableview configureFooterView];
    [reusableview addSubview:self.buyNum];
    self.buyNum.text = @"1";

    return reusableview;
    
}
- (void)addBtnTouched{
    NSInteger index = [self.buyNum.text integerValue];
    index++;
    self.buyNum.text = [NSString stringWithFormat:@"%ld",index];
}
- (void)deleteBtnTouched{
    NSInteger index = [self.buyNum.text integerValue];
    if (index == 1) {
        return;
    }else{
        index--;
    }
    self.buyNum.text = [NSString stringWithFormat:@"%ld",index];

}

#pragma mark item delegate
- (void)touchBtnwith:(NSString *)btnTitle btnTag:(NSInteger)btnTag{
    self.strArray[btnTag - 1] = btnTitle;
    [self.chooseCollectView reloadData];
}
- (void)TopCancleBtnTouched{
    [self animationChooseView];
}

#pragma  mark 登陆完成执行操作
- (void)handleUserInfo:(NSNotification *)notification{
    [self getShopDetailInfomation];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  chooseTableView 动画
- (void)animationChooseView{
    NSLog(@"执行动画");
    CGRect rect = self.chooseView.frame;
    if (rect.origin.y == SCREEN_HEIGHT) {
        self.hideView.hidden = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.chooseView.frame = CGRectMake(0, SCREEN_HEIGHT - collectH - 50, SCREEN_WIDTH, collectH + 50);
        } completion:^(BOOL finished) {
        }];
    }else{
        self.hideView.hidden  = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.chooseView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH,collectH + 50);
        } completion:^(BOOL finished) {
        }];
    }
}
#pragma mark  web delegate

- (void)loadWebViewWithUrl:(NSURL *)url {
    [XEProgressHUD AlertLoading:@"正在加载"];

    self.request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:_request];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad: ");
    [XEProgressHUD AlertSuccess:@"加载成功"];
    
}

#pragma mark 添加底部的视图 （收藏，加入购物车，立即购买）
- (void)addBottomView{
    self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 40, SCREEN_WIDTH, 40);
    [self.view addSubview:self.bottomView];
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
