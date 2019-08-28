//
//  CalculatorModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/28.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorModel : MHObject

@property (nonatomic, readwrite, strong) NSNumber *calculatorId;
@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, copy) NSString *clarity;
@property (nonatomic, readwrite, copy) NSString *color;
@property (nonatomic, readwrite, copy) NSString *shape;
@property (nonatomic, readwrite, copy) NSString *createDate;
@property (nonatomic, readwrite, strong) NSNumber *price;
@property (nonatomic, readwrite, strong) NSNumber *maxSize;
@property (nonatomic, readwrite, strong) NSNumber *minSize;

@end

NS_ASSUME_NONNULL_END
