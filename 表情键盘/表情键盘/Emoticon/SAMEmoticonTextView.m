//
//  SAMEmoticonTextView.m
//  表情键盘
//
//  Created by samCydia on 17/4/20.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "SAMEmoticonTextView.h"
#import "SAMEmoticonManager.h"
#import "SAMEmoticonAttachment.h"
#import "UIImage+SAMEmoticon.h"

@implementation SAMEmoticonTextView {
    UILabel *_placeHolderLabel;
    UILabel *_lengthTipLabel;
    NSMutableArray <NSLayoutConstraint *> *_lengthTipLabelCons;
}

#pragma mark - 设置属性
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder.copy;
    _placeHolderLabel.text = _placeholder;
}

- (void)setMaxInputLength:(NSInteger)maxInputLength {
    _maxInputLength = maxInputLength;
    
    [self textChanged];
}

- (void)setFont:(UIFont *)font {
    _placeHolderLabel.font = font;
    
    [super setFont:font];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    [self textChanged];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self textChanged];
}

#pragma mark - 构造函数
- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 公共函数
/// 将当前文本框中的属性文本转换成[符号]文本
/// 目的是向服务器发送
- (NSString *)emoticonText {
    
    NSLog(@"%@", self.attributedText);
    
    // 1. 创建可变字符串
    NSMutableString *stringM = [NSMutableString string];
    
    NSRange range = NSMakeRange(0, self.attributedText.length);
    [self.attributedText enumerateAttributesInRange:range options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
       
//        NSLog(@"---");
//        NSLog(@"%@ %@", attrs, NSStringFromRange(range));
        // 如果 attrs 字典中 包含 NSAttacSAMent Key 说明是图片
        SAMEmoticonAttacSAMent *attacSAMent = attrs[@"NSAttacSAMent"];
        
        if (attacSAMent != nil) {
            // 如果是图片，从 attacSAMent 中获取到 `text[马上有对象]`
            NSLog(@"%@", attacSAMent.text);
            [stringM appendString:attacSAMent.text];
        } else {
            // 否则是文本，从 range 获得子字符串
            NSLog(@"%@", [self.attributedText.string substringWithRange:range]);
            [stringM appendString:[self.attributedText.string substringWithRange:range]];
        }
    }];
    
    return stringM.copy;
}

- (void)insertEmoticon:(SAMEmoticon *)emoticon isRemoved:(BOOL)isRemoved {
    
    if (isRemoved) {
        [self deleteBackward];
        
        return;
    }
    
    // 表情模型中只有两种类型
    if (emoticon.isEmoji) {
        [self replaceRange:[self selectedTextRange] withText:emoticon.emoji];
        
        return;
    }
    // 图片表情
    NSLog(@"%@", emoticon);
    
    // 1. 获取文本框当前的属性文本 - 变成`可变`类型
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    // 2. 根据模型，生成对应的属性文本
    SAMEmoticonAttacSAMent *attacSAMent = [[SAMEmoticonAttacSAMent alloc] init];
    
    // !!! - 设置 attacSAMent 的文本
    attacSAMent.text = emoticon.chs;
    
    attacSAMent.image = [UIImage SAM_imageNamed:emoticon.imagePath];
    CGFloat lineHeight = self.font.lineHeight;
    attacSAMent.bounds = CGRectMake(0, -4, lineHeight, lineHeight);
    
    // 只是创建了一个单纯的图片属性文本，里面不包含任何的字体信息
    // 如果在这个文本后面插入文字，会使用默认的字体
    NSAttributedString *emoticonStr = [NSAttributedString attributedStringWithAttachment:attacSAMent];
    // 插入文字时，会默认跟随前一个字符的字体
    // 1> 设置图片属性文本的字体
    NSMutableAttributedString *emoticonMutableStr = [[NSMutableAttributedString alloc] initWithAttributedString:emoticonStr];
    // 2> 设置字体，只有`一张图片`，对应一个字符长度
    [emoticonMutableStr addAttribute:NSFontAttributeName value:[self font] range:NSMakeRange(0, 1)];
    
    // 3. 将图片的属性文本插入到 可变属性文本中
    // 1> 替换图片文本
    [attributedText replaceCharactersInRange:[self selectedRange] withAttributedString:emoticonMutableStr];
    
    // 2> 记录当前文本视图光标位置(选中文本的范围)
    NSRange range = [self selectedRange];
    // 3> 重新设置属性文本
    self.attributedText = attributedText.copy;
    
    // 4> 恢复光标位置 - range 中的 length 表示选中文本的长度
    self.selectedRange = NSMakeRange(range.location + 1, 0);
}

