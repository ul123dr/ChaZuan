//
//  StyleOneHeaderView.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleOneHeaderView.h"

@interface StyleOneHeaderView ()

@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UITextField *textField;

@end

@implementation StyleOneHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setupSubview];
        [self _setupConstraint];
        [self bind];
    }
    return self;
}

- (void)bind {
    RAC(self.titleLabel, text) = RACObserve(self, title);
}

- (void)_setupSubview {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kHexColor(@"#1C2B36");
    titleLabel.font = kBoldFont(15);
    self.titleLabel = titleLabel;
    [self addSubview:self.titleLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.layer.borderColor = kHexColor(@"#EDF1F2").CGColor;
    textField.layer.borderWidth = 1;
    textField.layer.cornerRadius = 2;
    textField.font = kFont(12);
    textField.textColor = kHexColor(@"#333333");
    self.textField = textField;
    [self addSubview:textField];
    [textField setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingLeft"];
    [textField setValue:[NSNumber numberWithInt:ZGCConvertToPx(10)] forKey:@"paddingRight"];
}

- (void)_setupConstraint {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, ZGCConvertToPx(10), ZGCConvertToPx(32), ZGCConvertToPx(10)));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(ZGCConvertToPx(39), ZGCConvertToPx(10), 0, ZGCConvertToPx(10)));
    }];
}

@end
