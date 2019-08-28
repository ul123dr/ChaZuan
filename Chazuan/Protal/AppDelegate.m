//
//  AppDelegate.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewModel.h"
#import "LoginViewModel.h"
#import "RSAEncryptTool.h"
#import "LoginStatus.h"
#import "OtherLoginModel.h"
#import "LoginIpModel.h"

@interface AppDelegate ()

// Navigation 堆栈
@property (nonatomic, readwrite, strong) NavigationControllerStack *navigationControllerStack;
// APP的服务层
@property (nonatomic, readwrite, strong) ViewModelServicesImpl *services;
@property (nonatomic, readwrite, strong) ManagerSpecialty *manager;
@property (nonatomic, readwrite, strong) VipDollarRate *vipRate;

@property (nonatomic, readwrite, strong) RACCommand *managerCommand;
@property (nonatomic, readwrite, strong) RACCommand *userCommand;
@property (nonatomic, readwrite, strong) RACCommand *vipCommand;

@end

@implementation AppDelegate

+ (instancetype)shareDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化services
    self.services = [[ViewModelServicesImpl alloc] init];
    // Config Nav Stack
    self.navigationControllerStack = [[NavigationControllerStack alloc] initWithServices:self.services];
    [self _configApplication:application beforeInitUI:launchOptions];
    // 初始化window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    // rootViewController
    [self.services resetRootViewModel:[self _createInitialViewModel]];
    // 让窗口可见
    [self.window makeKeyAndVisible];
    
    [self _configApplication:application afterInitUI:launchOptions];
    
    return YES;
}

#pragma mark - Public Method
- (void)goLoginPage {
    LoginViewModel *loginViewModel = [[LoginViewModel alloc] initWithServices:self.services params:nil];
    [self.services pushViewModel:loginViewModel animated:YES];
}

#pragma mark - Private Method
/* 页面初始化之前做一些事情 */
- (void)_configApplication:(UIApplication *)application beforeInitUI:(NSDictionary *)launchOptions {
    // iOS 11 scorllView 适配
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    // 键盘
    [self _configKeyboardManager];
    // 统计
    //
    [self _initialCommand];
    // 添加 Notification 监听
    [self _initialNotification];
    // 判断用户状态及登录
    [self _autoLogin];
}

/* 页面初始化之后做些事情 */
- (void)_configApplication:(UIApplication *)application afterInitUI:(NSDictionary *)launchOptions {
    // 遮盖
    [self _initialCoverView];
}

/* 键盘管理设置 */
- (void)_configKeyboardManager {
    IQKeyboardManager.sharedManager.enable = YES;
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:3.0];
}

/* 用于自动登录 */
- (void)_autoLogin {
    if ([SingleInstance boolForKey:ZGCIsAutoLoginKey] && [SingleInstance boolForKey:ZGCIsLoginKey]) {
        [SingleInstance setString:nil forKey:ZGCManagerIdKey];
        [ZGCNotificationCenter postNotificationName:UserDataConfigureCompleteNotification object:nil userInfo:@{UserDataConfigureCompleteTypeKey:@(YES)}];
    } else {
        [self.services.client logoutUser];
    }
}

- (void)_initialCommand {
    @weakify(self);
    self.userCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
        subscript[@"id"] = [SingleInstance stringForKey:ZGCUserIdKey];
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_USER_INFO parameters:subscript.dictionary];
        @weakify(self);
        return [[[[self.services.client enqueueParameter:paramters resultClass:User.class] takeUntil:self.rac_willDeallocSignal] doNext:^(HTTPResponse *response) {
            @strongify(self);
            User *user = response.parsedResult;
            if (user.appCheckCode) {
                [self.services.client logoutUser];
            } else {
                user.sign = [SingleInstance stringForKey:ZGCSignKey];
                [self.services.client loginUser:user];
            }
        }] doError:^(NSError *error) {
            @strongify(self);
            [self.services.client logoutUser];
            [SVProgressHUD showErrorWithStatus:@"获取个人信息失败"];
        }];
    }];
    
    self.managerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        if (kStringIsNotEmpty([SingleInstance stringForKey:ZGCManagerIdKey])) {
            subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
            subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
            subscript[@"id"] = [SingleInstance stringForKey:ZGCManagerIdKey];
        }
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_MANAGER_SPECIALTY parameters:subscript.dictionary];
        return [[self.services.client enqueueParameter:paramters resultClass:ManagerSpecialty.class] takeUntil:self.rac_willDeallocSignal];
    }];
    RAC(self, manager) = [self.managerCommand.executionSignals.switchToLatest map:^(HTTPResponse *response) {
        ManagerSpecialty *manager = response.parsedResult;
        [SingleInstance setString:manager.webId.stringValue forKey:ZGCManagerIdKey];
        return manager;
    }];
    
    self.vipCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        KeyedSubscript *subscript = [KeyedSubscript subscript];
        subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
        subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
        subscript[@"sign"] = [SingleInstance stringForKey:ZGCSignKey];
        subscript[@"id"] = [SingleInstance stringForKey:ZGCUserIdKey];
        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_DOLLAR_RATE parameters:subscript.dictionary];
        return [[self.services.client enqueueParameter:paramters resultClass:VipDollarRate.class] takeUntil:self.rac_willDeallocSignal];
    }];
    RAC(self, vipRate) = [self.vipCommand.executionSignals.switchToLatest map:^(HTTPResponse *response) {
        return response.parsedResult;
    }];
    // hud
    [self.managerCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
    [self.userCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
}

/* 添加启动页遮盖，用于数据刷新 */
- (void)_initialCoverView {
    NSString *viewOrientation = @"Portrait";
    CGSize viewSize = self.window.bounds.size;
    NSString *launchImg = nil;
    NSArray *imgDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dic in imgDict) {
        CGSize imgSize = CGSizeFromString(dic[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imgSize, viewSize) && [viewOrientation isEqualToString:dic[@"UILaunchImageOrientation"]]) {
            launchImg = dic[@"UILaunchImageName"];
        }
    }
    
    UIImageView *launchView = [[UIImageView alloc] initWithImage:ImageNamed(launchImg)];
    launchView.frame = self.window.bounds;
    launchView.contentMode = UIViewContentModeScaleToFill;
    [self.window addSubview:launchView];
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        launchView.alpha = 0.0f;
        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.1, 1.1, 1);
    } completion:^(BOOL finished) {
        [launchView removeFromSuperview];
        // 发送一个加载完成消息
        //        [NotificationCenter postNotificationName:CoverImageCompleteNotification object:nil userInfo:nil];
    }];
}

