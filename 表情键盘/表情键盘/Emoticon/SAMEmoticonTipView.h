//
//  SAMEmoticonTipView.h
//  表情键盘
//
//  Created by samCydia on 16/3/5.
//  Copyright © 2017年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAMEmoticon;

/// 表情提示视图
@interface SAMEmoticonTipView : UIImageView
/// 表情模型
@property (nonatomic, nullable) SAMEmoticon *emoticon;
@end
