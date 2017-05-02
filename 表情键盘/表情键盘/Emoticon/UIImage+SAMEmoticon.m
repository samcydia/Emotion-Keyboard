//
//  UIImage+SAMEmoticon.m
//  表情键盘
//
//  Created by samCydia on 16/3/3.
//  Copyright © 2017年 sam. All rights reserved.
//

#import "UIImage+SAMEmoticon.h"
#import "NSBundle+SAMEmoticon.h"

@implementation UIImage (SAMEmoticon)

+ (UIImage *)SAM_imageNamed:(NSString *)name {
    return [UIImage imageNamed:name
                      inBundle:[NSBundle SAM_emoticonBundle]
 compatibleWithTraitCollection:nil];
}

- (UIImage *)SAM_resizableImage {
    return [self resizableImageWithCapInsets:
            UIEdgeInsetsMake(self.size.height * 0.5,
                             self.size.width * 0.5,
                             self.size.height * 0.5,
                             self.size.width * 0.5)];
}

@end
