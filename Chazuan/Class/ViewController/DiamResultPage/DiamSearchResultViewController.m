//
//  DiamSearchResultViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamSearchResultViewController.h"
#import "ZGFormView.h"
#import "DiamSuspendCollectionViewCell.h"
#import "DiamCollectionViewCell.h"
#import "DiamResultHeaderView.h"
#import "FancySuspendCollectionViewCell.h"
#import "FancyCollectionViewCell.h"

@interface DiamSearchResultViewController ()<FormViewDataSource>

@property (nonatomic, readwrite, strong) DiamSearchResultViewModel *viewModel;
@property (nonatomic, readwrite, strong) DiamResultHeaderView *headerView;
@property (nonatomic, readwrite, strong) ZGFormView *formView;
@property (nonatomic, readwrite, strong) ZGButton *picShowBtn;

@end

@implementation DiamSearchResultViewController

@dynamic viewModel;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    IQKeyboardManager.sharedManager.enableAutoToolbar = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setupSubviews];
    [self _setupNavigationItem];
    [self _initSubviewsConstraints];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
    [self.viewModel.supplierCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];

    @weakify(self);
    [RACObserve(self.viewModel, dataSource) subscribeNext:^(id x) {
        @strongify(self);
        [self.formView reload];
    }];
    
    [RACObserve(self.viewModel, searchText) subscribeNext:^(NSString *text) {
        @strongify(self);
        self.headerView.searchTextLabel.text = text;
    }];
    if ([SingleInstance boolForKey:RapShowKey] && [SingleInstance boolForKey:DiscShowKey]) self.headerView.quoteBtn.rac_command = self.viewModel.quoteCommand;
    self.headerView.cartBtn.rac_command = self.viewModel.cartCommand;
    self.headerView.orderBtn.rac_command = self.viewModel.orderCommand;
    
    [RACObserve(self.viewModel, headerHeight) subscribeNext:^(NSNumber *height) {
        @strongify(self);
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight, 0, kScreenH-kNavHeight-height.floatValue, 0));
        }];
        [self.formView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight+height.floatValue, 0, kBottomSpace, 0));
        }];
    }];

    [RACObserve(self.viewModel, goodIsNull) subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            [self showTipView:self.formView andMessage:@"没有符合的数据" andOffset:ZGCConvertToPx(40)];
        } else {
            [self hiddenTipView];
        }
    }];
    
    [self.viewModel.showPicSub subscribeNext:^(NSString *pic) {
        @strongify(self);
        [self _showPicView:pic];
    }];
}

- (void)_showPicView:(NSString *)picUrl {
    ZGButton *picBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:picBtn];
    picBtn.backgroundColor = UIColor.blackColor;
    picBtn.frame = CGRectMake(ZGCConvertToPx(50), ZGCConvertToPx(50), kScreenW-ZGCConvertToPx(100), kScreenH-ZGCConvertToPx(100));
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW)];
    imgV.backgroundColor = UIColor.whiteColor;
    [imgV sd_setImageWithURL:[NSURL URLWithString:picUrl]];
    [picBtn addSubview:imgV];
    imgV.center = picBtn.center;
    
    self.picShowBtn = picBtn;
    
    CGRect frame = picBtn.superview.bounds;
    [UIView animateWithDuration:0.3 animations:^{
        picBtn.frame = frame;
    }];
    
    @weakify(self);
    [[picBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        [sender removeFromSuperview];
        self.picShowBtn = nil;
    }];
}

#pragma mark - delegate & dataSource
- (NSInteger)numberOfSectionsInFormView:(ZGFormView *)formView {
    return self.viewModel.dataSource.count;
}

- (NSInteger)formView:(ZGFormView *)formView numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.dataSource[section] count];
}

- (NSInteger)numberOfSuspendSectionsInFormView:(ZGFormView *)formView {
    return 1;
}

- (NSInteger)formView:(ZGFormView *)formView numberOfSuspendItemsInSection:(NSInteger)section {
    return 0;
}

- (CGSize)formView:(ZGFormView *)formView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DiamSearchResultItemViewModel *item = self.viewModel.dataSource[indexPath.section][indexPath.row];
    if (self.viewModel.type == 1)
        return CGSizeMake(kScreenW, item.rowHeight);
    else
        return CGSizeMake(kScreenW*2, item.rowHeight);
}

