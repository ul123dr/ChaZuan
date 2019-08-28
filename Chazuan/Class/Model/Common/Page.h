//
//  Page.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Page : MHObject

@property (nonatomic, readwrite, assign) NSInteger currentPage;
@property (nonatomic, readwrite, assign) NSInteger pageSize;
@property (nonatomic, readwrite, assign) NSInteger totalPage;
@property (nonatomic, readwrite, assign) NSInteger totalRecord;

@end

NS_ASSUME_NONNULL_END
