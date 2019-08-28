//
//  HTTPService.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "HTTPService.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface HTTPService ()

@property (nonatomic, readwrite, strong) User *currentUser;

@end

@implementation HTTPService
static id service_ = nil;
#pragma mark -  HTTPService
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service_ = [[self alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@/", ServerHttp]] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    });
    return service_;
}
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service_ = [super allocWithZone:zone];
    });
    return service_;
}
- (id)copyWithZone:(NSZone *)zone {
    return service_;
}

- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(nullable NSURLSessionConfiguration *)configuration{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        /// 配置
        [self _configHTTPService];
    }
    return self;
}

/// config service
- (void)_configHTTPService{
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
#if defined(DEBUG)||defined(_DEBUG)
    responseSerializer.removesKeysWithNullValues = NO;
#else
    responseSerializer.removesKeysWithNullValues = YES;
#endif
    responseSerializer.readingOptions = NSJSONReadingAllowFragments;
    /// config
    self.responseSerializer = responseSerializer;
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    /// 安全策略
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;
    
    self.securityPolicy = securityPolicy;
    /// 支持解析
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json;charset=utf-8",
                                                      @"text/json;charset=utf-8",
                                                      @"application/json",
                                                      @"text/json",
                                                      @"text/javascript",
                                                      @"text/html",
                                                      @"text/plain",
                                                      nil];
    
    /// 开启网络监测
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            //            [JDStatusBarNotification showWithStatus:@"网络状态未知" styleName:JDStatusBarStyleWarning];
            //            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
            NSLog(@"--- 未知网络 ---");
        } else if (status == AFNetworkReachabilityStatusNotReachable) {
            //            [JDStatusBarNotification showWithStatus:@"网络不给力，请检查网络" styleName:JDStatusBarStyleWarning];
            //            [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
            NSLog(@"--- 无网络 ---");
        } else {
            NSLog(@"--- 有网络 ---");
            //            [JDStatusBarNotification dismiss];
        }
    }];
    [self.reachabilityManager startMonitoring];
}

#pragma mark - User Module
- (void)saveUser:(User *)user {
    /// 记录用户数据
    self.currentUser = user;
    
    /// 保存
    BOOL status = [NSKeyedArchiver archiveRootObject:user toFile:FilePathFromChazuanDoc(UserDataFileName)];
    ZGCLog(@"Save login user data， the status is %@",status?@"Success...":@"Failure...");
}

- (void)deleteUser:(User *)user {
    /// 删除
    self.currentUser = nil;
    
//    BOOL status = [NSKeyedArchiver archiveRootObject:user toFile:FilePathFromChazuanDoc(UserDataFileName)];
//    NSLog(@"Delete login user data ， the status is %@",status?@"Success...":@"Failure...");
}

- (User *)currentUser {
    if (!_currentUser && [SingleInstance boolForKey:ZGCIsLoginKey]) {
        _currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:FilePathFromChazuanDoc(UserDataFileName) exception:nil];
    }
    return _currentUser;
}

/// 获取当前用户的id
- (NSString *)currentUserId {
    return [self currentUser].userId.stringValue;
}

- (BOOL)isLogin {
    return [self currentUser] != nil;
}

- (void)loginUser:(User *)user {
    /// 保存用户
    [self saveUser:user];
    [SingleInstance setBool:YES forKey:ZGCIsLoginKey];
    /// 发送登录成功的通知
    [self postUserDataConfigureCompleteNotification];
}

/// 退出登录
- (void)logoutUser {
    User *currentUser = [self currentUser];
    
    /// 删除用户数据
    [self deleteUser:currentUser];
    [SingleInstance setBool:NO forKey:ZGCIsLoginKey];
    [SingleInstance setString:nil forKey:ZGCUserIdKey];
//    [SingleInstance setString:nil forKey:ZGCUIDKey];
//    [SingleInstance setString:nil forKey:ZGCSignKey];
//    [SingleInstance setString:nil forKey:ZGCUserWwwKey];
    [SingleInstance setString:nil forKey:ZGCManagerIdKey];
    
    [self postUserDataConfigureCompleteNotification];
}

