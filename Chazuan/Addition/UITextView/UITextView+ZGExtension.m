//
//  UITextView+ZGExtension.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "UITextView+ZGExtension.h"

@implementation UITextView (ZGExtension)

- (void)zgc_limitMaxLength:(NSInteger)maxLength {
    
    @weakify(self);
    [[[RACSignal merge:@[RACObserve(self, text),self.rac_textSignal]] skip:0] subscribeNext:^(NSString * text) {
        @strongify(self);
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
        if (position) return ;
        if (text.length <= maxLength) return;
        
        // 中文和emoj表情存在问题，需要对此进行处理
        NSRange range;
        NSUInteger inputLength = 0;
        for(int i =0 ; i < text.length && inputLength <= maxLength; i += range.length){
            range = [self.text rangeOfComposedCharacterSequenceAtIndex:i];
            inputLength += [text substringWithRange:range].length;
            if (inputLength > maxLength) self.text = [text substringWithRange:NSMakeRange(0, range.location)];
        }
    }];
}

@end
