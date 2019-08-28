//
//  MainFuncCell.m
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MainFuncCell.h"
#import "UpDownButton.h"

@interface MainFuncCell ()

@property (nonatomic, readwrite, strong) MainItemViewModel *viewModel;

@property (nonatomic, readwrite, strong) NSMutableArray *btnArr;

@end

@implementation MainFuncCell

#pragma mark - Public Method
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"MainFuncCell";
    MainFuncCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];;
    return cell;
}

- (void)bindViewModel:(MainItemViewModel *)viewModel {
    self.viewModel = viewModel;
    
    for (int i = 0; i < self.btnArr.count; i++) {
        UpDownButton *btn = self.btnArr[i];
        if (i < viewModel.icons.count) {
            btn.hidden = NO;
            [btn setImage:viewModel.icons[i] title:viewModel.names[i]];
        } else {
            btn.hidden = YES;
        }
    }
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
    self.btnArr = [NSMutableArray array];
}

- (void)_setupSubviews {
    for (int i = 0; i < 3; i++) {
        UpDownButton *btn = [UpDownButton buttonWithType:UIButtonTypeCustom];
        [btn setShowBorder:YES];
        [self.btnArr addObject:btn];
        [self.contentView addSubview:btn];
        
        @weakify(self);
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(ZGButton *sender) {
            @strongify(self);
            if (i < self.viewModel.destViewModelClasses.count) {
                if ([self.viewModel.needLogins[i] boolValue] && ![SingleInstance boolForKey:ZGCIsLoginKey])
                    [self.viewModel.funcClickSub sendNext:[RACTuple tupleWithObjects:self.viewModel.destViewModelClass, @"登录", nil]];
                else
                    [self.viewModel.funcClickSub sendNext:[RACTuple tupleWithObjects:self.viewModel.destViewModelClasses[i], self.viewModel.names[i], nil]];
            }
        }];
    }
}

- (void)_setupSubviewsConstraint {
    UpDownButton *tempBtn;
    for (int i = 0; i < self.btnArr.count; i++) {
        UpDownButton *btn = self.btnArr[i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.contentView);
            if (i == self.btnArr.count - 1) make.right.mas_equalTo(self.contentView);
            if (tempBtn) {
                make.left.mas_equalTo(tempBtn.mas_right);
                make.width.mas_equalTo(tempBtn);
            } else {
                make.left.mas_equalTo(self.contentView);
            }
        }];
        tempBtn = btn;
    }
}

@end
