//
//  XECustomerWindow.m
//  Xiaoer
//
//  Created by KID on 15/1/26.
//
//

#import "XECustomerWindow.h"

#import "WXApi.h"

#import "/Users/wangpeng/Xiaoer/Xiaoer/External/UMeng/UMSocial_Sdk_Extra_Frameworks/TencentOpenAPI/TencentOpenAPI.framework/Headers/QQApi.h"



#define Share_To_Item_Base_Tag 10
#define Share_To_Item_Name @"op"
#define Share_To_Item_Icon @"icon"
#define Share_To_Item_Disabed @"disabled"
#define Share_To_Item_Icon_Hilight @"iconHighLight"

@interface XECustomerWindow ()
@property (strong, nonatomic) IBOutlet UIView *sheetShareView;
@property (strong, nonatomic) IBOutlet UIView *sheetOperateView;
@property (strong, nonatomic) IBOutlet UIScrollView *sheetScrollOP;
@property (strong, nonatomic) IBOutlet UIButton *collectBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
//@property (strong, nonatomic) IBOutlet UIScrollView *sheetShareScrollOP;

@property (strong, nonatomic) NSMutableArray *shareToItemArray;
@end

@implementation XECustomerWindow

float gap = 18, width = 54;
float labelColor = 170/255.0;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"XECustomerWindow delloc \n\n\n\n");
    _sheetDelg = nil;
//    _operateArray = nil;
}

-(void)setDeleteBtnHidden:(BOOL)deleteBtnHidden{
    _deleteBtnHidden = deleteBtnHidden;
}
-(void)setShareSectionHidden:(BOOL)shareSectionHidden{
    _shareSectionHidden = shareSectionHidden;
}
-(void)setCollectBtnHidden:(BOOL)collectBtnHidden{
    _collectBtnHidden = collectBtnHidden;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

///添加item
-(void)addItem:(UIView *)superView index:(int) index tagBase:(int)tagBase contentWidth:(float *) contentWidth params:(NSDictionary *) params
{
    gap = ([UIScreen mainScreen].bounds.size.width - 23*2 -width*4)/3;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(23+(gap+width)*index, 0, width, width);//top-35
    btn.tag = tagBase+index;
    [btn setImage:[UIImage imageNamed:[params stringObjectForKey:Share_To_Item_Icon]] forState:UIControlStateNormal];
    if ([params stringObjectForKey:Share_To_Item_Icon_Hilight]) {
        [btn setImage:[UIImage imageNamed:[params stringObjectForKey:Share_To_Item_Icon_Hilight]] forState:UIControlStateHighlighted];
    }
//    labelColor = (1.0*0x50)/0xff;
    if ([params stringObjectForKey:Share_To_Item_Disabed] && [[params stringObjectForKey:Share_To_Item_Disabed] boolValue]) {
        btn.enabled = NO;
        labelColor = 187.0/255;
    }
    
    CGRect lframe = btn.frame;
    lframe.origin.x -= 10;
    lframe.size.width += 20;
    lframe.size.height = 12;
    lframe.origin.y += width + 5;
    UILabel *label = [[UILabel alloc] initWithFrame:lframe];
    label.text = [params stringObjectForKey:Share_To_Item_Name];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithRed:labelColor green:labelColor blue:labelColor alpha:1];
    label.shadowOffset = CGSizeMake(0, -1);
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:btn];
    [superView addSubview:label];
    *contentWidth = lframe.origin.x+lframe.size.width;
}

