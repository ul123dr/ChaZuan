//
//  EditSellerItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditSellerItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, assign) BOOL shouldEdited;
@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, strong) RACSubject *clickSub;

@end

NS_ASSUME_NONNULL_END
