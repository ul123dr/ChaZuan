//
//  CalculatorViewController.m
//  chazuan
//
//  Created by BecksZ on 2019/4/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CalculatorViewController.h"
#import "SelectView.h"
#import "SegmentControl.h"
#import "KeyboardView.h"

@interface CalculatorViewController ()<UITextFieldDelegate>

@property (nonatomic, readwrite, strong) CalculatorViewModel *viewModel;
@property (nonatomic, readwrite, strong) SelectView *colorView;
@property (nonatomic, readwrite, strong) SelectView *clarityView;
@property (nonatomic, readwrite, strong) SegmentControl *control;
@property (nonatomic, readwrite, strong) UILabel *clarityL;
@property (nonatomic, readwrite, strong) UITextField *caratTF;
@property (nonatomic, readwrite, strong) UILabel *rapPriceL;
@property (nonatomic, readwrite, strong) UITextField *rapPriceTF;
@property (nonatomic, readwrite, strong) UILabel *rateL;
@property (nonatomic, readwrite, strong) UITextField *rateTF;
@property (nonatomic, readwrite, strong) UILabel *discountL;
@property (nonatomic, readwrite, strong) UITextField *discountTF;
@property (nonatomic, readwrite, strong) UILabel *dollarPriceL;
@property (nonatomic, readwrite, strong) UITextField *dollarPriceTF;
@property (nonatomic, readwrite, strong) UILabel *rmbPriceL;
@property (nonatomic, readwrite, strong) UITextField *rmbPriceTF;
@property (nonatomic, readwrite, strong) UIView *dividerLine;
@property (nonatomic, readwrite, strong) UILabel *dollarResultL1;
@property (nonatomic, readwrite, strong) UILabel *dollarResultL2;
@property (nonatomic, readwrite, strong) UILabel *dollarResultL3;
@property (nonatomic, readwrite, strong) UILabel *rmbResultL1;
@property (nonatomic, readwrite, strong) UILabel *rmbResultL2;
@property (nonatomic, readwrite, strong) UILabel *rmbResultL3;
@property (nonatomic, readwrite, strong) UIView *dividerLine1;
@property (nonatomic, readwrite, strong) KeyboardView *keyboardView;

@end

@implementation CalculatorViewController

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
    [self _setupSubviewsConstraint];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    // HUD
    [self.viewModel.quoteCommand.executing subscribeNext:^(NSNumber *executing) {
        executing.boolValue?[MBProgressHUD zgc_show]:[MBProgressHUD zgc_hideHUDDelay:0.5];
    }];
    
    RAC(self.viewModel, color) = RACObserve(self.colorView, select);
    RAC(self.viewModel, clarity) = RACObserve(self.clarityView, select);
    RAC(self.viewModel, type) = [RACObserve(self.control, selectIndex) map:^id(NSNumber *x) {
        if (x.integerValue == 1) return @"BR";
        else return @"PS";
    }];
    RAC(self.dollarResultL2, text) = RACObserve(self.viewModel, dollarPrice);
    RAC(self.rmbResultL2, text) = RACObserve(self.viewModel, rmbPrice);
    RAC(self.dollarResultL3, text) = RACObserve(self.viewModel, dollarCT);
    RAC(self.rmbResultL3, text) = RACObserve(self.viewModel, rmbCT);
    RAC(self.caratTF, text) = RACObserve(self.viewModel, carat);
    RAC(self.rapPriceTF, text) = RACObserve(self.viewModel, rap);
    RAC(self.rateTF, text) = RACObserve(self.viewModel, rate);
    RAC(self.discountTF, text) = RACObserve(self.viewModel, discount);
    RAC(self.dollarPriceTF, text) = RACObserve(self.viewModel, dollarPrice);
    RAC(self.rmbPriceTF, text) = RACObserve(self.viewModel, rmbPrice);
    
    // 错误处理
    [[RACObserve(self.viewModel, error) ignore:nil] subscribeNext:^(NSError *err) {
        [MBProgressHUD zgc_hideHUD];
        [SVProgressHUD showErrorWithStatus:err.userInfo[HTTPServiceErrorDescriptionKey]];
    }];
}

