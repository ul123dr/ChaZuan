//
//  CycleCollectionModel.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface CycleCollectionModel : MHObject

@property (nonatomic, readwrite, copy) NSString *imgUrl;
@property (nonatomic, readwrite, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
