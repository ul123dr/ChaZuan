//
//  BannerItemViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"
#import "CycleCollectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BannerItemViewModel : CommonItemViewModel

@property (nonatomic, readonly, strong) NSArray *model;
- (instancetype)initWithModel:(NSArray *)bannerArr;
@property (nonatomic, readwrite, strong) RACSubject *bannerClickSub;

@end

NS_ASSUME_NONNULL_END
