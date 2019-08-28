//
//  CertSelectItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CertSelectItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, strong) NSArray *cartData;
@property (nonatomic, readwrite, assign) BOOL open;
@property (nonatomic, readwrite, assign) NSInteger certIndex;

@end

NS_ASSUME_NONNULL_END
