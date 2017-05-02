//
//  SAMEmoticonInputView.m
//  表情键盘
//
//  Created by samCydia on 17/4/20.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "SAMEmoticonInputView.h"
#import "SAMEmoticonToolbar.h"
#import "UIImage+SAMEmoticon.h"
#import "SAMEmoticonManager.h"
#import "SAMEmoticonCell.h"

/// 表情 Cell 可重用标识符号
NSString *const SAMEmoticonCellIdentifier = @"SAMEmoticonCellIdentifier";

#pragma mark - 表情键盘布局
@interface SAMEmoticonKeyboardLayout : UICollectionViewFlowLayout

@end

@implementation SAMEmoticonKeyboardLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    self.itemSize = self.collectionView.bounds.size;
    self.minimumInteritemSpacing = 0;
    self.minimumLineSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.bounces = NO;
}

@end

#pragma mark - 表情输入视图
@interface SAMEmoticonInputView() <UICollectionViewDataSource, UICollectionViewDelegate, SAMEmoticonToolbarDelegate, SAMEmoticonCellDelegate>

@end

@implementation SAMEmoticonInputView {
    UICollectionView *_collectionView;
    SAMEmoticonToolbar *_toolbar;
    UIPageControl *_pageControl;
    
    void (^_selectedEmoticonCallBack)(SAMEmoticon * _Nullable, BOOL);
}

#pragma mark - 构造函数
- (instancetype)initWithSelectedEmoticon:(void (^)(SAMEmoticon * _Nullable, BOOL))selectedEmoticon {
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height = 258;
    
    self = [super initWithFrame:frame];
    if (self) {
        _selectedEmoticonCallBack = selectedEmoticon;
        
        [self prepareUI];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
        [_collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:NO];
        [self updatePageControlWithIndexPath:indexPath];
        [_toolbar selectSection:indexPath.section];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    // NSAssert 断言，提前预判某些条件成立
    // 如果不成立，直接崩溃，抛出异常
    // 断言的使用，非常利于团队开发！有经验的程序猿非常喜欢，C/C++的程序猿的最爱！
    NSAssert(frame.size.width > 0, @"请调用 initWithSelectedEmoticon: 实例化表情输入视图");
    return nil;
}

#pragma mark - SAMEmoticonToolbarDelegate
- (void)emoticonToolbarDidSelectSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    
    [_collectionView scrollToItemAtIndexPath:indexPath
                            atScrollPosition:UICollectionViewScrollPositionLeft
                                    animated:NO];
    [self updatePageControlWithIndexPath:indexPath];
}

#pragma mark - SAMEmoticonCellDelegate
- (void)emoticonCellDidSelectedEmoticon:(SAMEmoticon *)emoticon isRemoved:(BOOL)isRemoved {
    if (_selectedEmoticonCallBack != nil) {
        _selectedEmoticonCallBack(emoticon, isRemoved);
    }
    
    /// 添加最近使用表情
    if (emoticon != nil) {
        [[SAMEmoticonManager sharedManager] addRecentEmoticon:emoticon];
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
/// 分组 - 表情包的数量(4个表情包)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [SAMEmoticonManager sharedManager].packages.count;
}

/// 每个分组对应的页面数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[SAMEmoticonManager sharedManager] numberOfPagesInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SAMEmoticonCell *cell = [collectionView
                            dequeueReusableCellWithReuseIdentifier:SAMEmoticonCellIdentifier
                            forIndexPath:indexPath];
    
    cell.emoticons = [[SAMEmoticonManager sharedManager] emoticonsWithIndexPath:indexPath];
    cell.delegate = self;
    
    return cell;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint center = scrollView.center;
    center.x += scrollView.contentOffset.x;
    
    NSArray *indexPaths = [_collectionView indexPathsForVisibleItems];
    
    NSIndexPath *targetPath = nil;
    for (NSIndexPath *indexPath in indexPaths) {
        UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
        
        if (CGRectContainsPoint(cell.frame, center)) {
            targetPath = indexPath;
            break;
        }
    }
    
    if (targetPath != nil) {
        [self updatePageControlWithIndexPath:targetPath];
        [_toolbar selectSection:targetPath.section];
    }
}

- (void)updatePageControlWithIndexPath:(NSIndexPath *)indexPath {
    _pageControl.numberOfPages = [[SAMEmoticonManager sharedManager] numberOfPagesInSection:indexPath.section];
    _pageControl.currentPage = indexPath.item;
}

#pragma mark - 设置界面
- (void)prepareUI {
    // 1. 基本属性设置
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage SAM_imageNamed:@"emoticon_keyboard_background"]];
    
    // 2. 添加工具栏
    _toolbar = [[SAMEmoticonToolbar alloc] init];
    [self addSubview:_toolbar];
    
    // 设置工具栏位置
    CGFloat toolbarHeight = 42;
    CGRect toolbarRect = self.bounds;
    toolbarRect.origin.y = toolbarRect.size.height - toolbarHeight;
    toolbarRect.size.height = toolbarHeight;
    _toolbar.frame = toolbarRect;
    
    _toolbar.delegate = self;
    
    // 3. 添加 collectionView
    CGRect collectionViewRect = self.bounds;
    collectionViewRect.size.height -= toolbarHeight;
    _collectionView = [[UICollectionView alloc]
                       initWithFrame:collectionViewRect
                       collectionViewLayout:[[SAMEmoticonKeyboardLayout alloc] init]];
    [self addSubview:_collectionView];
    
    // 设置 collectionView
    _collectionView.backgroundColor = [UIColor clearColor];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[SAMEmoticonCell class] forCellWithReuseIdentifier:SAMEmoticonCellIdentifier];
    
    // 4. 分页控件
    _pageControl = [[UIPageControl alloc] init];
    [self addSubview:_pageControl];
    
    // 设置分页控件
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    
    // KVC 设置图像，key 带下划线，私有的成员变量
    [_pageControl setValue:[UIImage SAM_imageNamed:@"compose_keyboard_dot_selected"] forKey:@"_currentPageImage"];
    [_pageControl setValue:[UIImage SAM_imageNamed:@"compose_keyboard_dot_normal"] forKey:@"_pageImage"];
    
    // 分页控件的大小会随着表情页数的增加而变化，因此使用自动布局
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_toolbar
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
}

@end
