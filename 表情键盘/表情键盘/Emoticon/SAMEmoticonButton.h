//
//  SAMEmoticonButton.h
//  表情键盘
//
//  Created by samCydia on 16/3/5.
//  Copyright © 2017年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAMEmoticon;

/// 表情按钮
@interface SAMEmoticonButton : UIButton

+ (nonnull instancetype)emoticonButtonWithFrame:(CGRect)frame tag:(NSInteger)tag;
/// 是否删除按钮
@property (nonatomic, getter=isDeleteButton) BOOL deleteButton;
/// 表情模型
@property (nonatomic, nullable) SAMEmoticon *emoticon;

@end
