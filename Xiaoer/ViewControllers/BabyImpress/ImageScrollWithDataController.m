//
//  ImageScrollWithDataController.m
//  Xiaoer
//
//  Created by 王鹏 on 15/8/3.
//
//

#import "ImageScrollWithDataController.h"
#import "UIImageView+WebCache.h"
#import "XEEngine.h"
#import "XEProgressHUD.h"
@interface ImageScrollWithDataController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@end

@implementation ImageScrollWithDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    //给scrollView设置代理
    self.scrollView.delegate = self;
    //frame坐标原点相对于内容区域原点的偏移量
    //关闭或打开滚动
    self.scrollView.scrollEnabled = YES;
    //方向滚动,只能水平滑动,不能斜华
    self.scrollView.directionalLockEnabled = YES;
    //按上方的状态栏返回最顶部,默认YES
    self.scrollView.scrollsToTop = NO;
    //边界弹跳
    self.scrollView.bounces = NO;
    //允许水平拖动
    self.scrollView.alwaysBounceHorizontal = YES;
    //滚动条的样式
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    //是否显示某个方向的滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //整页翻动,和scrollView的高度相关
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    if (self.ifHaveDelete == YES) {
        [self setRightButtonWithImageName:@"babayRubbish" selector:@selector(deleteBtnTouched)];
    }else{
        
    }
    self.ifDeleteBtnTouched = NO;
    self.pageController.pageIndicatorTintColor = SKIN_COLOR;
    self.pageController.hidden = YES;
    [self configureScrollViewWith:self.array];
}



#pragma mark 删除照片

- (void)deleteBtnTouched{
    self.ifDeleteBtnTouched = YES;
    NSInteger index = self.scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    __weak ImageScrollWithDataController *weakSelf = self;
    int tag = [[XEEngine shareInstance] getConnectTag];
    
    if (self.array.count > 0) {
        XEBabyImpressMonthListInfo *info = self.array[index];
        [[XEEngine shareInstance]qiNiuDeleteImageDataWith:tag id:info.id];
        [[XEEngine shareInstance]addOnAppServiceBlock:^(NSInteger tag, NSDictionary *jsonRet, NSError *err) {

            NSString *string = [[jsonRet objectForKey:@"code"] stringValue];
            if ([string isEqualToString:@"3"]) {
                [XEProgressHUD AlertError:@"用户已有单子处于已付款或已发货状态，图片不允许删除!" At:weakSelf.view];
                return;
            }
            else if ([string isEqualToString:@"0"]) {
                
                [XEProgressHUD AlertSuccess:@"删除照片成功"];
                [self.array removeObjectAtIndex:index];
                [self configureScrollViewWith:self.array];
                if (self.delegate && [self.delegate respondsToSelector:@selector(imageScrolldeleteDataResultWith:)]) {
                    [self.delegate imageScrolldeleteDataResultWith:index];
                }
                return;
            }else if ([string isEqualToString:@"1"]){

                [XEProgressHUD AlertError:@"图片id不存在" At:weakSelf.view];
                return;

            }else if ([string isEqualToString:@"2"]){
                [XEProgressHUD AlertError:@"图片不存在" At:weakSelf.view];
                
                return;
            }else{
                [XEProgressHUD AlertError:@"删除照片失败" At:weakSelf.view];
                return;
            }
            
        } tag:tag];
        
    }else{
        [XEProgressHUD lightAlert:@"暂无照片，请添加"];
    }
    
    

    
    
    
//    if (self.array.count > 0) {
//        [self.array removeObjectAtIndex:index];
//        if (self.array.count == 0) {
//            
//        }
//        [self configureScrollViewWith:self.array];
//        
//        if (self.delegate && [self.delegate respondsToSelector:@selector(imageScrolldeleteDataResultWith:)]) {
//            [self.delegate imageScrolldeleteDataResultWith:index];
//        }
//        
//    }
    
}

- (void)configureScrollViewWith:(NSMutableArray *)array{
    self.array = array;
    [self setScrollviewWith:array];
}

