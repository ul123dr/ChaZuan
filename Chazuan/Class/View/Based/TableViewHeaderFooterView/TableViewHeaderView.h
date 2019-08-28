//
//  TableViewHeaderView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonGroupViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TableViewHeaderView : UITableViewHeaderFooterView<BindProtocol>

+ (instancetype)headerWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
