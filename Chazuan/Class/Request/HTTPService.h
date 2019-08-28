//
//  HTTPService.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "RACSignal+HTTPServiceAdditions.h"
#import "HTTPRequest.h"
#import "HTTPResponse.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPService : AFHTTPSessionManager

/// 单例
+ (instancetype)sharedInstance;
/// 存储用户
- (void)saveUser:(User *)user;

/// 删除用户
- (void)deleteUser:(User *)user;

/// 获取当前用户
- (User *)currentUser;

/// 获取当前用户的id
- (NSString *)currentUserId;

/// 用户信息配置完成
- (void)postUserDataConfigureCompleteNotification;

/// 是否登录
- (BOOL)isLogin;

/// 用户登录
- (void)loginUser:(User *)user;

/// 退出登录
- (void)logoutUser;

/// 在其他地方登陆
- (void)loginAtOtherPlace;

@end

@interface HTTPService (Request)

- (RACSignal *)enqueueParameter:(URLParameters *)parameters
                    resultClass:(Class /*subclass of MHObject*/)resultClass;

- (RACSignal *)enqueueRequest:(HTTPRequest *)request
                  resultClass:(Class /*subclass of MHObject*/)resultClass;

- (RACSignal *)enqueueUploadParameters:(URLParameters *)parameters
                           resultClass:(Class /*subclass of MHObject*/)resultClass
                             fileDatas:(NSArray <NSData *> *)fileDatas
                                  name:(NSString *)name
                              mimeType:(NSString *)mimeType;

@end

NS_ASSUME_NONNULL_END
