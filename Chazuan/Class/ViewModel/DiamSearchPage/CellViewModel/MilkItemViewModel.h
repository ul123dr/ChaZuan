//
//  MilkItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MilkItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, strong) NSArray *milkSelectArr;
@property (nonatomic, readwrite, strong) RACSubject *milkClickSub;
@property (nonatomic, readwrite, copy) NSString *milkSelectTitle;

@property (nonatomic, readwrite, strong) NSArray *blackSelectArr;
@property (nonatomic, readwrite, strong) RACSubject *blackClickSub;
@property (nonatomic, readwrite, copy) NSString *blackSelectTitle;

@end

NS_ASSUME_NONNULL_END
