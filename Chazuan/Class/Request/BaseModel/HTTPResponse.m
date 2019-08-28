//
//  HTTPResponse.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "HTTPResponse.h"

@interface HTTPResponse ()

/// The parsed MHObject object corresponding to the API response.
/// The developer need care this data
@property (nonatomic, readwrite, strong) id parsedResult;
/// 自己服务器返回的状态码
@property (nonatomic, readwrite, assign) HTTPResponseCode code;
/// 自己服务器返回的信息
@property (nonatomic, readwrite, copy) NSString *msg;

@end

@implementation HTTPResponse

- (instancetype)initWithResponseObject:(id)responseObject parsedResult:(id)parsedResult
{
    self = [super init];
    if (self) {
        self.parsedResult = parsedResult ?:NSNull.null;
        self.code = [responseObject[HTTPServiceResponseCodeKey] integerValue];
        self.msg = responseObject[HTTPServiceResponseMsgKey];
    }
    return self;
}

@end
