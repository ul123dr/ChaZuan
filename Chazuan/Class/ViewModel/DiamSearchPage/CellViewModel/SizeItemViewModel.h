//
//  SizeItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SizeItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *sizeMin;
@property (nonatomic, readwrite, copy) NSString *sizeMax;
@property (nonatomic, readwrite, copy) NSString *btnTitle;

@property (nonatomic, readwrite, strong) RACSubject *sizeSub;

@end

NS_ASSUME_NONNULL_END
