//
//  SearchView.h
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchView : UIView<BindProtocol>

+ (instancetype)searchView;

@property (nonatomic, readonly, strong) ZGButton *selectBtn;

@end

NS_ASSUME_NONNULL_END
