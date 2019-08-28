//
//  NoteList.h
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteList : MHObject

@property (nonatomic, readwrite, assign) BOOL appCheckCode;
@property (nonatomic, readwrite, strong) NSNumber *listId;
@property (nonatomic, readwrite, assign) NSInteger status;
@property (nonatomic, readwrite, assign) NSInteger type;
@property (nonatomic, readwrite, copy) NSString *createTime;
@property (nonatomic, readwrite, copy) NSString *pushTemp;
@property (nonatomic, readwrite, copy) NSString *remark;

@end

NS_ASSUME_NONNULL_END
