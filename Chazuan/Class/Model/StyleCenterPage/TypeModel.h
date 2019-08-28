//
//  TypeModel.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/11.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TypeList : MHObject

@property (nonatomic, readwrite, copy) NSString *designName;
@property (nonatomic, readwrite, strong) NSNumber *listId;
@property (nonatomic, readwrite, strong) NSNumber *type;

@end

@interface TypeModel : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSArray *list1;
@property (nonatomic, readwrite, strong) NSArray *list2;
@property (nonatomic, readwrite, strong) NSArray *list3;
@property (nonatomic, readwrite, strong) NSArray *list4;
@property (nonatomic, readwrite, strong) NSArray *list5;
@property (nonatomic, readwrite, strong) NSArray *list6;
@property (nonatomic, readwrite, strong) NSArray *list7;
@property (nonatomic, readwrite, strong) NSArray *list8;

@end

NS_ASSUME_NONNULL_END
