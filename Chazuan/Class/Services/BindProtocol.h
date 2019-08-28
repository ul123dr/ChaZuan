//
//  BindProtocol.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BindProtocol <NSObject>

/// 绑定viewModel
- (void)bindViewModel:(id)viewModel;

@end

NS_ASSUME_NONNULL_END
