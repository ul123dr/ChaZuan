//
//  MemberItemViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *avastar;
@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *role;
@property (nonatomic, readwrite, copy) NSString *info;

@end

NS_ASSUME_NONNULL_END
