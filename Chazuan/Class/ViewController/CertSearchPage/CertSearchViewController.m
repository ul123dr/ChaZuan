//
//  CertSearchViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertSearchViewController.h"
#import "SegmentControl.h"

@interface CertSearchViewController ()

@property (nonatomic, readwrite, strong) CertSearchViewModel *viewModel;
@property (nonatomic, readwrite, strong) SegmentControl *control;

@end

@implementation CertSearchViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupSubviews];
    [self _setupSubviewsConstraint];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    RAC(self.viewModel, type) = [[RACObserve(self.control, selectIndex) ignore:0] map:^id(NSNumber *x) {
        return x;
    }];
    
    [self.viewModel.searchCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
    
    [RACObserve(self.viewModel, open) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (self.viewModel.dataSource.count == 0) return;
        if (!x.boolValue) self.viewModel.selectHeight = ZGCConvertToPx(123);
        else self.viewModel.selectHeight = self.viewModel.type==1?ZGCConvertToPx(211):ZGCConvertToPx(255);
        [UIView animateWithDuration:0 animations:^{
            [self.tableView beginUpdates];
            [self.tableView endUpdates];
        }];
    }];
    
    // 错误处理
    [[RACObserve(self.viewModel, error) ignore:nil] subscribeNext:^(NSError *err) {
        [MBProgressHUD zgc_hideHUD];
        [SVProgressHUD showErrorWithStatus:err.userInfo[HTTPServiceErrorDescriptionKey]];
    }];
}

#pragma mark - 创建页面
- (void)_setupSubviews {
    SegmentViewModel *viewModel = [[SegmentViewModel alloc] init];
    viewModel.font = kFont(15);
    viewModel.color = kHexColor(@"#1C2B36");
    viewModel.tintColor = COLOR_MAIN;
    viewModel.backColor = UIColor.whiteColor;
    viewModel.backTintColor = UIColor.whiteColor;
    SegmentControl *control = [SegmentControl segmentWithItems:@[@"国际",@"国内"]];
    [control bindViewModel:viewModel];
    control.layer.shadowColor = kHexColor(@"#C0C0C0").CGColor;
    control.layer.shadowOpacity = 0.6;
    control.layer.shadowRadius = 3;
    control.layer.shadowOffset = CGSizeMake(0, 3);
    self.control = control;
    [self.view addSubview:control];
}

- (void)_setupSubviewsConstraint {
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kNavHeight);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(44));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight+ZGCConvertToPx(44), 0, kBottomSpace, 0));
    }];
}
@end
