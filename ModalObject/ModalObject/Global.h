//
//  Global.h
//  
//
//  Created by wang yepin on 12-11-5.
//  Copyright (c) 2012年 wang yepin. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(DEBUG)
#define NSLog_infor(format, ...)  NSLog(@"[INFOR][<%@:(%d)> %s] " format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define NSLog_debug(format, ...)  NSLog(@"[DEBUG][<%@:(%d)> %s] " format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#define NSLog_error(format, ...)  NSLog(@"[ERROR][<%@:(%d)> %s] " format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define NSLog_infor(format, ...)  
#define NSLog_debug(format, ...) 
#define NSLog_error(format, ...) NSLog(@"[ERROR][<%@:(%d)> %s] " format, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#endif



#define RgbColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]