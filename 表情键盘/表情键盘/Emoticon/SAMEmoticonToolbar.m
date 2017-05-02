//
//  SAMEmoticonToolbar.m
//  表情键盘
//
//  Created by samCydia on 16/3/3.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "SAMEmoticonToolbar.h"
#import "UIImage+SAMEmoticon.h"
#import "SAMEmoticonManager.h"

/// 按钮 tag 起始数值
static NSInteger kEmoticonToolbarTagBaseValue = 1000;

@implementation SAMEmoticonToolbar {
    UIButton *_selectedButton;
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 计算分组按钮位置
    CGRect rect = self.bounds;
    CGFloat w = rect.size.width / self.subviews.count;
    rect.size.width = w;
    
    int index = 0;
    for (UIView *v in self.subviews) {
        v.frame = CGRectOffset(rect, index++ * w, 0);
    }
}

#pragma mark - 公共方法
- (void)selectSection:(NSInteger)section {
    UIButton *button = [self viewWithTag:(section + kEmoticonToolbarTagBaseValue)];
    
    [self selectedButtonWithButton:button];
}

#pragma mark - 监听方法
/// 点击工具栏按钮
- (void)clickToolbarButton:(UIButton *)button {
    if (button == _selectedButton) {
        return;
    }
    [self selectedButtonWithButton:button];
    
    [self.delegate emoticonToolbarDidSelectSection:button.tag - kEmoticonToolbarTagBaseValue];
}

/// 将指定的按钮设置为选中按钮
- (void)selectedButtonWithButton:(UIButton *)button {
    button.selected = !button.selected;
    _selectedButton.selected = !_selectedButton.selected;
    _selectedButton = button;
}

#pragma mark - 设置界面
- (void)prepareUI {
    
    NSArray *packages = [SAMEmoticonManager sharedManager].packages;
    
    // 创建按钮
    NSInteger index = 0;
    for (SAMEmoticonPackage *package in packages) {
        [self addChildButton:package.groupName bgImageName:package.bgImageName type:index++];
    }
}

- (void)addChildButton:(NSString *)title bgImageName:(NSString *)bgImageName type:(NSInteger)type {
    UIButton *btn = [[UIButton alloc] init];
    
    btn.tag = type + kEmoticonToolbarTagBaseValue;
    
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    NSString *imageName = [NSString stringWithFormat:@"compose_emotion_table_%@_normal", bgImageName];
    NSString *imageNameSL = [NSString stringWithFormat:@"compose_emotion_table_%@_selected", bgImageName];
    
    [btn setBackgroundImage:[[UIImage SAM_imageNamed:imageName] SAM_resizableImage] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage SAM_imageNamed:imageNameSL] SAM_resizableImage] forState:UIControlStateSelected];
    
    [btn addTarget:self action:@selector(clickToolbarButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
}

@end
