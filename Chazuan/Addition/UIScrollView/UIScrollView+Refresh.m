//
//  UIScrollView+Refresh.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Refresh)

- (MJRefreshNormalHeader *)addHeaderRefresh:(void(^)(MJRefreshNormalHeader *header))refreshingBlock {
    __weak __typeof(&*self) weakSelf = self;
    MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __weak __typeof(&*weakSelf) strongSelf = weakSelf;
        !refreshingBlock?:refreshingBlock((MJRefreshNormalHeader *)strongSelf.mj_header);
    }];
    mj_header.lastUpdatedTimeLabel.hidden = YES;
    // Configure normal mj_header
    self.mj_header = mj_header;
    return mj_header;
}

/// 添加上拉加载控件
- (MJRefreshAutoNormalFooter *)addFooterRefresh:(void(^)(MJRefreshAutoNormalFooter *footer))refreshingBlock {
    __weak __typeof(&*self) weakSelf = self;
    MJRefreshAutoNormalFooter *mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        __weak __typeof(&*weakSelf) strongSelf = weakSelf;
        !refreshingBlock?:refreshingBlock((MJRefreshAutoNormalFooter *)strongSelf.mj_footer);
    }];
    // Configure normal mj_footer
    [mj_footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
    [mj_footer setTitle:@"松开加载更多数据" forState:MJRefreshStatePulling];
    [mj_footer setTitle:@"数据正在加载..." forState:MJRefreshStateRefreshing];
    [mj_footer setTitle:@"已经到底了,不可以再拉了哦^_^" forState:MJRefreshStateNoMoreData];
    self.mj_footer = mj_footer;
    return mj_footer;
}


@end
