//
//  ChangeProfileViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "AvatarItemViewModel.h"
#import "DoneItemViewModel.h"
#import "ChangeProfileItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChangeProfileViewModel : BaseTableViewModel

@property (nonatomic, readonly, copy) NSString *text;
@property (nonatomic, readonly, strong) NSError *error;

@property (nonatomic, readonly, strong) RACSubject *photoSub;
@property (nonatomic, readonly, strong) RACSubject *uploadSub;

@end

NS_ASSUME_NONNULL_END
