//
//  SAMEmoticonCell.h
//  表情键盘
//
//  Created by samCydia on 17/4/20.


#import <UIKit/UIKit.h>
@class SAMEmoticon;

@protocol SAMEmoticonCellDelegate;

/// 表情页 Cell，每个表情包含 20 个表情 + 1 个删除按钮
@interface SAMEmoticonCell : UICollectionViewCell

/// 代理
@property (nonatomic, weak, nullable) id<SAMEmoticonCellDelegate> delegate;
/// 表情数组
@property (nonatomic, nonnull) NSArray <SAMEmoticon *> *emoticons;

@end

@protocol SAMEmoticonCellDelegate <NSObject>

/// 选中表情
///
/// @param emoticon  表情模型，可选
/// @param isRemoved 删除按钮
- (void)emoticonCellDidSelectedEmoticon:(SAMEmoticon * _Nullable)emoticon isRemoved:(BOOL)isRemoved;

@end
