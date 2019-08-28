//
//  PasswordView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordView : UIView

+ (instancetype)passwordView;
@property (nonatomic, readonly, strong) UITextField *passwordField; 

@end

NS_ASSUME_NONNULL_END
