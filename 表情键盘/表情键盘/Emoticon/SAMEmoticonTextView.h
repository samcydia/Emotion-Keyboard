//
//  SAMEmoticonTextView.h
//  表情键盘
//
//  Created by samCydia on 17/4/20.
//  Copyright © 2017年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SAMEmoticon;

IB_DESIGNABLE
@interface SAMEmoticonTextView : UITextView
/// nullable/nonnull 为了和 Swift 混合开发设置的，非常不好写！
/// Xcode 7 新的语法，对格式和是否有数据要求格外严格
/// 只要头文件中有一个地方使用了 nullable，所有的参数／属性／返回值都必须指定
/// 占位文本
@property (nonatomic, copy) IBInspectable NSString *placeholder;
/// 最大输入文本长度
@property (nonatomic) IBInspectable NSInteger maxInputLength;

/// 完整字符串，将表情符号转换为 [表情] 字符串
@property (nonatomic, readonly) NSString *emoticonText;

/// 在当前光标位置插入表情图片
///
/// @param emoticon  表情模型
/// @param isRemoved 是否删除
- (void)insertEmoticon:(SAMEmoticon * )emoticon isRemoved:(BOOL)isRemoved;

/// 更新长度提示标签底部约束
- (void)updateTipLabelBottomConstraints:(UIView *)view;

@end
