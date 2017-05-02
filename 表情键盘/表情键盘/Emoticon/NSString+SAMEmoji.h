//
//  NSString+SAMEmoji.h
//  表情键盘
//
//  Created by samCydia on 16/3/4.
//  Copyright © 2017年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SAMEmoji)
/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithIntCode:(unsigned int)intCode;

/**
 *  将十六进制的编码转为emoji字符
 */
+ (NSString *)emojiWithStringCode:(NSString *)stringCode;
- (NSString *)emoji;

@end
