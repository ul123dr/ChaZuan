//
//  FlourItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlourItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, strong) NSArray *selectArr;
@property (nonatomic, readwrite, copy) NSString *selectTitle;

@property (nonatomic, readwrite, strong) RACSubject *clickSub;

@end

NS_ASSUME_NONNULL_END
