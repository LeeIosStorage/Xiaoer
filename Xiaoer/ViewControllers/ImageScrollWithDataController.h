//
//  ImageScrollWithDataController.h
//  Xiaoer
//
//  Created by 王鹏 on 15/8/3.
//
//

#import "XESuperViewController.h"
#import "XEBabyImpressMonthListInfo.h"

@protocol imageScrolldeleteDataDelegate <NSObject>

- (void)imageScrolldeleteDataResultWith:(NSInteger )index;

@end


@interface ImageScrollWithDataController : XESuperViewController
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,assign)BOOL ifHaveDelete;
/**
 *  展示第几张图片
 */
@property (nonatomic,assign)NSInteger moveIndex;

@property (nonatomic,assign)BOOL ifDeleteBtnTouched;
@property (nonatomic,assign)id<imageScrolldeleteDataDelegate>delegate;
@end
