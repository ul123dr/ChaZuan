//
//  BaseViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseViewController.h"
#import "TipsView.h"

@interface BaseViewController ()

// viewModel
@property (nonatomic, readwrite, strong) BaseViewModel *viewModel;
@property (nonatomic, readwrite, strong) TipsView *tipView;

@end

@implementation BaseViewController

- (void)dealloc {
    ZGCDealloc;
}

/* 当 `BaseViewController` 创建并调用 `viewDidLoad` 时，执行 `bindViewModel` 方法 */
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseViewController *viewController = [super allocWithZone:zone];
    @weakify(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    return viewController;
}

- (instancetype)initWithViewModel:(BaseViewModel *)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 配置键盘
    IQKeyboardManager.sharedManager.enable = self.viewModel.keyboardEnable;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = self.viewModel.shouldResignOnTouchOutside;
    IQKeyboardManager.sharedManager.keyboardDistanceFromTextField = self.viewModel.keyboardDistanceFromTextField;
    IQKeyboardManager.sharedManager.enableAutoToolbar = self.viewModel.enableAutoToolbar;
    // 这里做统计
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 当 pop/present 页面时，获取一个 snapshot view
    if ([self isMovingFromParentViewController]) {
        self.snapshot = [self.navigationController.view snapshotViewAfterScreenUpdates:NO];
    }
    // 这里做统计
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // iOS11 以上 忽略自动滚动 64
    if (@available(iOS 11, *)) {
        self.automaticallyAdjustsScrollViewInsets = YES;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 保证 view 在 NavigationBar 下面
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    // pop手势
    self.fd_interactivePopDisabled = self.viewModel.interactivePopDisabled;
    
    // 导航栏颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:kFont(16)}];
} 

#pragma mark - 数据绑定
- (void)bindViewModel {
    @weakify(self);
    // viewModel.title 单纯设置 navItem.title。这样避免 self.title 同时设置 navItem.title 和 tabItem.title。
    RAC(self.navigationItem , title) = RACObserve(self, viewModel.title);
    // backgroundColor
    RAC(self.view, backgroundColor) = RACObserve(self, viewModel.backgroundColor);
    
    // 动态改变
    [[[RACObserve(self.viewModel, interactivePopDisabled) distinctUntilChanged] deliverOnMainThread] subscribeNext:^(NSNumber * x) {
        @strongify(self);
        self.fd_interactivePopDisabled = x.boolValue;
    }];
}

- (void)showTipView:(UIView *)fatherView andMessage:(NSString *)message andImgPath:(NSString *)imageName andBlock:(VoidBlock)handle {
    if (self.tipView) [self hiddenTipView];
    self.tipView = [TipsView showWithFrame:fatherView.bounds andMessage:message andImagePath:imageName andHandle:handle];
    [fatherView addSubview:self.tipView];
}

- (void)showTipView:(UIView *)fatherView andMessage:(NSString *)message andOffset:(CGFloat)offset {
    if (self.tipView) [self hiddenTipView];
    CGRect fatherFrame = fatherView.bounds;
    fatherFrame.origin.y += offset;
    self.tipView = [TipsView showWithFrame:fatherFrame andMessage:message andImagePath:nil andHandle:nil];
    [fatherView addSubview:self.tipView];
}

- (void)hiddenTipView {
    if (self.tipView) {
        [self.tipView removeFromSuperview];
        self.tipView = nil;
    }
}

#pragma mark - YPNavigationBarConfigureStyle 实现
- (YPNavigationBarConfigurations)yp_navigtionBarConfiguration {
    YPNavigationBarConfigurations configurations = YPNavigationBarShow;
    if (self.viewModel.navBarAlpha < 0.5) {
        if (self.viewModel.navBarStyle == UIBarStyleDefault) {
            configurations |= YPNavigationBarStyleLight;
        } else {
            configurations |= YPNavigationBarStyleBlack;
        }
    }
    if (self.viewModel.navBarAlpha == 1) {
        configurations |= YPNavigationBarBackgroundStyleOpaque;
    }
    if (!self.viewModel.navBarShadowHidden) {
        configurations |= YPNavigationBarShowShadowImage;
    }
    if (self.viewModel.navBarHidden) {
        configurations |= YPNavigationBarHidden;
    }
    configurations |= YPNavigationBarBackgroundStyleColor;
    return configurations;
}

- (UIColor *)yp_navigationBarTintColor {
    return self.viewModel.navBarTintColor;
}

/* 该方法用来设置透明度使用 */
- (UIColor *)yp_navigationBackgroundColor {
    return [self.viewModel.navBarTintColor colorWithAlphaComponent:self.viewModel.navBarAlpha];
}


@end
