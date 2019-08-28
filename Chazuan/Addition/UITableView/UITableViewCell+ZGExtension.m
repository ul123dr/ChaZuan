//
//  UITableViewCell+ZGExtension.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "UITableViewCell+ZGExtension.h"

@implementation UITableViewCell (ZGExtension)

/* 获取cell方法，子类覆盖 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return [self cellWithTableView:tableView style:UITableViewCellStyleDefault];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    static NSString *ID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:style reuseIdentifier:ID];
    }
    return cell;
}

- (void)bindViewModel:(id)viewModel {
    
}


@end
