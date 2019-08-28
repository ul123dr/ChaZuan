//
//  StyleBottomView.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StyleBottomView : UIView

- (instancetype)initWithType:(StyleType)type;

@property (nonatomic, readonly, strong) ZGButton *homeBtn;
@property (nonatomic, readonly, strong) ZGButton *addCartBtn;
@property (nonatomic, readonly, strong) ZGButton *orderBtn;

@end

NS_ASSUME_NONNULL_END
