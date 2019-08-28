//
//  StyleOneHeaderView.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StyleOneHeaderView : UICollectionReusableView

@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readonly, strong) UITextField *textField;

@end

NS_ASSUME_NONNULL_END
