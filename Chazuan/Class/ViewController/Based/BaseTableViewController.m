//
//  BaseTableViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "TableViewHeaderView.h"
#import "TableViewFooterView.h"

@interface BaseTableViewController ()
// viewModel
@property (nonatomic, readonly, strong) BaseTableViewModel *viewModel;
// tableView
@property (nonatomic, readwrite, weak) UITableView *tableView;

@end

@implementation BaseTableViewController

@dynamic viewModel;

- (void)dealloc {
    // set nil
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置子视图
    [self _setupSubview];
    // 布局
    [self _setupSubviewConstraint];
}

#pragma mark - Public Method subClass can override it
/* 刷新 TableView */
- (void)reloadData {
    [self.tableView reloadData];
}

/* cell 赋值 */
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    [cell bindViewModel:object];
}

/* 获得cell */
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    CommonItemViewModel *itemViewModel = nil;
    if (self.viewModel.shouldMultiSections) {
        CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[indexPath.section];
        itemViewModel = groupViewModel.itemViewModels[indexPath.row];
    } else {
        itemViewModel = self.viewModel.dataSource[indexPath.row];
    }
    if ([itemViewModel isKindOfClass:CommonItemViewModel.class]) return [itemViewModel.tableViewCellClass cellWithTableView:tableView style:itemViewModel.cellStyle];
    else return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

#pragma mark - override
- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    // observe viewModel's dataSource
    [[RACObserve(self.viewModel, dataSource) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        // 刷新数据
        [self reloadData];
    }];
    
    // 隐藏emptyView
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
}

#pragma mark - Delegate
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.viewModel.shouldMultiSections) return self.viewModel.dataSource ? self.viewModel.dataSource.count : 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewModel.shouldMultiSections) {
        CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
        return groupViewModel.itemViewModels.count;
    }
    return self.viewModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // fetch object
    CommonItemViewModel *itemViewModel = nil;
    if (self.viewModel.shouldMultiSections) {
        CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[indexPath.section];
        itemViewModel = groupViewModel.itemViewModels[indexPath.row];
    } else {
        itemViewModel = self.viewModel.dataSource[indexPath.row];
    }
    
    // bind model
    [self configureCell:cell atIndexPath:indexPath withObject:itemViewModel];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonItemViewModel *itemViewModel = nil;
    if (self.viewModel.shouldMultiSections) {
        CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[indexPath.section];
        itemViewModel = groupViewModel.itemViewModels[indexPath.row];
    } else {
        itemViewModel = self.viewModel.dataSource[indexPath.row];
    }
    if ([itemViewModel isKindOfClass:CommonItemViewModel.class]) return itemViewModel.rowHeight;
    else return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.didSelectCommand execute:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TableViewFooterView *footerView = [TableViewFooterView footerWithTableView:tableView];
    if (self.viewModel.shouldMultiSections) {
        CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
        [footerView bindViewModel:groupViewModel];
    }
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableViewHeaderView *headerView = [TableViewHeaderView headerWithTableView:tableView];
    if (self.viewModel.shouldMultiSections) {
        CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
        [headerView bindViewModel:groupViewModel];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.viewModel.shouldMultiSections) {
        CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
        return groupViewModel.footerHeight;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.viewModel.shouldMultiSections) {
        CommonGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
        return groupViewModel.headerHeight;
    }
    return CGFLOAT_MIN;
}

#pragma mark - 辅助方法
#pragma mark 上下拉刷新事件
/* 下拉事件 */
- (void)tableViewDidTriggerHeaderRefresh {
    @weakify(self);
    [[[self.viewModel.requestRemoteDataCommand execute:@1] deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        self.viewModel.page = 1;
        // 重置没有更多的状态
        if (self.viewModel.shouldEndRefreshingWithNoMoreData) [self.tableView.mj_footer resetNoMoreData];
    } error:^(NSError *error) {
        @strongify(self);
        // 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以reload = NO即可
        [self.tableView.mj_header endRefreshing];
    } completed:^{
        @strongify(self);
        // 已经在bindViewModel中添加了对viewModel.dataSource的变化的监听来刷新数据,所以只要结束刷新即可
        [self.tableView.mj_header endRefreshing];
        // 请求完成
        [self _requestDataCompleted];
    }];
}

/* 上拉事件 */
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
         [self.tableView.mj_footer endRefreshing];
     } completed:^{
         @strongify(self);
         [self.tableView.mj_footer endRefreshing];
         // 请求完成
         [self _requestDataCompleted];
     }];
}

#pragma mark 辅助方法
- (void)_requestDataCompleted {
    NSUInteger count = self.viewModel.dataSource.count;
    // 这里必须要等到，底部控件结束刷新后，再来设置无更多数据，否则被叠加无效
    if (!self.viewModel.shouldEndRefreshingWithNoMoreData && count%self.viewModel.perPage)
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - 创建页面
/* 设置子控件，子类不能使用相同方法，不然父类方法不调用 */
- (void)_setupSubview {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.viewModel.style];
    tableView.backgroundColor = COLOR_BG;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = UIColor.clearColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView adaptateIos11];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    // 注册cell
    [self.tableView zgc_registerCell:UITableViewCell.class];
    
    @weakify(self);
    // 下拉刷新
    if (self.viewModel.shouldPullDownToRefresh) {
        [self.tableView addHeaderRefresh:^(MJRefreshNormalHeader * header) {
            @strongify(self);
            [self tableViewDidTriggerHeaderRefresh];
        }];
        [self.tableView.mj_header beginRefreshing];
    }
    // 上拉刷新
    if (self.viewModel.shouldPullUpToLoadMore) {
        [self.tableView addFooterRefresh:^(MJRefreshAutoNormalFooter *footer) {
            @strongify(self);
            [self tableViewDidTriggerFooterRefresh];
        }];
        
        // 隐藏 footer or 无更多数据
        RAC(self.tableView.mj_footer, hidden) = [[RACObserve(self.viewModel, dataSource) deliverOnMainThread] map:^(NSArray *dataSource) {
            @strongify(self);
            NSUInteger count = dataSource.count;
            // 无数据，默认隐藏 mj_footer
            if (count == 0) return @1;
            
            if (self.viewModel.shouldEndRefreshingWithNoMoreData) return @(0);
            
            // because of
            return (count % self.viewModel.perPage)?@1:@0;
        }];
    }
}

/* 子控件布局，子类不能使用相同方法，不然父类方法不调用 */
- (void)_setupSubviewConstraint {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(kNavHeight, 0, kBottomSpace, 0));
    }];
}

@end
