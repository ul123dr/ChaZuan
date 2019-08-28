//
//  ViewModelServicesImpl.m
//  chazuan
//
//  Created by BecksZ on 2019/4/14.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ViewModelServicesImpl.h"

@interface ViewModelServicesImpl ()

// navigationController列表
@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation ViewModelServicesImpl
@synthesize client = _client;
- (instancetype)init {
    self = [super init];
    if (self) {
        _client = [HTTPService sharedInstance];
    }
    return self;
}


#pragma mark - ZGCNavigationProtocol 的空实现
- (void)pushViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToViewModel:(Class)viewModel animated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)popToBarControllerIndex:(NSNumber *)index {}

- (void)presentViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(VoidBlock)completion {}

- (void)resetRootViewModel:(BaseViewModel *)viewModel {}


@end
