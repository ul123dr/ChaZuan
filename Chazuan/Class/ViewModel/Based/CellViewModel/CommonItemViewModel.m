//
//  CommonItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"
#import "TableViewCell.h"

@implementation CommonItemViewModel

+ (instancetype)itemViewModelWithTitle:(NSString *)title icon:(NSString *)icon {
    CommonItemViewModel *item = [[self alloc] init];
    item.title = title;
    item.icon = icon;
    return item;
}

+ (instancetype)itemViewModelWithTitle:(NSString *)title {
    return [self itemViewModelWithTitle:title icon:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _shouldHideRedDot = YES;
        _selectionStyle = UITableViewCellSelectionStyleNone;
        _rowHeight = ZGCConvertToPx(44);
        _tableViewCellClass = TableViewCell.class;
        _shouldHideDisclosureIndicator = YES;
    }
    return self;
}

@end
