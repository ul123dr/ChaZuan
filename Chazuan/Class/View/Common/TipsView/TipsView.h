//
//  TipsView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/21.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TipsView : UIView

+ (instancetype)showWithFrame:(CGRect)rect andMessage:(nullable NSString *)message andImagePath:(nullable NSString *)imgName andHandle:(nullable VoidBlock)handle;

@end

NS_ASSUME_NONNULL_END
