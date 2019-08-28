//
//  HTTPRequest.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPRequest : NSObject

/// 请求参数
@property (nonatomic, readonly, strong) URLParameters *urlParameters;

/**
 获取请求类
 @param parameters  参数模型
 @return 请求类
 */
+ (instancetype)requestWithParameters:(URLParameters *)parameters;

@end

/// HTTPService的分类
@interface HTTPRequest (HTTPService)
/// 入队
- (RACSignal *)enqueueResultClass:(Class /*subclass of MHObject*/)resultClass;

@end

NS_ASSUME_NONNULL_END
