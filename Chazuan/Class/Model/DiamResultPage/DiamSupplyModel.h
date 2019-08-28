//
//  DiamSupplyModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/8.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"
#import "Page.h"
#import "ObjectT.h"
#import "DiamSupplyList.h"

NS_ASSUME_NONNULL_BEGIN

@interface DiamSupplyModel : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, strong) ObjectT *objectT;
@property (nonatomic, readwrite, strong) Page *page;

@end

NS_ASSUME_NONNULL_END
