//
//  CutItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CutItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, strong) NSArray *selectArr;
@property (nonatomic, readwrite, copy) NSString *selectTitle;
@property (nonatomic, readwrite, copy) NSString *cutSelectTitle;
@property (nonatomic, readwrite, copy) NSString *polishSelectTitle;
@property (nonatomic, readwrite, copy) NSString *symSelectTitle;

@property (nonatomic, readwrite, strong) RACSubject *clickSub;

@end

NS_ASSUME_NONNULL_END
