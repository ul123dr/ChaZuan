//
//  UITableView+ZGExtension.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UITableView (ZGExtension)

/// 根据名称注册 cell
///
/// @param cls cell 名称
- (void)zgc_registerCell:(Class)cls;
/// 根据名称注册 nib 类型 cell
///
/// @param cls cell 名称
- (void)zgc_registerNibCell:(Class)cls;

/// 注册指定 Identifier 的cell
///
/// @param cls cell 名称
/// @param reuseIdentifier reuseIdentifier
- (void)zgc_registerCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier;
/// 注册指定 Identifier 的 nib 类型 cell
///
/// @param cls cell 名称
/// @param reuseIdentifier reuseIdentifier
- (void)zgc_registerNibCell:(Class)cls forCellReuseIdentifier:(NSString *)reuseIdentifier;

/// iOS11 适配
- (void)adaptateIos11;


@end

NS_ASSUME_NONNULL_END
