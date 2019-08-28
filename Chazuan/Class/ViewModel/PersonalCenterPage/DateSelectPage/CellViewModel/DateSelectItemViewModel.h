//
//  DateSelectItemViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DateSelectItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *date;
@property (nonatomic, readwrite, assign) BOOL start;

@property (nonatomic, readwrite, strong) RACSubject *dateSub;

@end

NS_ASSUME_NONNULL_END
