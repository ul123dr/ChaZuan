//
//  QuoteViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/13.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "QuoteViewController.h"
#import "QuoteHeaderView.h"

@interface QuoteViewController ()

@property (nonatomic, readwrite, strong) QuoteViewModel *viewModel;

@end

@implementation QuoteViewController

@synthesize viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindViewModel {
    [super bindViewModel];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QuoteHeaderView *headerView = [QuoteHeaderView headerWithTableView:tableView];
    QuoteGroupViewModel *groupViewModel = self.viewModel.dataSource[section];
    [headerView bindViewModel:groupViewModel];
    return headerView;
}

@end
