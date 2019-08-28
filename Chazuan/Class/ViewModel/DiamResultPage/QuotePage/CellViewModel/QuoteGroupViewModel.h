//
//  QuoteGroupViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/13.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonGroupViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuoteGroupViewModel : CommonGroupViewModel

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, strong) RACSubject *cSub;

@end

NS_ASSUME_NONNULL_END
