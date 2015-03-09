//
//  ReadyTestViewController.m
//  xiaoer
//
//  Created by KID on 15/2/28.
//
//

#import "ReadyTestViewController.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
#import "XECollectionViewCell.h"
#import "XELinkerHandler.h"
#import "XEItemInfo.h"
#import "UIImageView+WebCache.h"

@interface ReadyTestViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *itemsArray;
@end

@implementation ReadyTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //此句不加程序崩
    [self.collectionView registerClass:[XECollectionViewCell class] forCellWithReuseIdentifier:@"XECollectionViewCell"];
    [self getEvaToolSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNormalTitleNavBarSubviews {
    
    [self setTitle:@"准备评测"];
}

- (void)getEvaToolSource{
    __weak ReadyTestViewController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
//    [[XEEngine shareInstance] getEvaToolWithStage:self.stageIndex tag:tag];
    [[XEEngine shareInstance] getEvaToolWithStage:1 tag:tag];
    [[XEEngine shareInstance] addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {
        NSString* errorMsg = [XEEngine getErrorMsgWithReponseDic:jsonRet];
        if (!jsonRet || errorMsg) {
            if (!errorMsg.length) {
                errorMsg = @"请求失败";
            }
            [XEProgressHUD AlertError:errorMsg At:weakSelf.view];
            return;
        }
        NSLog(@"=================%@",jsonRet);
        weakSelf.itemsArray = [NSMutableArray array];
        
        NSArray *themeDicArray = [[jsonRet objectForKey:@"object"] arrayObjectForKey:@"toy"];
        for (NSDictionary *dic  in themeDicArray) {
            if (![dic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            XEItemInfo *item = [[XEItemInfo alloc] init];
            [item setItemInfoByJsonDic:dic];
            [weakSelf.itemsArray addObject:item];
        }
        [weakSelf.collectionView reloadData];
    }tag:tag];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XECollectionViewCell" forIndexPath:indexPath];
    XEItemInfo *itemInfo = _itemsArray[indexPath.row];
    if (indexPath.row >= 0 && indexPath.row <= 6) {
        [cell.avatarImgView sd_setImageWithURL:itemInfo.imageUrl placeholderImage:[UIImage imageNamed:@"home_placeholder_avatar"]];
        [cell.nameLabel setText:itemInfo.name];
    }
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 110) / 3, 89);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 25, 15, 15);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 5:{
            id vc = [XELinkerHandler handleDealWithHref:@"http://www.baidu.com" From:self.navigationController];
            if (vc) {
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 4:{

        }
            break;
        case 3:{

        }
            break;
        case 2:{

        }
            break;
        case 1:{

            break;
        }
        case 0:{
        
            break;
        }
        default:
            break;
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//
- (IBAction)evaAction:(id)sender {
    NSString *evaUrl = [NSString stringWithFormat:@"%@/eva/test/start/%@/%@/%d",[XEEngine shareInstance].baseUrl,[XEEngine shareInstance].uid,_babyInfo.babyId,self.stageIndex];
    id vc = [XELinkerHandler handleDealWithHref:evaUrl From:self.navigationController];
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
