//
//  SettingItemViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, copy) NSString *value;
@property (nonatomic, readwrite, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
