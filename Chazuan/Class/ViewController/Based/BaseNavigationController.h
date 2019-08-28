//
//  BaseNavigationController.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "YPNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavigationController : YPNavigationController

@property (nonatomic, readwrite, assign) NSInteger index; ///< tabItem下标

@end

NS_ASSUME_NONNULL_END
