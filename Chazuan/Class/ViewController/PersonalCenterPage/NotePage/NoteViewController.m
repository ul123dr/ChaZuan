//
//  NoteViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@property (nonatomic, readwrite, strong) NoteViewModel *viewModel;

@end

@implementation NoteViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _setupNavigationItem];
    [self.viewModel.requestRemoteDataCommand execute:@1];
}

- (void)bindViewModel {
    [super bindViewModel];
}

- (void)_setupNavigationItem {
//    ZGButton *deleteBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
//    [deleteBtn setImage:ImageNamed(@"news_delete") forState:UIControlStateNormal];
//    [deleteBtn setTitle:@"完成" forState:UIControlStateSelected];
//    [deleteBtn setTitleColor:UIColor.whiteColor forState:UIControlStateSelected];
//    deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
//    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    
    ZGButton *searchBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:ImageNamed(@"new_app_03") forState:UIControlStateNormal];
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 0);
//    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];//@[searchItem, deleteItem];
    
//    @weakify(self);
//    [[deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
//        @strongify(self);
//        sender.selected = !sender.selected;
//        [self.viewModel.deleteCommand execute:@(sender.selected)];
//    }];
    
    searchBtn.rac_command = self.viewModel.searchCommand;
}

@end
