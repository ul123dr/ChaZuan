//
//  PasswordItemViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PasswordItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *placeHolder;
@property (nonatomic, readwrite, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
