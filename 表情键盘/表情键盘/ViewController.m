//
//  ViewController.m
//  表情键盘
//
//  Created by samCydia on 17/4/20.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "ViewController.h"
#import "SAMEmoticonTextView.h"
#import "SAMEmoticonInputView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet SAMEmoticonTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 通过表情描述字符串设置属性字符串
    NSString *text = @"[爱你]啊[笑哈哈]";
    NSAttributedString *attributeText = [[SAMEmoticonManager sharedManager]
                                         emoticonStringWithString:text
                                         font:_textView.font];
    _textView.attributedText = attributeText;
    
    // 2. 设置用户标示 - 用于保存最近使用表情
    [SAMEmoticonManager sharedManager].userIdentifier = @"刀哥";
    
    // 3. 设置表情输入视图
    __weak typeof(self) weakSelf = self;
    _textView.inputView = [[SAMEmoticonInputView alloc] initWithSelectedEmoticon:^(SAMEmoticon * _Nullable emoticon, BOOL isRemoved) {
        [weakSelf.textView insertEmoticon:emoticon isRemoved:isRemoved];
    }];
    // 测试断言
    //_textView.inputView = [[SAMEmoticonInputView alloc] initWithFrame:CGRectMake(0, 0, 100, 0)];
    
    // 4. 监听键盘通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillChanged:)
     name:UIKeyboardWillChangeFrameNotification
     object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_textView becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)showText:(id)sender {
    NSLog(@"%@", _textView.emoticonText);
}

- (void)keyboardWillChanged:(NSNotification *)notification {
    
    CGRect rect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSInteger curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    _bottomConstraint.constant = self.view.bounds.size.height - rect.origin.y;
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:curve];
        
        [self.view layoutIfNeeded];
    }];
}

@end