- (void)loginAtOtherPlace {
    [self logoutUser];
    
    [ZGCNotificationCenter postNotificationName:UserDataLoginAtOtherPlaceNotification object:nil userInfo:@{}];
}

/// 用户信息配置完成
- (void)postUserDataConfigureCompleteNotification {
    User *user = [self currentUser];
    [ZGCNotificationCenter postNotificationName:UserDataConfigureCompleteNotification object:nil userInfo:user?@{UserDataConfigureCompleteUserInfoKey:user}:@{}];
}

#pragma mark - Request
- (RACSignal *)enqueueParameter:(URLParameters *)parameters resultClass:(Class /*subclass of MHObject*/) resultClass {
    return [self enqueueRequest:[HTTPRequest requestWithParameters:parameters] resultClass:resultClass];
}

- (RACSignal *)enqueueRequest:(HTTPRequest *)request resultClass:(Class /*subclass of MHObject*/)resultClass {
    /// request 必须的有值
    if (!request) return [RACSignal error:[NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:@{HTTPServiceErrorDescriptionKey:@"网络出错"}]];
    
    @weakify(self);
    /// 发起请求
    /// concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。 这里传进去的参数，不是parameters而是之前通过
    /// urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;穿进去的参数
    return [[[self enqueueRequestWithPath:request.urlParameters.path parameters:request.urlParameters.parameters method:request.urlParameters.method] reduceEach:^RACStream *(NSURLResponse *response, NSDictionary * responseObject) {
        @strongify(self);
        /// 请求成功 这里解析数据
        return [[self parsedResponseOfClass:resultClass fromJSON:responseObject] map:^(id parsedResult) {
            HTTPResponse *parsedResponse = [[HTTPResponse alloc] initWithResponseObject:responseObject parsedResult:parsedResult];
            NSAssert(parsedResponse != nil, @"Could not create MHHTTPResponse with response %@ and parsedResult %@", response, parsedResult);
            return parsedResponse;
        }];
    }] concat];
}

/// 请求数据
- (RACSignal *)enqueueRequestWithPath:(NSString *)path parameters:(id)parameters method:(NSString *)method {
    @weakify(self);
    /// 创建信号
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        /// 获取request
        NSError *serializationError = nil;
        NSString *blockPath = path;
        if (![path hasPrefix:@"http"]) blockPath = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:blockPath parameters:parameters error:&serializationError];
        
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
#pragma clang diagnostic pop
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        /// 获取请求任务
        __block NSURLSessionDataTask *task = nil;
        task = [self dataTaskWithRequest:request uploadProgress:^(NSProgress *uploadProgress) {
        } downloadProgress:^(NSProgress *downloadProgress) {
        } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error || kObjectIsNil(responseObject)) {
                NSError *parseError = [self _errorFromRequestWithTask:task httpResponse:(NSHTTPURLResponse *)response error:error];
                [self HTTPRequestLog:task body:parameters responseObject:responseObject error:parseError];
                [subscriber sendError:parseError];
            } else {
                // 断言
                NSAssert([responseObject isKindOfClass:NSDictionary.class], @"responseObject is not an NSDictionary: %@", responseObject);
                // 判断是否正确
                NSInteger statusCode = [responseObject[HTTPServiceResponseCodeKey] integerValue];
                if (statusCode == HTTPResponseCodeSuccess) {
                    [self HTTPRequestLog:task body:parameters responseObject:responseObject error:nil];
                    /// 打包成元祖 回调数据
                    [subscriber sendNext:RACTuplePack(response , responseObject)];
                    [subscriber sendCompleted];
                } else {
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[HTTPServiceErrorStatusCodeKey] = @(statusCode);
                    NSString *msgTips = responseObject[HTTPServiceResponseMsgKey];
#if defined(DEBUG)||defined(_DEBUG)
                    msgTips = kStringIsNotEmpty(msgTips)?[NSString stringWithFormat:@"%@(%zd)",msgTips,statusCode]:[NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",statusCode];                 /// 调试模式
#else
                    msgTips = kStringIsNotEmpty(msgTips)?msgTips:@"服务器出错了，请稍后重试~";/// 发布模式
#endif
                    userInfo[HTTPServiceErrorDescriptionKey] = msgTips;
                    if (task.currentRequest.URL != nil) userInfo[HTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
                    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
                    NSError *requestError = [NSError errorWithDomain:HTTPServiceErrorDomain code:statusCode userInfo:userInfo];
                    [self HTTPRequestLog:task body:parameters responseObject:responseObject error:requestError];
                    [subscriber sendError:requestError];
                }
            }
        }];
        /// 开启请求任务
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    /// replayLazily:replayLazily会在第一次订阅的时候才订阅sourceSignal
    /// 会提供所有的值给订阅者 replayLazily还是冷信号 避免了冷信号的副作用
    return [[signal replayLazily] setNameWithFormat:@"-enqueueRequestWithPath: %@ parameters: %@ method: %@", path, parameters , method];
}

