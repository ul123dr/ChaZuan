//
//  BaseNavigationController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface BaseNavigationController ()

@property (nonatomic, getter = isPushing) BOOL pushing; // 记录push状态
@end


@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.delegate = self;
}

#pragma mark - Public Method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSAssert([viewController isKindOfClass:BaseViewController.class], @"viewController Must be a subclass of BaseViewController");
    if (self.pushing) {
        return;
    } else {
        self.pushing = YES;
    }
    
    if (self.viewControllers.count > 0) {
        // 隐藏底部tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 这里可以设置导航栏的左右按钮 统一管理方法
        ZGButton *item = [ZGButton buttonWithType:UIButtonTypeCustom];
        [item setImage:ImageNamed(@"top_back") forState:UIControlStateNormal];
        item.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 11);
        [item addTarget:self action:@selector(_back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    }
    // push
    [super pushViewController:viewController animated:animated];
    self.pushing = NO;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSAssert([viewController isKindOfClass:BaseViewController.class], @"viewController Must be a subclass of BaseViewController");
    return [super popToViewController:viewController animated:animated];
}

#pragma mark - NavigationController Delegate
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    self.pushing = NO;
//}

#pragma mark - Action
- (void)_back {
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
