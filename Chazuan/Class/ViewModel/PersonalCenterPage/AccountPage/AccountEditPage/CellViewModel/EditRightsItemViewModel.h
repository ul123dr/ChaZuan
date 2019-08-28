//
//  EditRightsItemViewModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonItemViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditRightsItemViewModel : CommonItemViewModel

@property (nonatomic, readwrite, assign) BOOL shouldEdited;
@property (nonatomic, readwrite, assign) BOOL area;
@property (nonatomic, readwrite, assign) BOOL cert;
@property (nonatomic, readwrite, assign) BOOL detail;
@property (nonatomic, readwrite, assign) BOOL rap;
@property (nonatomic, readwrite, assign) BOOL rapBuy;
@property (nonatomic, readwrite, assign) BOOL disc;
@property (nonatomic, readwrite, assign) BOOL mbg;
@property (nonatomic, readwrite, assign) BOOL black;
@property (nonatomic, readwrite, assign) BOOL fancyRap;
@property (nonatomic, readwrite, assign) BOOL img;
@property (nonatomic, readwrite, assign) BOOL dollar;
@property (nonatomic, readwrite, assign) BOOL realGoodsNumber;
@property (nonatomic, readwrite, assign) BOOL size;
@property (nonatomic, readwrite, assign) BOOL isEyeClean;
@property (nonatomic, readwrite, assign) BOOL isDT;

@end

NS_ASSUME_NONNULL_END
