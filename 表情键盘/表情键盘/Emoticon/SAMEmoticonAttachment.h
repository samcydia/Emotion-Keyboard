//
//  SAMEmoticonAttacSAMent.h
//  表情键盘
//
//  Created by samCydia on 17/4/20.
//  Copyright © 2017年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAMEmoticon;

@interface SAMEmoticonAttacSAMent : NSTextAttachment
@property (nonatomic, nullable) NSString *text;

/// 使用表情模型创建表情字符串
///
/// @param emoticon 表情模型
/// @param font     字体
///
/// @return 属性文本
+ (NSAttributedString * _Nonnull)emoticonStringWithEmoticon:(SAMEmoticon * _Nullable)emoticon font:(UIFont * _Nonnull)font;

@end
