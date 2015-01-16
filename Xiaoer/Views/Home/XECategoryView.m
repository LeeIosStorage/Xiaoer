//
//  XECategoryView.m
//  Xiaoer
//
//  Created by KID on 15/1/16.
//
//

#import "XECategoryView.h"
#import "CategoryItemCell.h"
#import "UIImageView+WebCache.h"

@interface XECategoryView()<UITableViewDataSource,UITableViewDelegate>

@end


@implementation XECategoryView

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XECategoryView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        //..
    }
    return self;
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dateArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"CategoryItemCell";
    CategoryItemCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:nil options:nil];
        cell = [cells objectAtIndex:0];
    }
    XERecipesInfo *info = [_dateArray objectAtIndex:indexPath.row];
//    if (info.recipesImageUrl) {
//        [cell.infoImageView sd_setImageWithURL:[NSURL URLWithString:info.recipesImageUrl] placeholderImage:[UIImage imageNamed:@"tmp_avatar_icon"]];
//    }else{
//        [cell.infoImageView sd_setImageWithURL:nil];
        [cell.infoImageView setImage:[UIImage imageNamed:@"tmp_avatar_icon"]];
//    }
//    
    cell.titleLabel.text = info.title;
//    cell.readLabel.text  = info.readNum;
//    cell.collectLabel.text = info.favNum;
//    if ([info.isTop isEqual:@"1"]) {
//        cell.topImageView.hidden = NO;
//    }else{
//        cell.topImageView.hidden = YES;
//    }
    
//    //cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XERecipesInfo *recipesInfo = [_dateArray objectAtIndex:indexPath.row];
    
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(didTouchCellWithRecipesInfo:)]) {
        [_delegate didTouchCellWithRecipesInfo:recipesInfo];
    }
}

- (void)refreshAdsScrollView{
    
}


@end
