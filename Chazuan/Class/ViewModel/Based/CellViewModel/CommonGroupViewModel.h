//
//  CommonGroupViewModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonGroupViewModel : NSObject

@property (nonatomic, copy) NSString *header;
@property (nonatomic, readwrite, assign) CGFloat headerHeight;
@property (nonatomic, readwrite, strong) UIColor *headerBackColor;
@property (nonatomic, readwrite, assign) BOOL hideDividerLine;

@property (nonatomic, copy) NSString *footer;
@property (nonatomic, readwrite, assign) CGFloat footerHeight;
@property (nonatomic, readwrite, strong) UIColor *footerBackColor;

@property (nonatomic, strong) NSArray *itemViewModels;

+ (instancetype)groupViewModel;

@end

NS_ASSUME_NONNULL_END
