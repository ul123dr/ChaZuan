//
//  DiamResultHeaderView.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/8.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiamResultHeaderView : UIView

@property (nonatomic, readonly, strong) UILabel *searchTextLabel;
@property (nonatomic, readonly, strong) ZGButton *quoteBtn;
@property (nonatomic, readonly, strong) ZGButton *cartBtn;
@property (nonatomic, readonly, strong) ZGButton *orderBtn;

//@property (nonatomic, readonly, strong) ZGButton *discBtn;
//@property (nonatomic, readonly, strong) ZGButton *moneyBtn;

@end

NS_ASSUME_NONNULL_END