#pragma mark - Upload
- (RACSignal *)enqueueUploadParameters:(URLParameters *)parameters resultClass:(Class)resultClass fileDatas:(NSArray<NSData *> *)fileDatas name:(NSString *)name mimeType:(NSString *)mimeType {
    HTTPRequest *request = [HTTPRequest requestWithParameters:parameters];
    /// request 必须的有值
    if (!request) return [RACSignal error:[NSError errorWithDomain:HTTPServiceErrorDomain code:-1 userInfo:nil]];
    /// 断言
    NSAssert(kStringIsNotEmpty(name), @"name is empty: %@", name);
    
    @weakify(self);
    
    /// 覆盖manager 请求序列化
    self.requestSerializer = [self _requestSerializerWithRequest:request];
    
    /// 发起请求
    /// concat:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。 这里传进去的参数，不是parameters而是之前通过
    /// urlParametersWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;穿进去的参数
    return [[[self enqueueUploadRequestWithPath:request.urlParameters.path parameters:request.urlParameters.parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSInteger count = fileDatas.count;
        for (int i = 0; i < count; i++) {
            // 去除data
            NSData *fileData = fileDatas[i];
            // 断言
            NSAssert([fileData isKindOfClass:NSData.class], @"fileData is not an NSData class: %@", fileData);
            // 在上传文件时，文件不允许被覆盖，即文件不能重名
            static NSDateFormatter *formatter = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                formatter = [[NSDateFormatter alloc] init];
            });
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"senba_empty_%@_%d.jpg", dateString , i];
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:kStringIsNotEmpty(mimeType)?mimeType:@"application/octet-stream"];
        }
    }] reduceEach:^RACStream *(NSURLResponse *response, NSDictionary * responseObject) {
        @strongify(self);
        /// 请求成功 这里解析数据
        return [[self parsedResponseOfClass:resultClass fromJSON:responseObject] map:^(id parsedResult) {
            HTTPResponse *parsedResponse = [[HTTPResponse alloc] initWithResponseObject:responseObject parsedResult:parsedResult];
            NSAssert(parsedResponse != nil, @"Could not create MHHTTPResponse with response %@ and parsedResult %@", response, parsedResult);
            return parsedResponse;
        }];
    }] concat];
}

