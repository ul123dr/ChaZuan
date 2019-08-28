//
//  StylePicItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/25.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StylePicItemViewModel : CommonItemViewModel

@property (nonatomic, readonly, strong) NSArray *model;
- (instancetype)initWithModel:(NSArray *)bannerArr;
@property (nonatomic, readwrite, strong) RACSubject *bannerClickSub;

@end

NS_ASSUME_NONNULL_END
