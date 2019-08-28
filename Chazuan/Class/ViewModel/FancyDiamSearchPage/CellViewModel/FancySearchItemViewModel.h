//
//  FancySearchItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FancySearchItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *certNo;
@property (nonatomic, readwrite, copy) NSString *addNum;
@property (nonatomic, readwrite, copy) NSString *rate;

@property (nonatomic, readwrite, copy) NSString *sizeMin;
@property (nonatomic, readwrite, copy) NSString *sizeMax;
@property (nonatomic, readwrite, copy) NSString *sizeBtnTitle;
@property (nonatomic, readwrite, strong) RACSubject *sizeSub;

@property (nonatomic, readwrite, copy) NSString *certBtnTitle;
@property (nonatomic, readwrite, strong) RACSubject *certSub;

@end

NS_ASSUME_NONNULL_END
