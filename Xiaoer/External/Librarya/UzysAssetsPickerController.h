//
//  UzysAssetsPickerController.h
//  UzysAssetsPickerController
//
//  Created by Uzysjung on 2014. 2. 12..
//  Copyright (c) 2014년 Uzys. All rights reserved.
//

// 版权属于原作者
// http://code4app.com(cn) http://code4app.net(en)
// 来源于最专业的源码分享网站: Code4App
#define kThumbnailLength    79.0f
#define kThumbnailLength_IPHONE6    78.0f + 15.0f
#define kThumbnailLength_IPHONE6P    78.0f + 24.5f
#define IS_IPHONE_6_IOS8 667.0f
#define kThumbnailSize_IPHONE6 CGSizeMake(kThumbnailLength_IPHONE6,kThumbnailLength_IPHONE6)
#define IS_IPHONE_6P_IOS8  736.0f
#define kThumbnailSize_IPHONE6P CGSizeMake(kThumbnailLength_IPHONE6P ,kThumbnailLength_IPHONE6P)

#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)

#import <UIKit/UIKit.h>
#import "UzysAssetsPickerController_Configuration.h"
@class UzysAssetsPickerController;
@protocol UzysAssetsPickerControllerDelegate<NSObject>
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
@optional
- (void)UzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker;
@end

@interface UzysAssetsPickerController : UIViewController
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionVideo;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionPhoto;
//--------------------------------------------------------------------
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionMedia;

@property (nonatomic, weak) id <UzysAssetsPickerControllerDelegate> delegate;
+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end
