//
//  DateSelectViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "DateSelectItemViewModel.h"
#import "DoneItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DateSelectViewModel : BaseTableViewModel

@property (nonatomic, readwrite, copy) NSString *startDate;
@property (nonatomic, readwrite, copy) NSString *endDate;

@property (nonatomic, readonly, strong) RACSubject *dateSub;

@property (nonatomic, readonly, strong) NSError *error;

@end

NS_ASSUME_NONNULL_END
