//
//  SwitchView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwitchView : UIView

+ (instancetype)switchView;

@property (nonatomic, readwrite, copy) NSString *leftTitle;
@property (nonatomic, readwrite, copy) NSString *rightTitle;
@property (nonatomic, readonly, assign) NSInteger switchType;

@end

NS_ASSUME_NONNULL_END
