//
//  OrderItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderItemViewModel : CommonItemViewModel

//@property (nonatomic, readwrite, strong) NSNumber *orderId;
@property (nonatomic, readwrite, copy) NSString *img;
@property (nonatomic, readwrite, copy) NSNumber *price;
@property (nonatomic, readwrite, copy) NSString *temp1;
@property (nonatomic, readwrite, copy) NSString *temp2;
@property (nonatomic, readwrite, copy) NSString *temp3;
@property (nonatomic, readwrite, copy) NSString *temp4;
@property (nonatomic, readwrite, copy) NSString *temp5;
@property (nonatomic, readwrite, copy) NSString *temp6;
@property (nonatomic, readwrite, copy) NSString *temp7;
@property (nonatomic, readwrite, copy) NSString *temp8;
@property (nonatomic, readwrite, copy) NSString *temp9;

@property (nonatomic, readwrite, copy) VoidBlock_int selectOperation;

@end

NS_ASSUME_NONNULL_END
