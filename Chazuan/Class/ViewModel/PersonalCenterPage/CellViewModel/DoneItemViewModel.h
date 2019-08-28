//
//  DoneItemViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoneItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, assign) BOOL hidden;
@property (nonatomic, readwrite, strong) RACCommand *doneCommand;

@end

NS_ASSUME_NONNULL_END
