//
//  ShopCartBottomView.m
//  chazuan
//
//  Created by BecksZ on 2019/4/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ShopCartBottomView.h"

@interface ShopCartBottomView ()

@property (nonatomic, readwrite, strong) ShopCartViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *priceL;
@property (nonatomic, readwrite, strong) ZGButton *deleteBtn;
@property (nonatomic, readwrite, strong) ZGButton *balanceBtn;

@end

@implementation ShopCartBottomView

+ (instancetype)cartButtonView {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
        [self _setupSubviews];
        [self _setupSubviewsConstraint];
    }
    return self;
}

#pragma mark - Public Method
- (void)bindViewModel:(ShopCartViewModel *)viewModel {
    _viewModel = viewModel;
    
    @weakify(self);
    [RACObserve(viewModel, balanceTuple) subscribeNext:^(RACTuple *x) {
        @strongify(self);
        self.priceL.hidden = ![x.second boolValue];
        if ([x.second boolValue]) {
            NSString *price = [NSString stringWithFormat:@"%.2f", [x.first floatValue]];
            NSString *notice = [NSString stringWithFormat:@" 选中 %@ 条\n合计 %@ 元", x.second, price];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            [paragraphStyle setLineSpacing:5];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:notice];
            [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, notice.length)];
            [attrStr addAttribute:NSFontAttributeName value:kFont(11) range:NSMakeRange(0, notice.length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#1C2B36") range:NSMakeRange(0, notice.length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#F85359") range:NSMakeRange(4, [x.second stringValue].length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#F85359") range:NSMakeRange(notice.length-2-price.length, price.length)];
            self.priceL.attributedText = attrStr;
            
            [self.priceL layoutIfNeeded];
        }
    }];
}

#pragma mark - 创建页面
- (void)_setup {
    self.backgroundColor = kHexColor(@"#EDF1F2");
    self.layer.shadowColor = kHexColor(@"#C0C0C0").CGColor;
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius = 3;
    self.layer.shadowOffset = CGSizeMake(0, -3);
}

- (void)_setupSubviews {
    UILabel *priceL = [[UILabel alloc] init];
    priceL.numberOfLines = 0;
    priceL.adjustsFontSizeToFitWidth = YES;
    self.priceL = priceL;
    [self addSubview:priceL];
    
    ZGButton *deleteBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn.titleLabel setFont:kFont(16)];
    [deleteBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:UIColor.whiteColor];
    self.deleteBtn = deleteBtn;
    [self addSubview:deleteBtn];
    
    ZGButton *balanceBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    [balanceBtn.titleLabel setFont:kFont(16)];
    [balanceBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [balanceBtn setTitle:@"确认下单" forState:UIControlStateNormal];
    [balanceBtn setBackgroundColor:COLOR_MAIN];
    self.balanceBtn = balanceBtn;
    [self addSubview:balanceBtn];
    
    @weakify(self);
    [[deleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (self.viewModel.dataSource.count == 0) return;
        if (kObjectIsNotNil(self.viewModel.balanceTuple.second) && [self.viewModel.balanceTuple.second boolValue])
            [self.viewModel.deleteCommand execute:nil];
        else
            [SVProgressHUD showInfoWithStatus:@"请先选择要删除的货品"];
    }];
    
    [[balanceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
        @strongify(self);
        if (self.viewModel.dataSource.count == 0) return;
        
        for (CartItemViewModel *viewModel in self.viewModel.dataSource) {
            if (viewModel.selected && viewModel.status != 101) {
                [SVProgressHUD showInfoWithStatus:@"不可售货品不能下单！"];
                return;
            }
        }
        
        if (kObjectIsNotNil(self.viewModel.balanceTuple.second) && [self.viewModel.balanceTuple.second boolValue])
            [self.viewModel.balanceCommand execute:nil];
        else
            [SVProgressHUD showInfoWithStatus:@"请先选择要下单的货品"];
    }];
}

- (void)_setupSubviewsConstraint {
    [self.priceL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).offset(ZGCConvertToPx(5));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kBottomSpace-ZGCConvertToPx(5));
        make.width.mas_equalTo(ZGCConvertToPx(105));
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceL.mas_right).offset(ZGCConvertToPx(5));
        make.top.mas_equalTo(self).offset(ZGCConvertToPx(3));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kBottomSpace-ZGCConvertToPx(3));
    }];
    
    [self.balanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deleteBtn.mas_right).offset(ZGCConvertToPx(10));
        make.top.mas_equalTo(self).offset(ZGCConvertToPx(3));
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kBottomSpace-ZGCConvertToPx(3));
        make.right.mas_equalTo(self.mas_right).offset(ZGCConvertToPx(-10));
        make.width.mas_equalTo(self.deleteBtn);
    }];
}

@end
