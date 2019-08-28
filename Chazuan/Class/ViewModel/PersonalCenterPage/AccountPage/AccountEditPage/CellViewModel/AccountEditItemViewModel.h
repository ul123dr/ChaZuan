//
//  AccountEditItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountEditItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *value;
@property (nonatomic, readwrite, strong) RACCommand *resetPwdCommand;

@end

NS_ASSUME_NONNULL_END
