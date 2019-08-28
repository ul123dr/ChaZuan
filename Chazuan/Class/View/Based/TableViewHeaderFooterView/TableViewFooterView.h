//
//  TableViewFooterView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGroupViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewFooterView : UITableViewHeaderFooterView<BindProtocol>
/// 创建方法
+ (instancetype)footerWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