- (void)_fetchInputValue:(NSString *)title {
    NSString *tempValue = @"";
    switch (self.viewModel.textType) {
        case 1:
            tempValue = self.caratTF.text;
            break;
        case 2:
            tempValue = self.rateTF.text;
            break;
        case 3:
            tempValue = self.discountTF.text;
            break;
        case 4:
            tempValue = self.dollarPriceTF.text;
            break;
        case 5:
            tempValue = self.rmbPriceTF.text;
            break;
        default:
            break;
    }
    if ([title isEqualToString:@"d"]) {
        if (tempValue.length > 0)
            tempValue = [tempValue substringToIndex:tempValue.length-1];
    } else {
        tempValue = [tempValue stringByAppendingString:title];
    }
    switch (self.viewModel.textType) {
        case 1:
            self.viewModel.carat = tempValue;
            break;
        case 2:
            self.viewModel.rate = tempValue;
            break;
        case 3:
            self.viewModel.discount = tempValue;
            break;
        case 4:
            self.viewModel.dollarPrice = tempValue;
            break;
        case 5:
            self.viewModel.rmbPrice = tempValue;
            break;
        default:
            break;
    }
}

#pragma mark - delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.rapPriceTF) return NO;
    if (textField == self.caratTF) self.viewModel.textType = 1;
    if (textField == self.rateTF) self.viewModel.textType = 2;
    if (textField == self.discountTF) self.viewModel.textType = 3;
    if (textField == self.dollarPriceTF) self.viewModel.textType = 4;
    if (textField == self.rmbPriceTF) self.viewModel.textType = 5;
    return YES;
}

