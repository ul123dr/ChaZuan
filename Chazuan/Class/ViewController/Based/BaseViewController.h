//
//  BaseViewController.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController <YPNavigationBarConfigureStyle>

@property (nonatomic, readonly, strong) BaseViewModel *viewModel;

@property (nonatomic, readwrite, strong) UIView *snapshot;

- (instancetype)initWithViewModel:(BaseViewModel *)viewModel;

- (void)bindViewModel;

- (void)showTipView:(UIView *)fatherView andMessage:(NSString *)message andImgPath:(nullable NSString *)imageName andBlock:(nullable VoidBlock)handle;
- (void)showTipView:(UIView *)fatherView andMessage:(NSString *)message andOffset:(CGFloat)offset;

- (void)hiddenTipView;

@end

NS_ASSUME_NONNULL_END
