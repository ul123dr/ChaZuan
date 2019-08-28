//
//  NavigationControllerStack.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewModelServices;

NS_ASSUME_NONNULL_BEGIN

@interface NavigationControllerStack : NSObject

- (instancetype)initWithServices:(id<ViewModelServices>)services;
- (void)pushNavigationController:(UINavigationController *)navigationController;
- (UINavigationController *)popNavigationController;
- (UINavigationController *)topNavigationController;
- (BOOL)containtViewModel:(Class)viewModelClass;

@end

NS_ASSUME_NONNULL_END
