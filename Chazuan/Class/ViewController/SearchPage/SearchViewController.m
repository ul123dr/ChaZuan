//
//  SearchViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchFooterView.h"
#import "SearchBar.h"

@interface SearchViewController ()<UISearchBarDelegate>

@property (nonatomic, readwrite, strong) SearchViewModel *viewModel;
@property (nonatomic, readwrite, strong) SearchBar *searchBar;

@end

@implementation SearchViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupSubviews];
    
    [self.viewModel.requestRemoteDataCommand execute:@1];
}

- (void)bindViewModel {
    [super bindViewModel];
    
//    @weakify(self);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SearchFooterView *footerView = [SearchFooterView footerWithTableView:tableView];
    SearchGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [footerView bindViewModel:groupViewModel];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.didSelectCommand execute:indexPath];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.viewModel.didSelectCommand execute:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.viewModel.services popViewModelAnimated:YES];
}

- (void)_setupSubviews {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    self.navigationItem.titleView = titleView;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-(IPHONE_4_7_INFO?8:12), 0, kScreenW, 44)];
    searchBar.showsCancelButton = YES;
    searchBar.placeholder = @"请输入订单号";
    searchBar.delegate = self;
    [titleView addSubview:searchBar];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[UISearchBar.class]] setTitle:@"取消"];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[UISearchBar.class]] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor} forState:UIControlStateNormal];
    [searchBar becomeFirstResponder];
}

@end
