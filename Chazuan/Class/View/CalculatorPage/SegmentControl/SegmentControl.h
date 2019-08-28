//
//  SegmentControl.h
//  chazuan
//
//  Created by BecksZ on 2019/4/27.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SegmentViewModel : NSObject

@property (nonatomic, readwrite, strong) UIColor *tintColor;
@property (nonatomic, readwrite, strong) UIColor *color;
@property (nonatomic, readwrite, strong) UIColor *backTintColor;
@property (nonatomic, readwrite, strong) UIColor *backColor;
@property (nonatomic, readwrite, strong) UIColor *borderColor;
@property (nonatomic, readwrite, strong) UIFont *font;

@end

@interface SegmentControl : UIView

+ (instancetype)segmentWithItems:(NSArray *)items;

- (void)bindViewModel:(SegmentViewModel *)viewModel;

@property (nonatomic, readonly, assign) NSInteger selectIndex;

@end

NS_ASSUME_NONNULL_END
