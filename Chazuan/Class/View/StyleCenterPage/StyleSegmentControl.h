//
//  StyleSegmentControl.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StyleSegmentControl : UIView

+ (instancetype)segmentControl:(StyleType)type;
//- (instancetype)initWithStyleType:(StyleType)type;

//@property (nonatomic, readwrite, assign) NSUInteger index;
@property (nonatomic, readwrite, strong) ZGButton *categoryBtn;
@property (nonatomic, readwrite, strong) RACSubject *styleSub;
- (void)resetSegment;

@end

NS_ASSUME_NONNULL_END
