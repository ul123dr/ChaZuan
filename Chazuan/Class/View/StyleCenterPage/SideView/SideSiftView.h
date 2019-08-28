//
//  SideSiftView.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SideSiftView : UIView<BindProtocol>

- (instancetype)initWithFrame:(CGRect)frame type:(StyleType)type;

- (void)reloadData;

- (void)show;

- (void)dismiss;

@property (nonatomic, readwrite, copy) VoidBlock_id callback;

@end

NS_ASSUME_NONNULL_END
