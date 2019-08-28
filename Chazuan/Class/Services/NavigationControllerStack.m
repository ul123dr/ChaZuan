//
//  NavigationControllerStack.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "NavigationControllerStack.h"
#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface NavigationControllerStack ()

// 服务层
@property (nonatomic, readwrite, strong) id<ViewModelServices> services;
// 维护的 navigationController 集合
@property (nonatomic, strong) NSMutableArray *navigationControllers;

// viewModel 到 viewController 的映射
@property (nonatomic, copy) NSDictionary *viewModelViewMappings;

@end

@implementation NavigationControllerStack

- (void)dealloc {
    ZGCLog(@"NavigationControllerStack dealloc");
}

- (instancetype)initWithServices:(id<ViewModelServices>)services {
    self = [super init];
    if (self) {
        self.services = services;
        self.navigationControllers = [NSMutableArray array];
        [self _registerNavigationHooks];
    }
    return self;
}

- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationControllers containsObject:navigationController]) return;
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

- (BOOL)containtViewModel:(Class)viewModelClass {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModelClass)];
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    for (BaseViewController *topViewController in navigationController.viewControllers) {
        if ([NSStringFromClass(topViewController.class) isEqualToString:viewController]) return YES;
    }
    return NO;
}

#pragma mark - 数据绑定
- (void)_registerNavigationHooks {
    @weakify(self);
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(pushViewModel:animated:)]
     subscribeNext:^(RACTuple * tuple) {
         @strongify(self);
         BaseViewController *topViewController = (BaseViewController *)[self.navigationControllers.lastObject topViewController];
         topViewController.snapshot = [[self.navigationControllers.lastObject view] snapshotViewAfterScreenUpdates:NO];
         UIViewController *viewController = (UIViewController *)[self viewControllerForViewModel:tuple.first];
         [self.navigationControllers.lastObject pushViewController:viewController animated:[tuple.second boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popViewModelAnimated:)]
     subscribeNext:^(RACTuple * tuple) {
         @strongify(self);
         [self.navigationControllers.lastObject popViewControllerAnimated:[tuple.first boolValue]];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popToViewModel:animated:)]
     subscribeNext:^(RACTuple * tuple) {
         @strongify(self);
         NSString *viewController = self.viewModelViewMappings[NSStringFromClass(tuple.first)];
         UINavigationController *controller = self.navigationControllers.lastObject;
         for (BaseViewController *topViewController in controller.viewControllers) {
             if ([NSStringFromClass(topViewController.class) isEqualToString:viewController]) {
                 [controller popToViewController:topViewController animated:[tuple.second boolValue]];
             }
         }
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(popToRootViewModelAnimated:)]
     subscribeNext:^(RACTuple * tuple) {
         @strongify(self);
         [self.navigationControllers.lastObject popToRootViewControllerAnimated:[tuple.first boolValue]];
     }];
    
//    [[(NSObject *)self.services
//      rac_signalForSelector:@selector(popToBarControllerIndex:)]
//     subscribeNext:^(RACTuple * tuple) {
//         @strongify(self);
//         [self.navigationControllers.lastObject popToRootViewControllerAnimated:NO];
//         [ZGCNotificationCenter postNotificationName:ZGCChangeTabBarIndexNotification object:nil userInfo:@{@"data":tuple.first}];
//     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(presentViewModel:animated:completion:)]
     subscribeNext:^(RACTuple * tuple) {
         @strongify(self);
         UIViewController *viewController = (UIViewController *)[self viewControllerForViewModel:tuple.first];
         
         UINavigationController *presentingViewController = self.navigationControllers.lastObject;
         if (![viewController isKindOfClass:UINavigationController.class]) {
             viewController = [[BaseNavigationController alloc] initWithRootViewController:viewController];
         }
         [self pushNavigationController:(UINavigationController *)viewController];
         [presentingViewController presentViewController:viewController animated:[tuple.second boolValue] completion:tuple.third];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(dismissViewModelAnimated:completion:)]
     subscribeNext:^(RACTuple * tuple) {
         @strongify(self);
         [self popNavigationController];
         [self.navigationControllers.lastObject dismissViewControllerAnimated:[tuple.first boolValue] completion:tuple.second];
     }];
    
    [[(NSObject *)self.services
      rac_signalForSelector:@selector(resetRootViewModel:)]
     subscribeNext:^(RACTuple * tuple) {
         @strongify(self);
         [self.navigationControllers removeAllObjects];
         // VM映射VC
         UIViewController *viewController = (UIViewController *)[self viewControllerForViewModel:tuple.first];
         if (![viewController isKindOfClass:BaseNavigationController.class]) {
             viewController = [[BaseNavigationController alloc] initWithRootViewController:viewController];
             [self pushNavigationController:(UINavigationController *)viewController];
         }
         // 判断 rootViewController 是否改变
         id obj = SharedAppDelegate.window.rootViewController;
         if (kObjectIsNil(obj)) {
             SharedAppDelegate.window.rootViewController = viewController;
         } else if (![viewController isKindOfClass:SharedAppDelegate.window.rootViewController.class]) {
             SharedAppDelegate.window.rootViewController = viewController;
         }
     }];
}

/* 获得给定 viewModel 的视图控制器 */
- (BaseViewController *)viewControllerForViewModel:(BaseViewModel *)viewModel {
    NSString *viewController = self.viewModelViewMappings[NSStringFromClass(viewModel.class)];
    
    NSParameterAssert([NSClassFromString(viewController) isSubclassOfClass:BaseViewController.class]);
    NSParameterAssert([NSClassFromString(viewController) instancesRespondToSelector:@selector(initWithViewModel:)]);
    
    return [[NSClassFromString(viewController) alloc] initWithViewModel:viewModel];
}

/* 这里是 viewModel -> ViewController 的映射 */
- (NSDictionary *)viewModelViewMappings {
    return @{@"LoginViewModel":@"LoginViewController",
             @"MainViewModel":@"MainViewController",
             @"CalculatorViewModel":@"CalculatorViewController",
             @"ShopCartViewModel":@"ShopCartViewController",
             @"PersonalCenterViewModel":@"PersonalCenterViewController",
             @"SettingViewModel":@"SettingViewController",
             @"VipRateViewModel":@"VipRateViewController",
             @"ContactInfoViewModel":@"ContactInfoViewController",
             @"NoteViewModel":@"NoteViewController",
             @"DateSelectViewModel":@"DateSelectViewController",
             @"ChangePasswordViewModel":@"ChangePasswordViewController",
             @"AccountViewModel":@"AccountViewController",
             @"ProfileViewModel":@"ProfileViewController",
             @"ChangeProfileViewModel":@"ChangeProfileViewController",
             @"OrderCenterViewModel":@"OrderCenterViewController",
             @"SearchViewModel":@"SearchViewController",
             @"CertSearchViewModel":@"CertSearchViewController",
             @"StyleCenterViewModel":@"StyleCenterViewController",
             @"StyleDetailViewModel":@"StyleDetailViewController",
             @"PdfViewModel":@"PdfViewController",
             @"DiamSearchViewModel":@"DiamSearchViewController",
             @"FancySearchViewModel":@"FancySearchViewController",
             @"QuoteViewModel":@"QuoteViewController",
             @"DiamSearchResultViewModel":@"DiamSearchResultViewController",
             @"AccountAddViewModel":@"AccountAddViewController",
             @"AccountEditViewModel":@"AccountEditViewController",
             @"QRCodeViewModel":@"QRCodeViewController",
             };
}

@end
