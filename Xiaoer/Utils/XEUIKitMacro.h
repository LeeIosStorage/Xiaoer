//
//  XEUIKitMacro.h
//  Xiaoer
//
//  Created by KID on 14/12/31.
//
//

#ifndef Xiaoer_XEUIKitMacro_h
#define Xiaoer_XEUIKitMacro_h

//将16进制颜色转换为uicolor
#define UIColorToRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//rgbColor
#define UIColorRGB(r,g,b)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

#endif
