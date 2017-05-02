//
//  SAMEmoticonAttacSAMent.m
//  表情键盘
//
//  Created by samCydia on 17/4/20.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "SAMEmoticonAttachment.h"
#import "SAMEmoticon.h"
#import "UIImage+SAMEmoticon.h"

@implementation SAMEmoticonAttacSAMent

- (instancetype)initWithEmoticon:(SAMEmoticon *)emoticon font:(UIFont *)font {
    self = [super init];
    if (self) {
        _text = emoticon.chs;
        
        self.image = [UIImage SAM_imageNamed:emoticon.imagePath];
        CGFloat lineHeight = font.lineHeight;
        self.bounds = CGRectMake(0, -4, lineHeight, lineHeight);
    }
    return self;
}

+ (NSAttributedString *)emoticonStringWithEmoticon:(SAMEmoticon *)emoticon font:(UIFont *)font {
    
    SAMEmoticonAttacSAMent *attacSAMent = [[SAMEmoticonAttacSAMent alloc] initWithEmoticon:emoticon font:font];
    
    NSMutableAttributedString *emoticonStr = [[NSMutableAttributedString alloc] initWithAttributedString:
                                              [NSAttributedString attributedStringWithAttachment:attacSAMent]];
    [emoticonStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 1)];
    
    return emoticonStr.copy;
}

@end
