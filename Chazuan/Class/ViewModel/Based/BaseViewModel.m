//
//  BaseViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/14.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseViewModel.h"

@interface BaseViewModel ()

@property (nonatomic, readwrite, strong) id<ViewModelServices> services;
@property (nonatomic, readwrite, strong) NSDictionary *params;
@property (nonatomic, readwrite, strong) RACSubject *errors;

@end

@implementation BaseViewModel

/* 当 BaseViewModel 创建并调用 `-initWithParams:` 方法时，我们可以 `initialize` */
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseViewModel *viewModel = [super allocWithZone:zone];
    @weakify(viewModel)
    [[viewModel
      rac_signalForSelector:@selector(initWithServices:params:)]
     subscribeNext:^(id x) {
         @strongify(viewModel)
         [viewModel initialize];
     }];
    return viewModel;
}

/* 初始化并赋初始值 */
- (instancetype)initWithServices:(id<ViewModelServices>)services params:(NSDictionary *)params {
    self = [super init];
    if (self) {
        // 赋值
        self.services = services;
        self.params   = params;
        // title
        self.title = params[ViewModelTitleKey];
        // backgroudColor
        self.backgroundColor = UIColor.whiteColor;
        
        // 导航栏设置
        self.navBarStyle = UIBarStyleDefault;
        self.navBarTintColor = COLOR_MAIN;
        self.navBarAlpha = 1.0;
        
        // 允许IQKeyboardMananger接管键盘弹出事件
        self.keyboardEnable = YES;
        self.shouldResignOnTouchOutside = YES;
        self.keyboardDistanceFromTextField = 10.0f;
        self.enableAutoToolbar = YES;
    }
    return self;
}

- (RACSubject *)errors {
    if (!_errors) _errors = [RACSubject subject];
    return _errors;
}

/* 子类实现 */
- (void)initialize {
    
}

/* 子类实现 */
- (void)clearup {
    
}

@end
