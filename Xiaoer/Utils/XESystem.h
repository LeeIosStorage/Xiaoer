//
//  XESystem.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#ifndef Xiaoer_XESystem_h
#define Xiaoer_XESystem_h

#import "XEUIKitMacro.h"
#import "NSDictionary+ObjectForKey.h"

//友盟参数
#define UMS_APP                         @"54aa3f96fd98c551990006a6"
#define UMS_QQ_ID                       @"1102848470"
#define UMS_QQ_Key                      @"EbxqpOpdEUk3BPfe"
#define UMS_WX_ID                       @"wx521006e5839528d0"
#define UMS_WX_Key                      @"d3b3e52d012832db6641cafd1fe229ea"
#define Sina_RedirectURL                @"sina.54aa3f96fd98c551990006a6://"

#define SINGLE_CELL_HEIGHT 44.f
#define SINGLE_HEADER_HEADER 6.f

#define XE_IMAGE_COMPRESSION_QUALITY 0.4

// 自定义Log
#ifdef DEBUG
#define XELog(...) NSLog(__VA_ARGS__)
#else
#define XELog(...)
#endif

#endif
