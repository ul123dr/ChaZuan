//
//  SearchGroupViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/5/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonGroupViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchGroupViewModel : CommonGroupViewModel

@property (nonatomic, readwrite, strong) RACCommand *clearCommand;

@end

NS_ASSUME_NONNULL_END
