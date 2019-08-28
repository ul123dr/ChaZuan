//
//  StyleInputCell.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleInputCell.h"

@interface StyleInputCell ()<UITextViewDelegate>

@property (nonatomic, readwrite, strong) StyleTextItemViewModel *viewModel;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) IQTextView *textView;

@end

@implementation StyleInputCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"StyleInputCell";
    StyleInputCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(StyleTextItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    RAC(self.titleLabel, text) = [RACObserve(viewModel, title) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.textView, placeholder) = [RACObserve(viewModel, placeholder) takeUntil:self.rac_prepareForReuseSignal];
//    RAC(viewModel, name) = [[RACSignal merge:@[self.textView.rac_textSignal, RACObserve(self.textView, text)]] takeUntil:self.rac_prepareForReuseSignal];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.viewModel.name = textView.text;
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
- (void)_setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kHexColor(@"#020D2C");
    titleLabel.font = kFont(13);
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    IQTextView *textView = [[IQTextView alloc] init];
    textView.contentInset = UIEdgeInsetsMake(ZGCConvertToPx(5), ZGCConvertToPx(10), ZGCConvertToPx(10), ZGCConvertToPx(5));
    textView.font = kFont(13);
    textView.layer.cornerRadius = 4;
    textView.layer.borderColor = kHexColor(@"#dfe3ef").CGColor;
    textView.layer.borderWidth = 1;
    textView.delegate = self;
    self.textView = textView;
    [self.contentView addSubview:textView];
}

- (void)_setupSubviewsConstraint {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(ZGCConvertToPx(13));
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-10));
        make.height.mas_equalTo(ZGCConvertToPx(33));
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(ZGCConvertToPx(10));
        make.right.mas_equalTo(self.contentView.mas_right).offset(ZGCConvertToPx(-45));
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(ZGCConvertToPx(-2));
    }];
}

@end
