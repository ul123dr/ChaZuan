//
//  ChangePasswordViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "PasswordItemViewModel.h"
#import "DoneItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordViewModel : BaseTableViewModel

@property (nonatomic, readonly, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