#pragma mark - 创建页面
- (void)_setupSubviews {
    SelectView *colorView = [SelectView selectViewWithData:self.viewModel.colorArr isLeft:YES];
    self.colorView = colorView;
    [self.view addSubview:colorView];
    
    SelectView *clarityView = [SelectView selectViewWithData:self.viewModel.clarityArr isLeft:NO];
    self.clarityView = clarityView;
    [self.view addSubview:clarityView];
    
    SegmentViewModel *viewModel = [[SegmentViewModel alloc] init];
    viewModel.font = kFont(16);
    viewModel.color = kHexColor(@"#1C2B36");
    viewModel.tintColor = UIColor.whiteColor;
    viewModel.backColor = UIColor.whiteColor;
    viewModel.backTintColor = COLOR_MAIN;
    SegmentControl *control = [SegmentControl segmentWithItems:@[@"圆形",@"异形"]];
    [control bindViewModel:viewModel];
    self.control = control;
    [self.view addSubview:control];
    
    UILabel *clarityL = [[UILabel alloc] init];
    clarityL.font = kFont(15);
    clarityL.textColor = kHexColor(@"#1C2B36");
    clarityL.text = @"重量（Ct）";
    self.clarityL = clarityL;
    [self.view addSubview:clarityL];
    
    UIView *left1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, ZGCConvertToPx(32))];
    UITextField *caratTF = [[UITextField alloc] init];
    caratTF.backgroundColor = UIColor.whiteColor;
    caratTF.textColor = kHexColor(@"#1c2B36");
    caratTF.font = kFont(15);
    caratTF.leftView = left1;
    caratTF.leftViewMode = UITextFieldViewModeAlways;
    caratTF.delegate = self;
    caratTF.inputView = UIView.alloc.init;
    [caratTF becomeFirstResponder];
    self.caratTF = caratTF;
    [self.view addSubview:caratTF];
    
    UILabel *rapPriceL = [[UILabel alloc] init];
    rapPriceL.font = kFont(15);
    rapPriceL.textColor = kHexColor(@"#1C2B36");
    rapPriceL.text = @"国际报价";
    self.rapPriceL = rapPriceL;
    [self.view addSubview:rapPriceL];
    
    UIView *left2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, ZGCConvertToPx(32))];
    UITextField *rapPriceTF = [[UITextField alloc] init];
    rapPriceTF.backgroundColor = UIColor.whiteColor;
    rapPriceTF.textColor = kHexColor(@"#1c2B36");
    rapPriceTF.font = kFont(15);
    rapPriceTF.leftView = left2;
    rapPriceTF.leftViewMode = UITextFieldViewModeAlways;
    rapPriceTF.delegate = self;
    rapPriceTF.inputView = UIView.alloc.init;
    self.rapPriceTF = rapPriceTF;
    [self.view addSubview:rapPriceTF];
    
    UILabel *rateL = [[UILabel alloc] init];
    rateL.font = kFont(15);
    rateL.textColor = kHexColor(@"#1C2B36");
    rateL.text = @"汇率";
    self.rateL = rateL;
    [self.view addSubview:rateL];
    
    UIView *left3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, ZGCConvertToPx(32))];
    UITextField *rateTF = [[UITextField alloc] init];
    rateTF.backgroundColor = UIColor.whiteColor;
    rateTF.textColor = kHexColor(@"#1c2B36");
    rateTF.font = kFont(15);
    rateTF.leftView = left3;
    rateTF.leftViewMode = UITextFieldViewModeAlways;
    rateTF.delegate = self;
    rateTF.inputView = UIView.alloc.init;
    self.rateTF = rateTF;
    [self.view addSubview:rateTF];
    
    UILabel *discountL = [[UILabel alloc] init];
    discountL.font = kFont(15);
    discountL.textColor = kHexColor(@"#1C2B36");
    discountL.text = @"折扣(%)";
    self.discountL = discountL;
    [self.view addSubview:discountL];
    
    UIView *left4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZGCConvertToPx(27), ZGCConvertToPx(32))];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ImageNamed(@"calculator_07")];
    imageView.frame = CGRectMake(ZGCConvertToPx(6), ZGCConvertToPx(8.5), ZGCConvertToPx(15), ZGCConvertToPx(15));
    [left4 addSubview:imageView];
    UITextField *discountTF = [[UITextField alloc] init];
    discountTF.backgroundColor = UIColor.whiteColor;
    discountTF.textColor = kHexColor(@"#1c2B36");
    discountTF.font = kFont(15);
    discountTF.leftView = left4;
    discountTF.leftViewMode = UITextFieldViewModeAlways;
    discountTF.delegate = self;
    discountTF.inputView = UIView.alloc.init;
    self.discountTF = discountTF;
    [self.view addSubview:discountTF];
    
    UILabel *dollarPriceL = [[UILabel alloc] init];
    dollarPriceL.font = kFont(15);
    dollarPriceL.textColor = kHexColor(@"#1C2B36");
    dollarPriceL.text = @"美元";
    self.dollarPriceL = dollarPriceL;
    [self.view addSubview:dollarPriceL];
    
    UIView *left5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, ZGCConvertToPx(32))];
    UITextField *dollarPriceTF = [[UITextField alloc] init];
    dollarPriceTF.backgroundColor = UIColor.whiteColor;
    dollarPriceTF.textColor = kHexColor(@"#1c2B36");
    dollarPriceTF.font = kFont(15);
    dollarPriceTF.leftView = left5;
    dollarPriceTF.leftViewMode = UITextFieldViewModeAlways;
    dollarPriceTF.delegate = self;
    dollarPriceTF.inputView = UIView.alloc.init;
    self.dollarPriceTF = dollarPriceTF;
    [self.view addSubview:dollarPriceTF];
    
    UILabel *rmbPriceL = [[UILabel alloc] init];
    rmbPriceL.font = kFont(15);
    rmbPriceL.textColor = kHexColor(@"#1C2B36");
    rmbPriceL.text = @"人民币";
    self.rmbPriceL = rmbPriceL;
    [self.view addSubview:rmbPriceL];
    
    UIView *left6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, ZGCConvertToPx(32))];
    UITextField *rmbPriceTF = [[UITextField alloc] init];
    rmbPriceTF.backgroundColor = UIColor.whiteColor;
    rmbPriceTF.textColor = kHexColor(@"#1c2B36");
    rmbPriceTF.font = kFont(15);
    rmbPriceTF.leftView = left6;
    rmbPriceTF.leftViewMode = UITextFieldViewModeAlways;
    rmbPriceTF.delegate = self;
    rmbPriceTF.inputView = UIView.alloc.init;
    self.rmbPriceTF = rmbPriceTF;
    [self.view addSubview:rmbPriceTF];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.view addSubview:dividerLine];
    
    UILabel *dollarResultL1 = [[UILabel alloc] init];
    dollarResultL1.font = kFont(14);
    dollarResultL1.textColor = kHexColor(@"#1C2B36");
    dollarResultL1.text = @"美元";
    self.dollarResultL1 = dollarResultL1;
    [self.view addSubview:dollarResultL1];
    
    UILabel *dollarResultL2 = [[UILabel alloc] init];
    dollarResultL2.font = kFont(16);
    dollarResultL2.textColor = kHexColor(@"#141414");
    self.dollarResultL2 = dollarResultL2;
    [self.view addSubview:dollarResultL2];
    
    UILabel *dollarResultL3 = [[UILabel alloc] init];
    dollarResultL3.font = kFont(12);
    dollarResultL3.textColor = kHexColor(@"#4c5860");
    self.dollarResultL3 = dollarResultL3;
    [self.view addSubview:dollarResultL3];
    
    UILabel *rmbResultL1 = [[UILabel alloc] init];
    rmbResultL1.font = kFont(14);
    rmbResultL1.textColor = kHexColor(@"#1C2B36");
    rmbResultL1.text = @"人民币";
    self.rmbResultL1 = rmbResultL1;
    [self.view addSubview:rmbResultL1];
    
    UILabel *rmbResultL2 = [[UILabel alloc] init];
    rmbResultL2.font = kFont(16);
    rmbResultL2.textColor = kHexColor(@"#141414");
    self.rmbResultL2 = rmbResultL2;
    [self.view addSubview:rmbResultL2];
    
    UILabel *rmbResultL3 = [[UILabel alloc] init];
    rmbResultL3.font = kFont(12);
    rmbResultL3.textColor = kHexColor(@"#4c5860");
    self.rmbResultL3 = rmbResultL3;
    [self.view addSubview:rmbResultL3];
    
    UIView *dividerLine1 = [[UIView alloc] init];
    dividerLine1.backgroundColor = COLOR_LINE;
    self.dividerLine1 = dividerLine1;
    [self.view addSubview:dividerLine1];
    
    KeyboardView *keyboardView = [KeyboardView keyboardView];
    keyboardView.handle = ^(NSString *title) {
        [self _fetchInputValue:title];
    };
    self.keyboardView = keyboardView;
    [self.view addSubview:keyboardView];
}

