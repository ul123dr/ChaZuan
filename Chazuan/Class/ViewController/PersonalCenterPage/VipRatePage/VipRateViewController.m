//
//  VipRateViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "VipRateViewController.h"

@interface VipRateViewController ()

@property (nonatomic, readwrite, strong) VipRateViewModel *viewModel;

@end

@implementation VipRateViewController

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
