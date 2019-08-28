//
//  HTTPRequest.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "HTTPRequest.h"
#import "HTTPService.h"

@interface HTTPRequest ()
/// 请求参数
@property (nonatomic, readwrite, strong) URLParameters *urlParameters;

@end

@implementation HTTPRequest

+ (instancetype)requestWithParameters:(URLParameters *)parameters {
    return [[self alloc] initRequestWithParameters:parameters];
}

- (instancetype)initRequestWithParameters:(URLParameters *)parameters {
    self = [super init];
    if (self) {
        self.urlParameters = parameters;
    }
    return self;
}

@end


@implementation HTTPRequest (HTTPService)

- (RACSignal *)enqueueResultClass:(Class /*subclass of MHObject*/) resultClass {
    return [[HTTPService sharedInstance] enqueueRequest:self resultClass:resultClass];
}

@end
