//
//  DiamSearchItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiamSearchItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *certNo;
@property (nonatomic, readwrite, copy) NSString *detail;
@property (nonatomic, readwrite, copy) NSString *dRef;
@property (nonatomic, readwrite, copy) NSString *addNum;
@property (nonatomic, readwrite, copy) NSString *rate;

@end

NS_ASSUME_NONNULL_END
