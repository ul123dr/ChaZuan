//
//  CertInfoCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertInfoCell.h"

@interface CertInfoCell ()

// viewModel
@property (nonatomic, readwrite, strong) CertInfoItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleL;
@property (nonatomic, readwrite, strong) UILabel *valueL;
@property (nonatomic, readwrite, strong) ZGButton *pdfBtn;
@property (nonatomic, readwrite, strong) UIImageView *dividerLine;

@end

@implementation CertInfoCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"CertInfoCell";
    CertInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(CertInfoItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    RAC(self.titleL, text) = [RACObserve(viewModel, name) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.valueL, text) = [RACObserve(viewModel, valueName) takeUntil:self.rac_prepareForReuseSignal];
    @weakify(self);
    [[RACObserve(viewModel, showPdf) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(NSNumber *show) {
        @strongify(self);
        self.pdfBtn.hidden = !show.boolValue;
        [self.contentView layoutIfNeeded];
    }];
    self.pdfBtn.rac_command = viewModel.pdfCommand;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 辅助方法
- (void)_setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)_setupSubviews {
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = kBoldFont(16);
    titleL.textColor = kHexColor(@"#1C2B36");
    self.titleL = titleL;
    [self.contentView addSubview:titleL];
    
    UILabel *valueL = [[UILabel alloc] init];
    valueL.font = kFont(13);
    valueL.textColor = kHexColor(@"#4C5860");
    self.valueL = valueL;
    [self.contentView addSubview:valueL];
    
    ZGButton *pdfBtn = [ZGButton buttonWithType:UIButtonTypeCustom];
    pdfBtn.backgroundColor = kHexColor(@"#3882FF");
    [pdfBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [pdfBtn setTitle:@"预览" forState:UIControlStateNormal];
    [pdfBtn.titleLabel setFont:kFont(15)];
    pdfBtn.layer.cornerRadius = 4;
    pdfBtn.hidden = YES;
    self.pdfBtn = pdfBtn;
    [self.contentView addSubview:pdfBtn];
    
    UIImageView *dividerLine = [[UIImageView alloc] init];
    dividerLine.backgroundColor = COLOR_LINE;
    self.dividerLine = dividerLine;
    [self.contentView addSubview:dividerLine];
}

- (void)_setupSubviewsConstraint {
    [self.titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(15));
        make.top.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.valueL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.titleL.mas_right);
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.width.mas_equalTo(self.titleL).multipliedBy(2);
    }];
    
    [self.pdfBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(5));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-15));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-5));
        make.width.mas_equalTo(ZGCConvertToPx(50));
    }];
    
    [self.dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

@end
