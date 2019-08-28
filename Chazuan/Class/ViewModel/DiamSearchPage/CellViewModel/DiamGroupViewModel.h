//
//  DiamGroupViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/4.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonGroupViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiamGroupViewModel : CommonGroupViewModel

@property (nonatomic, readwrite, copy) NSString *titleStr;
@property (nonatomic, readwrite, copy) NSString *valueStr;

@property (nonatomic, readwrite, assign) BOOL closed;
@property (nonatomic, readwrite, copy) VoidBlock operation;

@property (nonatomic, readwrite, assign) BOOL showBtn;

@end

NS_ASSUME_NONNULL_END
