//
//  SAMEmoticonToolbar.h
//  表情键盘
//
//  Created by samCydia on 16/3/3.
//  Copyright © 2017年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SAMEmoticonToolbarDelegate;

@interface SAMEmoticonToolbar : UIView
@property (nonatomic, weak, nullable) id<SAMEmoticonToolbarDelegate> delegate;

/// 选中指定分组
///
/// @param section 分组
- (void)selectSection:(NSInteger)section;
@end

@protocol SAMEmoticonToolbarDelegate <NSObject>

/// 表情工具栏选中分组
///
/// @param section 分组
- (void)emoticonToolbarDidSelectSection:(NSInteger)section;

@end
