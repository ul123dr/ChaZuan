//
//  StyleAddModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface StyleSelectModel : MHObject

@property (nonatomic, readwrite, copy) NSString *sizeMin;
@property (nonatomic, readwrite, copy) NSString *sizeMax;
@property (nonatomic, readwrite, copy) NSString *hand;

@end

@interface StyleAddModel : MHObject

@property (nonatomic, readwrite, copy) NSString *tabs;
@property (nonatomic, readwrite, copy) NSString *size;
@property (nonatomic, readwrite, copy) NSString *handsize;
@property (nonatomic, readwrite, copy) NSString *mRemark;
@property (nonatomic, readwrite, copy) NSString *write;
@property (nonatomic, readwrite, copy) NSString *date;
@property (nonatomic, readwrite, copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END
