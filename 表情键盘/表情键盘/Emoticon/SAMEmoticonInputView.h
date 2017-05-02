//
//  SAMEmoticonInputView.h
//  表情键盘
//
//  Created by samCydia on 17/4/20.
//

#import <UIKit/UIKit.h>
#import "SAMEmoticonManager.h"

/// 表情输入视图
@interface SAMEmoticonInputView : UIView

/// 使用选中表情回调实例化表情输入视图
///
/// @param selectedEmoticon 选中表情回调(表情，是否删除）
///
/// @return 表情输入视图
- (nonnull instancetype)initWithSelectedEmoticon:(void (^ _Nonnull)(SAMEmoticon * _Nullable emoticon, BOOL isRemoved))selectedEmoticon;

@end
