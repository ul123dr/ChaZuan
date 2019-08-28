//
//  UITableViewCell+ZGExtension.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@protocol CellBindProtocol <NSObject>

/// 创建 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/// 创建 style 类型的 cell
+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style;

/// 绑定viewModel
- (void)bindViewModel:(id)viewModel;

@end


@interface UITableViewCell (ZGExtension)<CellBindProtocol>

@end

NS_ASSUME_NONNULL_END
