//
//  BaseTableViewController.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly, weak) UITableView *tableView; ///< TableView

- (void)reloadData;

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

@end

NS_ASSUME_NONNULL_END
