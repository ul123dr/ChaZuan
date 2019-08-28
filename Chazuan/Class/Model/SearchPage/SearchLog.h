//
//  SearchLog.h
//  Chazuan
//
//  Created by BecksZ on 2019/5/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchLog : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, copy) NSString *content;
@property (nonatomic, readwrite, strong) NSNumber *logId;
@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, copy) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
