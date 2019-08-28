//
//  UIScrollView+Refresh.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Refresh)

/// 添加下拉刷新控件
- (MJRefreshNormalHeader *)addHeaderRefresh:(void(^)(MJRefreshNormalHeader *header))refreshingBlock;
/// 添加上拉加载控件
- (MJRefreshAutoNormalFooter *)addFooterRefresh:(void(^)(MJRefreshAutoNormalFooter *footer))refreshingBlock;


@end

NS_ASSUME_NONNULL_END
