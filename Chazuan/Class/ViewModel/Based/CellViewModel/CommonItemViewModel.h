//
//  CommonItemViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonItemViewModel : NSObject

@property (nonatomic, readwrite, copy) NSString *icon;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, strong) UIColor *titleColor;
@property (nonatomic, readwrite, copy) NSString *subTitle;
@property (nonatomic, readwrite, strong) UIColor *subColor;

@property (nonatomic, readwrite, assign) CGFloat rowHeight;
@property (nonatomic, readwrite, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, readwrite, assign) UITableViewCellStyle cellStyle;
@property (nonatomic, readwrite, assign) BOOL shouldHideRedDot;
@property (nonatomic, readwrite, copy) NSString *badgeValue;
@property (nonatomic, readwrite, assign) BOOL shouldHideDisclosureIndicator; ///< 是否隐藏更多, 默认隐藏
@property (nonatomic, readwrite, assign) BOOL shouldHideDividerLine; // 是否隐藏分隔线，默认不隐藏

@property (nonatomic, readwrite, assign) Class destViewModelClass;
@property (nonatomic, readwrite, copy) VoidBlock operation;

@property (nonatomic, readwrite, strong) Class tableViewCellClass; ///< 简单工厂绑定方法，直接使用该类创建cell，省去引入

/// init title or icon
+ (instancetype)itemViewModelWithTitle:(NSString *)title icon:(nullable NSString *)icon;
/// init title
+ (instancetype)itemViewModelWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