- (RACSignal *)enqueueUploadRequestWithPath:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
    @weakify(self);
    /// 创建信号
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        /// 获取request
        NSError *serializationError = nil;
        NSString *blockPath = path;
        if (![path hasPrefix:@"http"]) blockPath = [[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString];
        NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:path parameters:parameters constructingBodyWithBlock:block error:&serializationError];
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
#pragma clang diagnostic pop
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        
        __block NSURLSessionDataTask *task = [self uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
            if (error) {
                NSError *parseError = [self _errorFromRequestWithTask:task httpResponse:(NSHTTPURLResponse *)response error:error];
                [self HTTPRequestLog:task body:parameters responseObject:responseObject error:parseError];
                [subscriber sendError:parseError];
            } else {
                /// 断言
                NSAssert([responseObject isKindOfClass:NSDictionary.class], @"responseObject is not an NSDictionary: %@", responseObject);
                /// 在这里判断数据是否正确
                NSInteger statusCode = [responseObject[HTTPServiceResponseCodeKey] integerValue];
                
                if (statusCode == HTTPResponseCodeSuccess) {
                    /// 打包成元祖 回调数据
                    [subscriber sendNext:RACTuplePack(response , responseObject)];
                    [subscriber sendCompleted];
                } else {
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                    userInfo[HTTPServiceErrorStatusCodeKey] = @(statusCode);
                    NSString *msgTips = responseObject[HTTPServiceResponseMsgKey];
#if defined(DEBUG)||defined(_DEBUG)
                    msgTips = kStringIsNotEmpty(msgTips)?[NSString stringWithFormat:@"%@(%zd)",msgTips,statusCode]:[NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",statusCode];                 /// 调试模式
#else
                    msgTips = kStringIsNotEmpty(msgTips)?msgTips:@"服务器出错了，请稍后重试~";/// 发布模式
#endif
                    userInfo[HTTPServiceErrorDescriptionKey] = msgTips;
                    if (task.currentRequest.URL != nil) userInfo[HTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
                    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
                    NSError *requestError = [NSError errorWithDomain:HTTPServiceErrorDomain code:statusCode userInfo:userInfo];
                    [self HTTPRequestLog:task body:parameters responseObject:responseObject error:requestError];
                    [subscriber sendError:requestError];
                }
            }
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
        
    }];
    /// replayLazily:replayLazily会在第一次订阅的时候才订阅sourceSignal
    /// 会提供所有的值给订阅者 replayLazily还是冷信号 避免了冷信号的副作用
    return [[signal replayLazily] setNameWithFormat:@"-enqueueUploadRequestWithPath: %@ parameters: %@", path, parameters];
}


#pragma mark Parsing (数据解析)
- (NSError *)parsingErrorWithFailureReason:(NSString *)localizedFailureReason {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response.", @"");
    if (localizedFailureReason != nil) userInfo[HTTPServiceErrorDescriptionKey] = localizedFailureReason;
    return [NSError errorWithDomain:HTTPServiceErrorDomain code:669 userInfo:userInfo];
}

/// 解析数据
- (RACSignal *)parsedResponseOfClass:(Class)resultClass fromJSON:(NSDictionary *)responseObject {
    /// 必须是MHObject的子类 且 最外层responseObject必须是字典
    NSParameterAssert((resultClass == nil || [resultClass isSubclassOfClass:MHObject.class]));
    
    /// 解析
    return [RACSignal createSignal:^ id (id<RACSubscriber> subscriber) {
        /// 解析字典
        void (^parseJSONDictionary)(NSDictionary *) = ^(NSDictionary *JSONDictionary) {
            if (JSONDictionary == nil) {
                [subscriber sendNext:JSONDictionary];
            } else {
                MHObject *parsedObject = [resultClass modelWithDictionary:JSONDictionary];
                if (parsedObject == nil) {
                    // 模型解析失败
                    NSError *error = [NSError errorWithDomain:@"" code:2222 userInfo:@{HTTPServiceErrorDescriptionKey:@"数据解析出错"}];
                    [subscriber sendError:error];
                    return;
                }
                /// 确保解析出来的类 也是 BaseModel
                NSAssert([parsedObject isKindOfClass:MHObject.class], @"Parsed model object is not an BaseModel: %@", parsedObject);
                /// 发送数据
                [subscriber sendNext:parsedObject];
            }
        };
        
        if ([responseObject isKindOfClass:NSArray.class]) {
            if (resultClass == nil) {
                [subscriber sendNext:responseObject];
            } else {
                /// 数组 保证数组里面装的是同一种 NSDcitionary
                for (NSDictionary *JSONDictionary in responseObject) {
                    if (![JSONDictionary isKindOfClass:NSDictionary.class]) {
                        NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), JSONDictionary];
                        [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
                        return nil;
                    }
                }
                /// 字典数组 转对应的模型
                NSArray *parsedObjects = [resultClass modelArrayWithJSON:responseObject];
                /// 这里还需要解析是否是MHObject的子类
                for (id parsedObject in parsedObjects) {
                    /// 确保解析出来的类 也是 BaseModel
                    NSAssert([parsedObject isKindOfClass:MHObject.class], @"Parsed model object is not an BaseModel: %@", parsedObject);
                }
                [subscriber sendNext:parsedObjects];
            }
            [subscriber sendCompleted];
        } else if ([responseObject isKindOfClass:NSDictionary.class]) {
            /// 解析字典
            parseJSONDictionary(responseObject);
            [subscriber sendCompleted];
        } else if (responseObject == nil || [responseObject isKindOfClass:[NSNull class]]) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        } else {
            NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""), [responseObject class], responseObject];
            [subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
        }
        return nil;
    }];
}

