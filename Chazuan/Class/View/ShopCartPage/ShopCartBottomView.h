//
//  ShopCartBottomView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopCartBottomView : UIView<BindProtocol>

+ (instancetype)cartButtonView;

@end

NS_ASSUME_NONNULL_END
