//
//  FancyCutItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FancyCutItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, strong) NSArray *selectArr;
@property (nonatomic, readwrite, strong) RACSubject *clickSub;
@property (nonatomic, readwrite, copy) NSString *polishSelectTitle;
@property (nonatomic, readwrite, copy) NSString *symSelectTitle;

@end

NS_ASSUME_NONNULL_END
