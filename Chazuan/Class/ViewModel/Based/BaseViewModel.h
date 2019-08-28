//
//  BaseViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/14.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewModelServices;

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewModel : NSObject

- (instancetype)initWithServices:(id<ViewModelServices>)services params:(nullable NSDictionary *)params;

@property (nonatomic, readonly, strong) id<ViewModelServices> services;
@property (nonatomic, readonly, strong) NSDictionary *params;

@property (nonatomic, readwrite, strong) UIColor *backgroundColor;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) VoidBlock_id callback;
@property (nonatomic, readwrite, assign) BOOL interactivePopDisabled;

// NavigationBar
@property (nonatomic, readwrite, assign) BOOL navBarHidden;
@property (nonatomic, readwrite, assign) UIBarStyle navBarStyle;
@property (nonatomic, readwrite, strong) UIColor *navBarTintColor;
@property (nonatomic, readwrite, assign) float navBarAlpha;
@property (nonatomic, readwrite, assign) BOOL navBarShadowHidden;

// IQKeyboardManager
@property (nonatomic, readwrite, assign) BOOL keyboardEnable;
@property (nonatomic, readwrite, assign) BOOL shouldResignOnTouchOutside;
@property (nonatomic, readwrite, assign) CGFloat keyboardDistanceFromTextField;
@property (nonatomic, readwrite, assign) BOOL enableAutoToolbar;

@property (nonatomic, readonly, strong) RACSubject *errors;

- (void)initialize;

- (void)clearup;

@end

NS_ASSUME_NONNULL_END
