//
//  QuoteItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/13.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuoteItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *content;
//@property (nonatomic, readwrite, strong) RACCommand *copyCommand;

@end

NS_ASSUME_NONNULL_END
