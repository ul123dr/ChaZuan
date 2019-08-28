//
//  LoginViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewModel : BaseViewModel

@property (nonatomic, readwrite, copy) NSString *userName;
@property (nonatomic, readwrite, copy) NSString *userPassword;
@property (nonatomic, readwrite, assign) BOOL rememberPwd;
@property (nonatomic, readwrite, assign) BOOL autoLogin;

@property (nonatomic, readonly, strong) RACCommand *loginCommand;

@property (nonatomic, readonly, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
