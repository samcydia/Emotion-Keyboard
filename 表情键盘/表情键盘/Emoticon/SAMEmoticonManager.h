//
//  SAMEmoticonManager.h
//  表情键盘
//
//  Created by samCydia on 16/3/3.
//  Copyright © 2017年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMEmoticonPackage.h"

/// 表情工具类 - 提供表情视图的所有数据及处理逻辑
@interface SAMEmoticonManager : NSObject

/// 表情管理器单例
+ (nonnull instancetype)sharedManager;

/// 将指定字符串内容转换成带表情图片的属性文本
///
/// @param string 字符串
/// @param font   属性字符串使用的字体
///
/// @return 带表情符号的属性文本
- (NSAttributedString * _Nonnull)emoticonStringWithString:(NSString * _Nonnull)string font:(UIFont * _Nonnull)font;

/// 表情包数组
@property (nonatomic, nonnull) NSMutableArray <SAMEmoticonPackage *>*packages;
/// 用户标识符，默认是 cn.sam.DefaultUser
@property (nonatomic, copy, nonnull) NSString *userIdentifier;

#pragma mark - 数据源方法
/// 返回 section 对应的表情包中包含表情页数
///
/// @param section 表情分组下标
///
/// @return 对应页数
- (NSInteger)numberOfPagesInSection:(NSInteger)section;

/// 根据 indexPath 返回对应分页的表情模型数组，每页 20 个
///
/// @param indexPath indexPath
///
/// @return 表情模型数组
- (nonnull NSArray *)emoticonsWithIndexPath:(NSIndexPath * _Nonnull)indexPath;

#pragma mark - 最近使用表情
/// 添加最近使用表情
///
/// @param emoticon 表情模型
- (void)addRecentEmoticon:(SAMEmoticon * _Nonnull)emoticon;

@end
