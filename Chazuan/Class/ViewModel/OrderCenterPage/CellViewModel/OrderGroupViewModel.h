//
//  OrderGroupViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonGroupViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderGroupViewModel : CommonGroupViewModel

@property (nonatomic, readwrite, copy) NSString *orderNo;
@property (nonatomic, readwrite, copy) NSString *orderStatus;
@property (nonatomic, readwrite, strong) NSNumber *oldId;

@property (nonatomic, readwrite, assign) BOOL showBtn;
@property (nonatomic, readwrite, strong) RACCommand *comfirmCommand;

@end

NS_ASSUME_NONNULL_END
