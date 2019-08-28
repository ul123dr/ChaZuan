//
//  StyleTwoHeaderView.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleTwoHeaderView.h"

@interface StyleTwoHeaderView ()

@property (nonatomic, readwrite, strong) UILabel *title1Label;
@property (nonatomic, readwrite, strong) UITextField *textField1;
@property (nonatomic, readwrite, strong) UILabel *title2Label;
@property (nonatomic, readwrite, strong) UITextField *textField2;
@property (nonatomic, readwrite, strong) UILabel *title3Label;
@property (nonatomic, readwrite, strong) UITextField *textField3;
@property (nonatomic, readwrite, strong) UILabel *sepLabel;
@property (nonatomic, readwrite, strong) UITextField *textField4;
@property (nonatomic, readwrite, strong) ZGButton *priceBtn;

@end

@implementation StyleTwoHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setupSubview];
        [self _setupConstraint];
        [self bind];
    }
    return self;
}

- (void)bind {
    RAC(self.title1Label, text) = RACObserve(self, title1);
    RAC(self.title2Label, text) = RACObserve(self, title2);
    RAC(self.title3Label, text) = RACObserve(self, title3);
}

- (void)_setupSubview {
    UILabel *title1Label = [[UILabel alloc] init];
    title1Label.textColor = kHexColor(@"#1C2B36");
    title1Label.font = kBoldFont(15);
    self.title1Label = title1Label;
    [self addSubview:title1Label];
    
    UITextField *textField1 = [[UITextField alloc] init];
    textField1.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    textField1.layer.borderWidth = 1;
    textField1.layer.cornerRadius = 2;
    textField1.font = kFont(12);
    textField1.textColor = kHexColor(@"#333333");
    self.textField1 = textField1;
    [self addSubview:textField1];
    [textField1 setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingLeft"];
    [textField1 setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingRight"];
    
    UILabel *title2Label = [[UILabel alloc] init];
    title2Label.textColor = kHexColor(@"#1C2B36");
    title2Label.font = kBoldFont(15);
    self.title2Label = title2Label;
    [self addSubview:title2Label];
    
    UITextField *textField2 = [[UITextField alloc] init];
    textField2.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    textField2.layer.borderWidth = 1;
    textField2.layer.cornerRadius = 2;
    textField2.font = kFont(12);
    textField2.textColor = kHexColor(@"#333333");
    self.textField2 = textField2;
    [self addSubview:textField2];
    [textField2 setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingLeft"];
    [textField2 setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingRight"];
    
    UILabel *title3Label = [[UILabel alloc] init];
    title3Label.textColor = kHexColor(@"#1C2B36");
    title3Label.font = kBoldFont(15);
    self.title3Label = title3Label;
    [self addSubview:title3Label];
    
    UITextField *textField3 = [[UITextField alloc] init];
    textField3.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    textField3.layer.borderWidth = 1;
    textField3.layer.cornerRadius = 2;
    textField3.font = kFont(12);
    textField3.textColor = kHexColor(@"#333333");
    self.textField3 = textField3;
    [self addSubview:textField3];
    [textField3 setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingLeft"];
    [textField3 setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingRight"];
    
    UILabel *sepLabel = [[UILabel alloc] init];
    sepLabel.textColor = kHexColor(@"#1C2B36");
    sepLabel.font = kBoldFont(15);
    sepLabel.text = @"~";
    sepLabel.textAlignment = NSTextAlignmentCenter;
    self.sepLabel = sepLabel;
    [self addSubview:sepLabel];
    
    UITextField *textField4 = [[UITextField alloc] init];
    textField4.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    textField4.layer.borderWidth = 1;
    textField4.layer.cornerRadius = 2;
    textField4.font = kFont(12);
    textField4.textColor = kHexColor(@"#333333");
    self.textField4 = textField4;
    [self addSubview:textField4];
    [textField4 setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingLeft"];
    [textField4 setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingRight"];

    ZGButton *priceBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    priceBtn.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    priceBtn.layer.borderWidth = 1;
    priceBtn.layer.cornerRadius = 2;
    [priceBtn.titleLabel setFont:kFont(12)];
    [priceBtn setTitleColor:kHexColor(@"#333333") forState:UIControlStateNormal];
    [priceBtn setTitle:@"价格段" forState:UIControlStateNormal];
    self.priceBtn = priceBtn;
    [self addSubview:priceBtn];
}

- (void)_setupConstraint {
    [self.title1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(39);
    }];
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title1Label.mas_bottom);
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(32));
    }];
    [self.title2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField1.mas_bottom);
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(39);
    }];
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title2Label.mas_bottom);
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(32));
    }];
    [self.title3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField2.mas_bottom);
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(39);
    }];
    [self.textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title3Label.mas_bottom);
        make.left.mas_equalTo(self).offset(ZGCConvertToPx(10));
        make.height.mas_equalTo(ZGCConvertToPx(32));
    }];
    [self.sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title3Label.mas_bottom);
        make.left.mas_equalTo(self.textField3.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(32));
        make.width.mas_equalTo(ZGCConvertToPx(20));
    }];
    [self.textField4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title3Label.mas_bottom);
        make.left.mas_equalTo(self.sepLabel.mas_right);
        make.height.mas_equalTo(ZGCConvertToPx(32));
        make.width.mas_equalTo(self.textField3);
    }];
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title3Label.mas_bottom);
        make.left.mas_equalTo(self.textField4.mas_right).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.mas_right).offset(ZGCConvertToPx(-10));
        make.width.mas_equalTo(self.textField3).multipliedBy(1.3);
        make.height.mas_equalTo(ZGCConvertToPx(32));
    }];
}

@end
