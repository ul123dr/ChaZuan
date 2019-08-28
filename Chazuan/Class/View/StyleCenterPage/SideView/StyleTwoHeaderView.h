//
//  StyleTwoHeaderView.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StyleTwoHeaderView : UICollectionReusableView

@property (nonatomic, readwrite, copy) NSString *title1;
@property (nonatomic, readwrite, copy) NSString *title2;
@property (nonatomic, readwrite, copy) NSString *title3;
@property (nonatomic, readwrite, copy) NSString *priceMin;
@property (nonatomic, readwrite, copy) NSString *priceMax;

@property (nonatomic, readonly, strong) UITextField *textField1;
@property (nonatomic, readonly, strong) UITextField *textField2;
@property (nonatomic, readonly, strong) UITextField *textField3;
@property (nonatomic, readonly, strong) UITextField *textField4;
@property (nonatomic, readonly, strong) ZGButton *priceBtn;

@end

NS_ASSUME_NONNULL_END
