//
//  SettingViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@property (nonatomic, readwrite, strong) SettingViewModel *viewModel;

@end

@implementation SettingViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.viewModel.requestRemoteDataCommand execute:nil];
}

- (void)bindViewModel {
    [super bindViewModel];
}

@end