- (void)updateTipLabelBottomConstraints:(UIView *)view {
    
    /// 判断 view 是否是当前的子视图
    if (![self.subviews containsObject:view]) {
        NSLog(@"当前仅支持相对 textView 子视图的控件参照");
        return;
    }
    
    [self removeConstraints:_lengthTipLabelCons];
    
    [_lengthTipLabelCons removeAllObjects];
    CGFloat margin = 5;
    [_lengthTipLabelCons addObject:[NSLayoutConstraint
                                    constraintWithItem:_lengthTipLabel
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                    constant:-margin]];
    [_lengthTipLabelCons addObject:[NSLayoutConstraint
                                    constraintWithItem:_lengthTipLabel
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:view
                                    attribute:NSLayoutAttributeTop
                                    multiplier:1.0
                                    constant:-margin]];
    
    [self addConstraints:_lengthTipLabelCons];
}

#pragma mark - 监听方法
- (void)textChanged {
    _placeHolderLabel.hidden = self.hasText;
    
    NSInteger len = _maxInputLength - self.emoticonText.length;
    _lengthTipLabel.text = [NSString stringWithFormat:@"%zd", len];
    _lengthTipLabel.textColor = (len >= 0) ? [UIColor lightGrayColor] : [UIColor redColor];
}

#pragma mark - 设置界面
- (void)prepareUI {
    // 1. 注册文本变化通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(textChanged)
     name:UITextViewTextDidChangeNotification object:nil];
    
    // 2. 默认属性
    self.textColor = [UIColor darkGrayColor];
    self.font = [UIFont systemFontOfSize:18];
    
    self.alwaysBounceVertical = YES;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // 3. 尺寸视图
    UIView *sizeView = [[UIView alloc] init];
    sizeView.backgroundColor = [UIColor clearColor];
    sizeView.userInteractionEnabled = NO;
    
    [self insertSubview:sizeView atIndex:0];
    
    sizeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[sizeView]-0-|"
                          options:0
                          metrics:nil
                          views:@{@"sizeView": sizeView}]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[sizeView]-0-|"
                          options:0
                          metrics:nil
                          views:@{@"sizeView": sizeView}]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:sizeView
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:1.0
                         constant:0]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:sizeView
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeHeight
                         multiplier:1.0
                         constant:0]];
    
    // 4. 占位标签
    _placeHolderLabel = [[UILabel alloc] init];
    _placeHolderLabel.text = _placeholder;
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    _placeHolderLabel.font = self.font;
    _placeHolderLabel.numberOfLines = 0;
    
    [self addSubview:_placeHolderLabel];
    
    _placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat leftOffset = 5;
    CGFloat topOffset = 8;
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_placeHolderLabel
                         attribute:NSLayoutAttributeLeading
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeLeading
                         multiplier:1.0
                         constant:leftOffset]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_placeHolderLabel
                         attribute:NSLayoutAttributeTop
                         relatedBy:NSLayoutRelationEqual
                         toItem:self
                         attribute:NSLayoutAttributeTop
                         multiplier:1.0
                         constant:topOffset]];
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:_placeHolderLabel
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationLessThanOrEqual
                         toItem:self
                         attribute:NSLayoutAttributeWidth
                         multiplier:1.0
                         constant:-2 * leftOffset]];
    
    // 5. 长度提示标签
    _lengthTipLabel = [[UILabel alloc] init];
    _lengthTipLabel.text = [NSString stringWithFormat:@"%zd", _maxInputLength];
    _lengthTipLabel.textColor = [UIColor lightGrayColor];
    _lengthTipLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:_lengthTipLabel];
    
    _lengthTipLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _lengthTipLabelCons = [NSMutableArray array];
    [_lengthTipLabelCons addObject:[NSLayoutConstraint
                                    constraintWithItem:_lengthTipLabel
                                    attribute:NSLayoutAttributeTrailing
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                    attribute:NSLayoutAttributeTrailing
                                    multiplier:1.0
                                    constant:-leftOffset]];
    [_lengthTipLabelCons addObject:[NSLayoutConstraint
                                    constraintWithItem:_lengthTipLabel
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                    attribute:NSLayoutAttributeBottom
                                    multiplier:1.0
                                    constant:-leftOffset]];
    
    [self addConstraints:_lengthTipLabelCons];
}

@end
