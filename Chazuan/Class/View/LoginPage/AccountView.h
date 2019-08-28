//
//  AccountView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountView : UIView

+ (instancetype)accountView;
@property (nonatomic, readonly, strong) UITextField *accountField;

@end

NS_ASSUME_NONNULL_END