#pragma mark - Error Handling
/// 请求错误解析
- (NSError *)_errorFromRequestWithTask:(NSURLSessionTask *)task httpResponse:(NSHTTPURLResponse *)httpResponse error:(NSError *)error {
    /// 不一定有值，则HttpCode = 0;
    NSInteger HTTPCode = httpResponse.statusCode;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    /// default errorCode is MHHTTPServiceErrorConnectionFailed，意味着连接不上服务器
    NSInteger errorCode = 668;
    NSString *errorDesc = @"服务器出错了，请稍后重试~";
    /// 其实这里需要处理后台数据错误，一般包在 responseObject
    /// HttpCode错误码解析 https://www.guhei.net/post/jb1153
    /// 1xx : 请求消息 [100  102]
    /// 2xx : 请求成功 [200  206]
    /// 3xx : 请求重定向[300  307]
    /// 4xx : 请求错误  [400  417] 、[422 426] 、449、451
    /// 5xx 、600: 服务器错误 [500 510] 、600
    NSInteger httpFirstCode = HTTPCode/100;
    if (httpFirstCode > 0) {
        if (httpFirstCode == 4) {
            /// 请求出错了，请稍后重试
            if (HTTPCode == 408) {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = @"请求超时，请稍后再试(408)~"; /// 调试模式
#else
                errorDesc = @"请求超时，请稍后再试~";      /// 发布模式
#endif
            } else {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",HTTPCode];                   /// 调试模式
#else
                errorDesc = @"请求出错了，请稍后重试~";      /// 发布模式
#endif
            }
        } else if (httpFirstCode == 5 || httpFirstCode == 6) {
            /// 服务器出错了，请稍后重试
#if defined(DEBUG)||defined(_DEBUG)
            errorDesc = [NSString stringWithFormat:@"服务器出错了，请稍后重试(%zd)~",HTTPCode];                      /// 调试模式
#else
            errorDesc = @"服务器出错了，请稍后重试~";       /// 发布模式
#endif
            
        } else if (!self.reachabilityManager.isReachable) {
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    } else {
        if (!self.reachabilityManager.isReachable){
            /// 网络不给力，请检查网络
            errorDesc = @"网络开小差了，请稍后重试~";
        }
    }
    switch (HTTPCode) {
        case 400:{
            errorCode = 670;           /// 请求失败
            break;
        }
        case 403:{
            errorCode = 671;     /// 服务器拒绝请求
            break;
        }
        case 422:{
            errorCode = 672; /// 请求出错
            break;
        }
        default:
            /// 从error中解析
            if ([error.domain isEqual:NSURLErrorDomain]) {
#if defined(DEBUG)||defined(_DEBUG)
                errorDesc = [NSString stringWithFormat:@"请求出错了，请稍后重试(%zd)~",error.code];                   /// 调试模式
#else
                errorDesc = @"请求出错了，请稍后重试~";        /// 发布模式
#endif
                switch (error.code) {
                    case NSURLErrorSecureConnectionFailed:
                    case NSURLErrorServerCertificateHasBadDate:
                    case NSURLErrorServerCertificateHasUnknownRoot:
                    case NSURLErrorServerCertificateUntrusted:
                    case NSURLErrorServerCertificateNotYetValid:
                    case NSURLErrorClientCertificateRejected:
                    case NSURLErrorClientCertificateRequired:
                        errorCode = 668; /// 建立安全连接出错了
                        break;
                    case NSURLErrorTimedOut:{
#if defined(DEBUG)||defined(_DEBUG)
                        errorDesc = @"请求超时，请稍后再试(-1001)~"; /// 调试模式
#else
                        errorDesc = @"请求超时，请稍后再试~";        /// 发布模式
#endif
                        break;
                    }
                    case NSURLErrorNotConnectedToInternet:{
#if defined(DEBUG)||defined(_DEBUG)
                        errorDesc = @"网络开小差了，请稍后重试(-1009)~"; /// 调试模式
#else
                        errorDesc = @"网络开小差了，请稍后重试~";        /// 发布模式
#endif
                        break;
                    }
                }
            }
    }
    userInfo[HTTPServiceErrorStatusCodeKey] = @(HTTPCode);
    userInfo[HTTPServiceErrorDescriptionKey] = errorDesc;
    if (task.currentRequest.URL != nil) userInfo[HTTPServiceErrorRequestURLKey] = task.currentRequest.URL.absoluteString;
    if (task.error != nil) userInfo[NSUnderlyingErrorKey] = task.error;
    return [NSError errorWithDomain:HTTPServiceErrorDomain code:errorCode userInfo:userInfo];
}



#pragma mark - 打印请求日志
- (void)HTTPRequestLog:(NSURLSessionTask *)task body:(NSDictionary *)params responseObject:(id)responseObject error:(NSError *)error {
#ifdef DEBUG
    BOOL isSuccess = error ? NO : YES;
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n>>>>>>>>>>>>>>>>>>>>>👇 REQUEST FINISH 👇>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n"];
    [logString appendFormat:@"Request status:\n\t%@\n\n", isSuccess?@"成功":@"失败"];
    [logString appendFormat:@"Request URL:\n\t%@\n\n", task.currentRequest.URL.absoluteString];
    [logString appendFormat:@"Request Data:\n\t%@\n\n",params.modelToJSONObject];
    [logString appendFormat:@"Raw Response String:\n\t%@\n\n", responseObject];
    
    if (!isSuccess) {
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
    }
    [logString appendFormat:@"<<<<<<<<<<<<<<<<<<<<<👆 REQUEST FINISH 👆<<<<<<<<<<<<<<<<<<<<<<<<<<\n"];
    
    NSLog(@"%@", logString);
#endif
}


#pragma mark - Parameter 签名 MD5 生成一个 sign ，这里请根据实际项目来定
/// 基础的请求参数
- (NSMutableDictionary *)_parametersWithRequest:(HTTPRequest *)request {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    /// 模型转字典
    id object = [request.urlParameters.extendsParameters modelToJSONObject];
    if ([object isKindOfClass:NSDictionary.class]) {
        if ([object count]) [parameters addEntriesFromDictionary:(NSDictionary *)object];
    }
    if ([request.urlParameters.parameters count]) {
        [parameters addEntriesFromDictionary:request.urlParameters.parameters];
    }
    return parameters;
}

/// 带签名的请求参数
- (NSString *)_signWithParameters:(NSDictionary *)parameters {
    /// 按照ASCII码排序
    NSArray *sortedKeys = [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *kvs = [NSMutableArray array];
    for (id key in sortedKeys) {
        /// value 为 empty 跳过
        if(kObjectIsNil(parameters[key])) continue;
        NSString * value = [parameters[key] stringValue];
        if (kObjectIsNil(value)||kStringIsEmpty(value)) continue;
        value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        value = [value stringByURLEncode];
        [kvs addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
    }
    /// 拼接私钥
    NSString *paramString = [kvs componentsJoinedByString:@"&"];
    NSString *keyValue = HTTPRequestServiceKeyValue;
    NSString *signedString = [NSString stringWithFormat:@"%@&%@=%@",paramString,HTTPRequestServiceKey,keyValue];
    
    /// md5
    return signedString.md5String;
}

/* 序列化 */
- (AFHTTPRequestSerializer *)_requestSerializerWithRequest:(HTTPRequest *)request{
    // 获取基础参数（参数+拓展参数）
    NSMutableDictionary *parameters = [self _parametersWithRequest:request];
    // 获取带签名的参数
    NSString *sign = [self _signWithParameters:parameters];
    // 赋值
    parameters[HTTPRequestSignKey] = [sign length]?sign:@"";
    // 请求序列化
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    // 配置请求头
    for (NSString *key in parameters) {
        NSString *value = [parameters[key] stringValue];
        if (value.length==0) continue;
        /// value只能是字符串，否则崩溃
        [requestSerializer setValue:value forHTTPHeaderField:key];
    }
    return requestSerializer;
}

@end
