//
//  SearchModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/5/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"
#import "SearchLog.h"
#import "Page.h"
#import "ObjectT.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchModel : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSArray *list;
@property (nonatomic, readwrite, strong) ObjectT *objectT;
@property (nonatomic, readwrite, strong) Page *page;

@end

NS_ASSUME_NONNULL_END
