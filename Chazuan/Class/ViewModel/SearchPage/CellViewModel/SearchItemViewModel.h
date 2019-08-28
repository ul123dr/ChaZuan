//
//  SearchItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/5/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *historyStr;

@end

NS_ASSUME_NONNULL_END
