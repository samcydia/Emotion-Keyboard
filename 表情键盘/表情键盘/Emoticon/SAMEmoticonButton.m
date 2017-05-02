//
//  SAMEmoticonButton.m
//  表情键盘
//
//  Created by samCydia on 16/3/5.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "SAMEmoticonButton.h"
#import "UIImage+SAMEmoticon.h"
#import "SAMEmoticon.h"

@implementation SAMEmoticonButton

#pragma mark - 属性
- (void)setDeleteButton:(BOOL)deleteButton {
    _deleteButton = deleteButton;
    
    [self setImage:[UIImage SAM_imageNamed:@"compose_emotion_delete"]
          forState:UIControlStateNormal];
    [self setImage:[UIImage SAM_imageNamed:@"compose_emotion_delete_highlighted"]
          forState:UIControlStateHighlighted];
}

- (void)setEmoticon:(SAMEmoticon *)emoticon {
    _emoticon = emoticon;
    
    self.hidden = (emoticon == nil);
    
    [self setImage:[UIImage SAM_imageNamed:emoticon.imagePath] forState:UIControlStateNormal];
    [self setTitle:emoticon.emoji forState:UIControlStateNormal];
}

#pragma mark - 构造函数
+ (instancetype)emoticonButtonWithFrame:(CGRect)frame tag:(NSInteger)tag {
    SAMEmoticonButton *button = [[self alloc] initWithFrame:frame];
    
    button.tag = tag;
    
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:32];
    }
    return self;
}

@end
