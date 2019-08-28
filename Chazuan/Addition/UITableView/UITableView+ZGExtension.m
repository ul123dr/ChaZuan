//
//  UITableView+ZGExtension.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "UITableView+ZGExtension.h"

@implementation UITableView (ZGExtension)

/* 根据名称注册 cell */
- (void)zgc_registerCell:(Class)cls {
    [self zgc_registerCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
/* 获取 cell */
- (void)zgc_registerCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier {
    [self registerClass:cls forCellReuseIdentifier:reuseIdentifier];
}

/* 根据名称注册 nib 类型 cell */
- (void)zgc_registerNibCell:(Class)cls {
    [self zgc_registerNibCell:cls forCellReuseIdentifier:NSStringFromClass(cls)];
}
/* 获取一个 nib 类型 cell */
- (void)zgc_registerNibCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(cls) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (void)adaptateIos11 {
    if (@available(iOS 11.0, *)) {
        ZGCAdjustsScrollViewInsets_Never(self);
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.scrollIndicatorInsets = self.contentInset;
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
