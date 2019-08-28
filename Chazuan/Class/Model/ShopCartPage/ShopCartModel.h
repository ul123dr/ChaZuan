//
//  ShopCartModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/19.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"
#import "ShopCartList.h"
#import "Page.h"
#import "ObjectT.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopCartModel : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, strong) ObjectT *objectT;
@property (nonatomic, readwrite, strong) Page *page;

@end

NS_ASSUME_NONNULL_END
