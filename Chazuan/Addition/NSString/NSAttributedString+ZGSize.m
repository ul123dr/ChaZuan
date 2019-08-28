//
//  NSAttributedString+ZGSize.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "NSAttributedString+ZGSize.h"

@implementation NSAttributedString (ZGSize)


/* 动态计算文字的宽高（多行）*/
- (CGSize)zgc_sizeWithLimitSize:(CGSize)limitSize {
    CGSize theSize;
    CGRect rect = [self boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    theSize.width = ceil(rect.size.width);
    theSize.height = ceil(rect.size.height);
    return theSize;
}

/* 动态计算文字的宽高（多行）*/
- (CGSize)zgc_sizeWithLimitWidth:(CGFloat)limitWidth {
    return [self zgc_sizeWithLimitSize:CGSizeMake(limitWidth, MAXFLOAT)];
}

@end
