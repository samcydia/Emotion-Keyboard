//
//  SAMEmoticonTipView.m
//  表情键盘
//
//  Created by samCydia on 16/3/5.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "SAMEmoticonTipView.h"
#import "UIImage+SAMEmoticon.h"
#import "SAMEmoticonButton.h"

@implementation SAMEmoticonTipView {
    SAMEmoticonButton *_tipButton;
}

#pragma mark - 属性
- (void)setEmoticon:(SAMEmoticon *)emoticon {
    
    if (_tipButton.emoticon == emoticon) {
        return;
    }
    
    _tipButton.emoticon = emoticon;
    
    CGPoint center = _tipButton.center;
    _tipButton.center = CGPointMake(center.x, center.y + 16);
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.4
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _tipButton.center = center;
                     }
                     completion:nil];
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithImage:[UIImage SAM_imageNamed:@"emoticon_keyboard_magnifier"]];
    if (self) {
        // 计算按钮大小
        CGFloat width = 32;
        CGFloat x = (self.bounds.size.width - width) * 0.5;
        CGRect rect = CGRectMake(x, 8, width, width);
        
        _tipButton = [SAMEmoticonButton emoticonButtonWithFrame:rect tag:0];
        [self addSubview:_tipButton];
    }
    return self;
}

@end
