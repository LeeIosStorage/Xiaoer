//
//  BabyImpressMyPicturerCell.h
//  Xiaoer
//
//  Created by 王鹏 on 15/7/25.
//
//

#import <UIKit/UIKit.h>


#import "XEBabyImpressPhotoListInfo.h"


@interface BabyImpressMyPicturerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainImg;

@property (weak, nonatomic) IBOutlet UILabel *monthLab;

@property (weak, nonatomic) IBOutlet UILabel *numLab;


- (void)configureCellWith:(XEBabyImpressPhotoListInfo *)info;
@end