- (void)setScrollviewWith:(NSMutableArray *)array{
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    //    NSLog(@"%f %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    
    self.scrollView.contentSize = CGSizeMake(array.count * [UIScreen mainScreen].bounds.size.width,0);
    self.pageController.numberOfPages = array.count;
    for (int i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];;
        imageView.tag = i;
        XEBabyImpressMonthListInfo *info = array[i];
        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width + ([UIScreen mainScreen].bounds.size.width - 300)/2, (SCREEN_HEIGHT -64 - 300)/2, 300, 300);
        [imageView sd_setImageWithURL:[NSURL URLWithString:info.url] placeholderImage:[UIImage imageNamed:@"shopCellHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
//            CGFloat Swidth = [UIScreen mainScreen].bounds.size.width;
//            CGFloat Sheight = [UIScreen mainScreen].bounds.size.height - 64;
//            NSLog(@"%f  %f  %f %f",imageView.image.size.width,imageView.image.size.height,Swidth,Sheight);
//            if (imageView.image.size.width > Swidth && imageView.image.size.height < Sheight) {
//                
//                imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width,(Sheight - (imageView.image.size.height * Swidth/imageView.image.size.width))/2 , Swidth, imageView.image.size.height * Swidth/imageView.image.size.width);
//            }
//            
//            else if (imageView.image.size.width > Swidth && imageView.image.size.height > Sheight) {
//                
//                if (imageView.image.size.width > imageView.image.size.height) {
//                    if (imageView.image.size.height * Swidth/imageView.image.size.width > SCREEN_HEIGHT - 64) {
//                        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width, (Sheight - (imageView.image.size.height * Swidth/imageView.image.size.width))/2, Swidth, SCREEN_HEIGHT - 64);
//                    }else if(imageView.image.size.width < imageView.image.size.height){
//                        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width, (Sheight - (imageView.image.size.height * Swidth/imageView.image.size.width))/2, Swidth, imageView.image.size.height * Swidth/imageView.image.size.width);
//                    }
//
//                } else if (imageView.image.size.width < imageView.image.size.height) {
//                    NSLog(@"=====  %f",(Swidth - (Swidth*imageView.image.size.height/Sheight))/2);
//                    if ((Swidth - (Swidth*imageView.image.size.height/Sheight))/2 < 0) {
//                        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0,SCREEN_WIDTH, Sheight);
//                    }else{
//                        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width + (Swidth - (Sheight*imageView.image.size.width/imageView.image.size.height))/2, 0, Sheight*imageView.image.size.width/imageView.image.size.height, Sheight);
//                    }
//                }else if (imageView.image.size.width == imageView.image.size.height){
//                        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width , (SCREEN_HEIGHT -64 - Swidth)/2, Swidth,Swidth);
//                }
//            }
//          else  if (imageView.image.size.width < Swidth && imageView.image.size.height > Sheight) {
//                imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width +(Swidth - (Sheight*imageView.image.size.width/imageView.image.size.height))/2 , 64,Sheight*imageView.image.size.width/imageView.image.size.height, Sheight);
//            }
//
//          else   if (imageView.image.size.width < Swidth && imageView.image.size.height < Sheight) {
//              imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width +(Swidth - imageView.image.size.width)/2 , (SCREEN_HEIGHT -64 - imageView.image.size.height)/2, imageView.image.size.width, imageView.image.size.height);
//          }

            CGFloat Swidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat Sheight = [UIScreen mainScreen].bounds.size.height - 64;
            NSLog(@"%f  %f  %f %f",imageView.image.size.width,imageView.image.size.height,Swidth,Sheight);
            if (imageView.image.size.width > Swidth && imageView.image.size.height < Sheight) {
                
                imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width,(Sheight - (imageView.image.size.height * Swidth/imageView.image.size.width))/2 , Swidth, imageView.image.size.height * Swidth/imageView.image.size.width);
            }
            
            else if (imageView.image.size.width > Swidth && imageView.image.size.height > Sheight) {
                
                if (imageView.image.size.width > imageView.image.size.height) {
                    imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width, (Sheight - (imageView.image.size.height * Swidth/imageView.image.size.width))/2, Swidth, imageView.image.size.height * Swidth/imageView.image.size.width);
                } else  if(imageView.image.size.width < imageView.image.size.height){
                    
                    NSLog(@"=====  %f",(Swidth - (Swidth*imageView.image.size.height/Sheight))/2);
                    if ((Swidth - (Swidth*imageView.image.size.height/Sheight))/2 < 0) {
                        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0,SCREEN_WIDTH, Sheight);
                    }else {
                        imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width + (Swidth - (Sheight*imageView.image.size.width/imageView.image.size.height))/2, 0, Sheight*imageView.image.size.width/imageView.image.size.height, Sheight);
                    }
                    
                }
                else if (imageView.image.size.width == imageView.image.size.height){
                    NSLog(@"进入 %f",imageView.image.size.width*Sheight/imageView.image.size.height);
                    imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width , (SCREEN_HEIGHT -64 - Swidth)/2, Swidth,Swidth);
                }
            }
            else  if (imageView.image.size.width < Swidth && imageView.image.size.height > Sheight) {
                imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width +(Swidth - (Sheight*imageView.image.size.width/imageView.image.size.height))/2 , 64,Sheight*imageView.image.size.width/imageView.image.size.height, Sheight);
            }
            else   if (imageView.image.size.width < Swidth && imageView.image.size.height < Sheight) {
                
                imageView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width +(Swidth - imageView.image.size.width)/2 , (SCREEN_HEIGHT -64 - imageView.image.size.height)/2, imageView.image.size.width, imageView.image.size.height);
            }
            
        }];
        [self.scrollView addSubview:imageView];
        if (self.ifDeleteBtnTouched == NO && self.moveIndex) {
            //此处不理解  －64
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH*self.moveIndex,- 64)];
            //            NSLog(@"%f",SCREEN_WIDTH*self.moveIndex);
            self.pageController.currentPage = self.moveIndex;
            
        }
    }
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.pageController.currentPage = index;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
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
