//
//  ViewModelServices.h
//  chazuan
//
//  Created by BecksZ on 2019/4/14.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavigationProtocol.h"
#import "HTTPService.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ViewModelServices <NSObject, NavigationProtocol>

@property (nonatomic, readonly, strong) HTTPService *client; ///< 全局通过这个Client来请求数据，处理用户信息

@end

NS_ASSUME_NONNULL_END