- (__kindof UICollectionViewCell *)collectionViewCell:(UICollectionViewCell *)collectionViewCell collectionViewType:(FormCollectionViewType)type cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.type == 1) {
        if (indexPath.section == 0) {
            DiamSuspendCollectionViewCell *headcell = (DiamSuspendCollectionViewCell *)collectionViewCell;
            [headcell bindViewModel:self.viewModel.dataSource[indexPath.section][indexPath.row]];
            return headcell;
        } else {
            DiamCollectionViewCell *cell = (DiamCollectionViewCell *)collectionViewCell;
            [cell bindViewModel:self.viewModel.dataSource[indexPath.section][indexPath.row]];
            return cell;
        }
    } else {
        if (indexPath.section == 0) {
            FancySuspendCollectionViewCell *headcell = (FancySuspendCollectionViewCell *)collectionViewCell;
            [headcell bindViewModel:self.viewModel.dataSource[indexPath.section][indexPath.row]];
            return headcell;
        } else {
            FancyCollectionViewCell *cell = (FancyCollectionViewCell *)collectionViewCell;
            [cell bindViewModel:self.viewModel.dataSource[indexPath.section][indexPath.row]];
            return cell;
        }
    }
}

#pragma mark - 创建页面
- (void)_setupSubviews {
    DiamResultHeaderView *headerView = [[DiamResultHeaderView alloc] init];
    self.headerView = headerView;
    [self.view addSubview:headerView];
    
    ZGFormView *formView = [[ZGFormView alloc] initWithFrame:CGRectZero type:FormViewTypeSectionAndRowFixation];
    formView.dataSource = self;
    if (self.viewModel.type == 1) {
        [formView registerClass:DiamSuspendCollectionViewCell.class isHeader:YES];
        [formView registerClass:DiamCollectionViewCell.class isHeader:NO];
    } else {
        [formView registerClass:FancySuspendCollectionViewCell.class isHeader:YES];
        [formView registerClass:FancyCollectionViewCell.class isHeader:NO];
    }
    self.formView = formView;
    [self.view addSubview:formView];
    
    @weakify(self);
    [formView.mainCV addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
        [self tableViewDidTriggerFooterRefresh];
    }];
    
    // 隐藏 footer or 无更多数据
    RAC(formView.mainCV.mj_footer, hidden) = [[RACObserve(self.viewModel, dataSource) deliverOnMainThread] map:^(NSArray *dataSource) {
        @strongify(self);
        NSUInteger count = dataSource.count-1;
        // 无数据，默认隐藏 mj_footer
        if (count == 0) return @1;
        
        if (self.viewModel.shouldEndRefreshingWithNoMoreData) return @(0);
        
        // because of
        return (count % self.viewModel.perPage)?@1:@0;
    }];
}

- (void)tableViewDidTriggerFooterRefresh {
    @weakify(self);
    [[[self.viewModel.requestRemoteDataCommand
       execute:@(self.viewModel.page + 1)]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self);
         self.viewModel.page += 1;
     } error:^(NSError *error) {
         @strongify(self);
         [self.formView.mainCV.mj_footer endRefreshing];
     } completed:^{
         @strongify(self);
         [self.formView.mainCV.mj_footer endRefreshing];
         // 请求完成
         [self _requestDataCompleted];
     }];
}

#pragma mark 辅助方法
- (void)_requestDataCompleted {
    NSUInteger count = self.viewModel.dataSource.count-1;
    // 这里必须要等到，底部控件结束刷新后，再来设置无更多数据，否则被叠加无效
    if (!self.viewModel.shouldEndRefreshingWithNoMoreData && count%self.viewModel.perPage)
        [self.formView.mainCV.mj_footer endRefreshingWithNoMoreData];
}

- (void)_setupNavigationItem {
    ZGButton *rightBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:ImageNamed(@"shop_cart") forState:UIControlStateNormal];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    rightBtn.rac_command = self.viewModel.shopcartCommand;
}

- (void)_initSubviewsConstraints {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight, 0, kScreenH-kNavHeight, 0));
    }];
    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight, 0, kBottomSpace, 0));
    }];
}

@end
