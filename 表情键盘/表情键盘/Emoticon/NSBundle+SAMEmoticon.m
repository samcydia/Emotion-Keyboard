//
//  NSBundle+SAMEmoticon.m
//  表情键盘
//
//  Created by samCydia on 16/3/3.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "NSBundle+SAMEmoticon.h"
#import "SAMEmoticonInputView.h"

NSString *const SAMEmoticonBundleName = @"SAMEmoticon.bundle";

@implementation NSBundle (SAMEmoticon)

+ (instancetype)SAM_emoticonBundle {
    
    NSBundle *bundle = [NSBundle bundleForClass:[SAMEmoticonInputView class]];
    NSString *bundlePath = [bundle pathForResource:SAMEmoticonBundleName ofType:nil];
    
    return [NSBundle bundleWithPath:bundlePath];
}

@end
