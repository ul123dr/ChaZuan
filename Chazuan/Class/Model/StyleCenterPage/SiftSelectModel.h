//
//  SiftSelectModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/11.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"
#import "SiftList.h"

NS_ASSUME_NONNULL_BEGIN

@interface SiftSelectModel : MHObject

@property (nonatomic, readwrite, strong) NSArray *categoryList;
@property (nonatomic, readwrite, strong) NSArray *describeList;
@property (nonatomic, readwrite, strong) NSArray *styleList;
@property (nonatomic, readwrite, strong) NSArray *scoopList;
@property (nonatomic, readwrite, strong) NSArray *gemsList;
@property (nonatomic, readwrite, strong) NSArray *recommendList;
@property (nonatomic, readwrite, strong) NSArray *typeList;
@property (nonatomic, readwrite, strong) NSArray *category8List;
@property (nonatomic, readwrite, strong) NSArray *describe8List;
@property (nonatomic, readwrite, strong) NSArray *style8List;
@property (nonatomic, readwrite, strong) NSArray *scoop8List;
@property (nonatomic, readwrite, strong) NSArray *recommend8List;

@end

NS_ASSUME_NONNULL_END
