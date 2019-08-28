//
//  MainItemViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"
#import "FuncModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainItemViewModel : CommonItemViewModel

@property (nonatomic, readonly, strong) NSArray *icons;
@property (nonatomic, readonly, strong) NSArray *names;
@property (nonatomic, readonly, strong) NSArray *needLogins;
@property (nonatomic, readonly, strong) NSArray *destViewModelClasses;

@property (nonatomic, readwrite, strong) RACSubject *funcClickSub;

- (instancetype)initWithIcon:(NSArray *)icons name:(NSArray *)names login:(NSArray *)needLogins destClass:(NSArray *)destClass;

@end

NS_ASSUME_NONNULL_END
