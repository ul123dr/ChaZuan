//
//  NSString+ZGSize.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "NSString+ZGSize.h"

@implementation NSString (ZGSize)

/* 动态计算文字的宽高（单行）*/
- (CGSize)zgc_sizeWithFont:(UIFont *)font {
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    theSize = [self sizeWithAttributes:attributes];
    // 向上取整
    theSize.width = ceil(theSize.width);
    theSize.height = ceil(theSize.height);
    return theSize;
}

/* 动态计算文字的宽高（多行）*/
- (CGSize)zgc_sizeWithFont:(UIFont *)font limitSize:(CGSize)limitSize {
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [self boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    theSize.width = ceil(rect.size.width);
    theSize.height = ceil(rect.size.height);
    return theSize;
}

/* 动态计算文字的宽高（多行）*/
- (CGSize)zgc_sizeWithFont:(UIFont *)font limitWidth:(CGFloat)limitWidth {
    return [self zgc_sizeWithFont:font limitSize:CGSizeMake(limitWidth, MAXFLOAT)];
}

@end