-(void)setCustomerSheet{
    self.windowLevel = UIWindowLevelStatusBar + 3.0f;
    self.frame = [UIScreen mainScreen].bounds;
    CGRect sframe = CGRectMake(0, 0, self.frame.size.width, 0);
    UIView *cview = [[UIView alloc] initWithFrame:sframe];
    cview.autoresizingMask = UIViewAutoresizingFlexibleWidth & UIViewAutoresizingFlexibleTopMargin;
    float color = (1.0*0xf8)/0xff;
    cview.backgroundColor = [UIColor colorWithRed:color green:color blue:color alpha:1];
    
    
    float marignTop = 0;
    CGRect oframe = _sheetShareView.frame;
    if (!_shareSectionHidden){
        //分享item
        _shareToItemArray = [NSMutableArray array];
        
//        [_shareToItemArray addObject:@{Share_To_Item_Name: @"微博", Share_To_Item_Icon:@"share_sina_icon"}];
        [_shareToItemArray addObject:@{Share_To_Item_Name: @"微信好友", Share_To_Item_Icon:@"share_wx_friend_icon"}];
        [_shareToItemArray addObject:@{Share_To_Item_Name: @"朋友圈", Share_To_Item_Icon:@"share_wx_circle_icon"}];
        if ([QQApi isQQInstalled] && [QQApi isQQSupportApi]) {
            [_shareToItemArray addObject:@{Share_To_Item_Name: @"QQ", Share_To_Item_Icon:@"share_qq_icon"}];
        }
        
        
        oframe.size.width = cview.frame.size.width;
        _sheetShareView.frame = oframe;
        [cview addSubview:_sheetShareView];
        marignTop = _sheetShareView.frame.size.height;
        sframe.size.height += marignTop;
        cview.frame = sframe;
        
        int i=0;
        float contentWidth= 0;
        for (NSDictionary *dic in _shareToItemArray) {
            [self addItem:_sheetScrollOP index:i tagBase:Share_To_Item_Base_Tag contentWidth:&contentWidth params:dic];
            i++;
        }
        
        [_sheetScrollOP setContentSize:CGSizeMake(contentWidth, _sheetScrollOP.frame.size.height)];
        if (_shareToItemArray.count > 4) {
            [_sheetScrollOP setShowsHorizontalScrollIndicator:YES];
            [_sheetScrollOP setScrollEnabled:YES];
        }else{
            [_sheetScrollOP setScrollEnabled:NO];
        }
    }
    
    CGFloat sheetOperateViewHeight = 106;
    _collectBtn.hidden = NO;
    _deleteBtn.hidden = YES;
    if (!_deleteBtnHidden) {
        _deleteBtn.hidden = NO;
        [_deleteBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        sheetOperateViewHeight = 65;
    }
    if (!_collectBtnHidden) {
        [_collectBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_collectBtn setTitle:_collectBtnTitle forState:0];
    }else{
        _collectBtn.hidden = YES;
        sheetOperateViewHeight = 65;
    }
    
    
    oframe = _sheetOperateView.frame;
    oframe.origin.y = marignTop;
    oframe.size.width = cview.frame.size.width;
    oframe.size.height = sheetOperateViewHeight;
    _sheetOperateView.frame = oframe;
    [cview addSubview:_sheetOperateView];
    marignTop += oframe.size.height;
    
    sframe.origin.y = self.frame.size.height;
    sframe.size.height = marignTop;
    cview.frame = sframe;
    [self addSubview:cview];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:.2 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        
        CGRect sframe = cview.frame;
        sframe.origin.y -= sframe.size.height;
        cview.frame = sframe;
    }];
    [self makeKeyAndVisible];
}

-(void)clickBtn:(id)sender{
    [self cancelActionSheet:nil];
    UIButton *btn = sender;
    NSIndexPath *indexP;
    indexP = [NSIndexPath indexPathForRow:btn.tag%10 inSection:btn.tag/10];
    if (_sheetDelg && [_sheetDelg respondsToSelector:@selector(customerWindowClickAt:action:)]) {
        NSString *action = nil;
        if (indexP.section == 2) {
            if (indexP.row == 0) {
                action = @"collectButtonAction";
            }else if (indexP.row == 1){
                action = @"deleteButtonAction";
            }
            
        }
        [_sheetDelg customerWindowClickAt:indexP action:action];
    }
    
    _sheetDelg = nil;
}

-(void)cancelActionSheet:(id)sender{
    UIView *sheet = [_sheetOperateView superview];
    
    [UIView animateWithDuration:.2 animations:^{
        [sheet superview].backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        CGRect sframe = sheet.frame;
        sframe.origin.y += sframe.size.height;
        sheet.frame = sframe;
    } completion:^(BOOL finished) {
        UIWindow * supperWindow = (UIWindow*)[sheet superview];
        //        [supperWindow resignKeyWindow];
        supperWindow.hidden = YES;
        //        [[sheet superview] removeFromSuperview];
    }];
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    UIView *sheet = [_sheetOperateView superview];
    float blank_max_y = [[UIScreen mainScreen] bounds].size.height-sheet.frame.size.height;
    if (currentLocation.y<blank_max_y) {
        [self cancelActionSheet:nil];
    }
}

@end
