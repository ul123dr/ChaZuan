//
//  VipRateViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "VipRateItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VipRateViewModel : BaseTableViewModel

@property (nonatomic, readonly, strong) NSError *error; 

@end

NS_ASSUME_NONNULL_END
