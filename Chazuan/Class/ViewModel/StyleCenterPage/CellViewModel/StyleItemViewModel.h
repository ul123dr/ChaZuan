//
//  StyleItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"
#import "DiamondModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StyleItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, assign) StyleType type;
@property (nonatomic, readonly, strong) NSArray *model; ///< cell 绑定数据

- (instancetype)initWithModel:(NSArray *)models;

@property (nonatomic, readwrite, strong) RACCommand *didSelectCommand; ///< 商品点击

@end

NS_ASSUME_NONNULL_END
