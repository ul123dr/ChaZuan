//
//  RACSignal+HTTPServiceAdditions.m
//  WeChat
//
//  Created by CoderMikeHe on 2017/10/19.
//  Copyright © 2017年 CoderMikeHe. All rights reserved.
//

#import "RACSignal+HTTPServiceAdditions.h"
#import "HTTPResponse.h"
@implementation RACSignal (HTTPServiceAdditions)

- (RACSignal *)parsedResults {
    return [self map:^(HTTPResponse *response) {
        NSAssert([response isKindOfClass:HTTPResponse.class], @"Expected %@ to be an MHHTTPResponse.", response);
        return response.parsedResult;
    }];
}

@end
