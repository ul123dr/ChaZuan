//
//  QRCodeViewController.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()

@property (nonatomic, readwrite, strong) QRCodeViewModel *viewModel;
@property (nonatomic, readwrite, strong) UIImageView *qrImageView;

@end

@implementation QRCodeViewController

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _setupSubviews];
    [self _setupSubviewsConstraint];
}

- (void)bindViewModel {
    [super bindViewModel];
    RAC(self.qrImageView, image) = RACObserve(self.viewModel, qrImage);
}

- (void)_setupSubviews {
    UIImageView *qrImageView = [[UIImageView alloc] init];
    self.qrImageView = qrImageView;
    [self.view addSubview:qrImageView];
}

- (void)_setupSubviewsConstraint {
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.height.mas_equalTo(ZGCConvertToPx(200));
    }];
}

@end
