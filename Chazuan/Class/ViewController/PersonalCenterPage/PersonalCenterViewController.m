//
//  PersonalCenterViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "PersonalCenterViewController.h"

@interface PersonalCenterViewController ()

@property (nonatomic, readwrite, strong) PersonalCenterViewModel *viewModel;

@end

@implementation PersonalCenterViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindViewModel {
    [super bindViewModel];
}

@end
