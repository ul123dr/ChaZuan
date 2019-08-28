//
//  NavigationProtocol.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NavigationProtocol <NSObject>

/// Push 对应的 ViewController
///
/// 使用平滑过渡(horizontal slide transition)。
/// 如果相应的视图控制器已经在堆栈中，则无效。
///
/// @param viewModel viewModel
/// @param animated 是否使用animation
- (void)pushViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated;

/// Pop 到上一层 ViewController
///
/// @param animated 是否使用animation
- (void)popViewModelAnimated:(BOOL)animated;

/// Pop 到指定 viewController
///
/// @param viewModel 控制器对应的 ViewModel
/// @param animated 是否使用animation
- (void)popToViewModel:(Class)viewModel animated:(BOOL)animated;

/// Pop 直到堆栈中只剩一个 ViewController
///
/// @param animated 是否使用animation
- (void)popToRootViewModelAnimated:(BOOL)animated;

/// pop 到指定的 TabbarController 页面
///
/// @param index tabBarController 页面的下标
- (void)popToBarControllerIndex:(NSNumber *)index;

/// Present 对应的 ViewController
///
/// @param viewModel viewModel
/// @param animated 是否使用animation
/// @param completion 完成处理
- (void)presentViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated completion:(nullable VoidBlock)completion;

/// Dismiss 对应的 ViewController
///
/// @param animated 是否使用animation
/// @param completion 完成处理
- (void)dismissViewModelAnimated:(BOOL)animated completion:(nullable VoidBlock)completion;

/// 更换 window 的 rootViewController
///
/// @param viewModel 对应的 viewModel
- (void)resetRootViewModel:(BaseViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
