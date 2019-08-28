//
//  ChangeProfileItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeProfileItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *placeHolder;
@property (nonatomic, readwrite, copy) NSString *value;

@end

NS_ASSUME_NONNULL_END