/* 创建rootViewController */
- (BaseViewModel *)_createInitialViewModel {
    return [[MainViewModel alloc] initWithServices:self.services params:nil];
}

/* 通知监听 */
- (void)_initialNotification {
    @weakify(self);
    // 用户改变的监听处理，登录或登出
    [[ZGCNotificationCenter rac_addObserverForName:UserDataConfigureCompleteNotification object:nil] subscribeNext:^(NSNotification * note) {
        @strongify(self);
        if (kStringIsNotEmpty([SingleInstance stringForKey:ZGCUserWwwKey])) [self.managerCommand execute:nil];
        if ([note.userInfo[UserDataConfigureCompleteTypeKey] boolValue]) {
            [self.vipCommand execute:nil];
            [self.userCommand execute:nil];
        }
    }];
    
    [[ZGCNotificationCenter rac_addObserverForName:UserDataLoginAtOtherPlaceNotification object:nil] subscribeNext:^(NSNotification * note) {
        @strongify(self);
        if ([SingleInstance stringForKey:ZGCUIDKey].length == 0) {
            Alert(@"数据丢失了，请重新登录", @"取消", @"确定", ^(BOOL action) {
                [self.services popToRootViewModelAnimated:YES];
            });
        } else {
            @weakify(self);
            KeyedSubscript *subscript = [KeyedSubscript subscript];
            subscript[@"www"] = [SingleInstance stringForKey:ZGCUserWwwKey];
            subscript[@"uid"] = [SingleInstance stringForKey:ZGCUIDKey];
            subscript[@"login_type"] = @2;
            URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_OTHER_LOGIN parameters:subscript.dictionary];
            [[self.services.client enqueueParameter:paramters resultClass:OtherLoginModel.class] subscribeNext:^(HTTPResponse *response) {
                @strongify(self);
                OtherLoginModel *model = response.parsedResult;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                if (model.list.count > 0) {
                    LogList *list = model.list.firstObject;
                    NSDate *time = [formatter dateFromString:list.loginDate];
                    NSDate *since = [NSDate date];
                    if (since.timeIntervalSince1970 - time.timeIntervalSince1970 >= 7200000) {
                        Alert(@"登录超时", @"取消", @"确定", ^(BOOL action) {
                            [self.services popToRootViewModelAnimated:YES];
                        });
                    } else {
                        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        NSString *timer = [formatter stringFromDate:time];
                        NSString *msg = [NSString stringWithFormat:@"当前账号 %@ 在 (' + %@ + ')登录，您已被迫下线", timer, list.loginIp];
                        @weakify(self);
                        KeyedSubscript *subscript = [KeyedSubscript subscript];
                        subscript[@"ip"] = list.loginIp;
                        URLParameters *paramters = [URLParameters urlParametersWithMethod:HTTTP_METHOD_POST path:POST_GET_IP parameters:subscript.dictionary];
                        __block NSString *bMsg = msg;
                        __block NSString *bDate = timer;
                        [[self.services.client enqueueParameter:paramters resultClass:LoginIpModel.class] subscribeNext:^(HTTPResponse *response) {
                            @strongify(self);
                            LoginIpModel *model = response.parsedResult;
                            if (kObjectIsNotNil(model)) {
                                bMsg = [NSString stringWithFormat:@"当前账号 %@ 在 %@(%@)登录，您已被迫下线", bDate,[NSString stringWithFormat:@"%@ %@", formatWithString(model.data.region, @""), formatWithString(model.data.city, @"")], list.loginIp];
                                Alert(bMsg, @"取消", @"确定", ^(BOOL action) {
                                    [self.services popToRootViewModelAnimated:YES];
                                });
                            } else {
                                Alert(msg, @"取消", @"确定", ^(BOOL action) {
                                    [self.services popToRootViewModelAnimated:YES];
                                });
                            }
                        } error:^(NSError *error) {
                            @strongify(self);
                            Alert(error.description, @"取消", @"确定", ^(BOOL action) {
                                [self.services popToRootViewModelAnimated:YES];
                            });
                        }];
                    }
                } else {
                    Alert(@"数据丢失了，请重新登录", @"取消", @"确定", ^(BOOL action) {
                        [self.services popToRootViewModelAnimated:YES];
                    });
                }
            } error:^(NSError *error) {
                @strongify(self);
                Alert(@"数据丢失了，请重新登录", @"取消", @"确定", ^(BOOL action) {
                    [self.services popToRootViewModelAnimated:YES];
                });
            }];
        }
    }];
}

#pragma mark - 系统方法

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