- (void)_setupSubviewsConstraint {
    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kNavHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kBottomSpace);
    }];
    
    [self.clarityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.colorView.mas_right);
        make.top.mas_equalTo(self.view).offset(kNavHeight);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kBottomSpace);
        make.width.mas_equalTo(self.colorView);
    }];
    
    [self.control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(ZGCConvertToPx(5)+kNavHeight);
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.view.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(44));
        make.width.mas_equalTo(self.clarityView).multipliedBy(4.454);
    }];
    
    [self.clarityL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.control.mas_bottom).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(25));
    }];
    
    [self.caratTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.clarityL.mas_bottom);
        make.height.mas_equalTo(ZGCConvertToPx(32));
    }];
    
    [self.rapPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clarityL.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.view).offset(ZGCConvertToPx(-10));
        make.top.mas_equalTo(self.control.mas_bottom).offset(ZGCConvertToPx(10));
        make.width.height.mas_equalTo(self.clarityL);
    }];
    
    [self.rapPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.caratTF.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.view).offset(ZGCConvertToPx(-10));
        make.top.mas_equalTo(self.rapPriceL.mas_bottom);
        make.width.height.mas_equalTo(self.caratTF);
    }];
    
    [self.rateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.caratTF.mas_bottom);
        make.height.mas_equalTo(ZGCConvertToPx(25));
    }];
    
    [self.rateTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.rateL.mas_bottom);
        make.height.mas_equalTo(ZGCConvertToPx(32));
    }];
    
    [self.discountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rateL.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.view).offset(ZGCConvertToPx(-10));
        make.top.mas_equalTo(self.rapPriceTF.mas_bottom);
        make.width.height.mas_equalTo(self.rateL);
    }];
    
    [self.discountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rateTF.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.view).offset(ZGCConvertToPx(-10));
        make.top.mas_equalTo(self.discountL.mas_bottom);
        make.width.height.mas_equalTo(self.rateTF);
    }];
    
    [self.dollarPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.rateTF.mas_bottom);
        make.height.mas_equalTo(ZGCConvertToPx(25));
    }];
    
    [self.dollarPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self.dollarPriceL.mas_bottom);
        make.height.mas_equalTo(ZGCConvertToPx(32));
    }];
    
    [self.rmbPriceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dollarPriceL.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.view).offset(ZGCConvertToPx(-10));
        make.top.mas_equalTo(self.discountTF.mas_bottom);
        make.width.height.mas_equalTo(self.dollarPriceL);
    }];
    
    [self.rmbPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dollarPriceTF.mas_right).offset(ZGCConvertToPx(20));
        make.top.mas_equalTo(self.rmbPriceL.mas_bottom);
        make.right.mas_equalTo(self.view).offset(ZGCConvertToPx(-10));
        make.width.height.mas_equalTo(self.dollarPriceTF);
    }];

    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dollarPriceTF.mas_bottom).offset(ZGCConvertToPx(10));
        make.left.mas_equalTo(self.clarityView.mas_right);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];

    [self.dollarResultL1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dividerLine.mas_bottom);
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(30));
    }];
    
    [self.dollarResultL2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dollarResultL1.mas_bottom);
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(20));
    }];
    
    [self.dollarResultL3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dollarResultL2.mas_bottom);
        make.left.mas_equalTo(self.clarityView.mas_right).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(20));
    }];
    
    [self.rmbResultL1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dividerLine.mas_bottom);
        make.left.mas_equalTo(self.dollarResultL1.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.view).offset(ZGCConvertToPx(-10));
        make.width.height.mas_equalTo(self.dollarResultL1);
    }];
    
    [self.rmbResultL2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rmbResultL1.mas_bottom);
        make.left.mas_equalTo(self.dollarResultL2.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.view).offset(ZGCConvertToPx(-10));
        make.width.height.mas_equalTo(self.dollarResultL2);
    }];
    
    [self.rmbResultL3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rmbResultL2.mas_bottom);
        make.left.mas_equalTo(self.dollarResultL3.mas_right).offset(ZGCConvertToPx(20));
        make.right.mas_equalTo(self.view).offset(ZGCConvertToPx(-10));
        make.width.height.mas_equalTo(self.dollarResultL3);
    }];
    
    [self.dividerLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dollarResultL3.mas_bottom).offset(ZGCConvertToPx(3));
        make.left.mas_equalTo(self.clarityView.mas_right);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    [self.keyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-kBottomSpace);
        make.right.mas_equalTo(self.view.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(174)+1);
        make.width.mas_equalTo(ZGCConvertToPx(224)+1.5);
    }];
}

@end
