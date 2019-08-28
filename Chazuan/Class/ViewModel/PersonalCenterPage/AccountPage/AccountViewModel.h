//
//  AccountViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewModel.h"
#import "AccountModel.h"
#import "MemberItemViewModel.h"
#import "AccountAddViewModel.h"
#import "AccountEditViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountViewModel : BaseTableViewModel

@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, assign) NSInteger searchType;
@property (nonatomic, readwrite, copy) NSString *searchText;
@property (nonatomic, readonly, assign) NSInteger count;

@property (nonatomic, readonly, strong) RACCommand *searchCommand;
@property (nonatomic, readonly, strong) RACSubject *searchTypeSub;

@property (nonatomic, readonly, strong) RACCommand *addCommand;

@end

NS_ASSUME_NONNULL_END
