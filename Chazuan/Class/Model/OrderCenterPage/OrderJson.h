//
//  OrderJson.h
//  Chazuan
//
//  Created by BecksZ on 2019/6/3.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderJson : MHObject

@property (nonatomic, readwrite, copy) NSString *pic;
@property (nonatomic, readwrite, strong) NSNumber *jsonId;
@property (nonatomic, readwrite, copy) NSString *zsmc;
@property (nonatomic, readwrite, copy) NSString *hand;
@property (nonatomic, readwrite, copy) NSString *dhand;
@property (nonatomic, readwrite, copy) NSString *designTypeCn;
@property (nonatomic, readwrite, copy) NSString *materialTypeCn; 
@property (nonatomic, readwrite, strong) NSNumber *weight;
@property (nonatomic, readwrite, strong) NSNumber *materialWeight;
@property (nonatomic, readwrite, strong) NSNumber *size;
@property (nonatomic, readwrite, copy) NSString *goodsPic;
@property (nonatomic, readwrite, strong) NSNumber *stockNum;
@property (nonatomic, readwrite, strong) NSNumber *price;
@property (nonatomic, readwrite, copy) NSString *barCode;
@property (nonatomic, readwrite, copy) NSString *designNo;
@property (nonatomic, readwrite, copy) NSString *temp1;
@property (nonatomic, readwrite, copy) NSString *temp2;
@property (nonatomic, readwrite, copy) NSString *temp3;
@property (nonatomic, readwrite, copy) NSString *temp4;
@property (nonatomic, readwrite, copy) NSString *temp5;
@property (nonatomic, readwrite, copy) NSString *temp6;
@property (nonatomic, readwrite, copy) NSString *remark;
@property (nonatomic, readwrite, copy) NSString *cert;
@property (nonatomic, readwrite, copy) NSString *certNo;
@property (nonatomic, readwrite, copy) NSString *uid;
@property (nonatomic, readwrite, copy) NSString *sellTime;
@property (nonatomic, readwrite, strong) NSNumber *sideStoneSize;
@property (nonatomic, readwrite, copy) NSString *sideStoneRemark;
@property (nonatomic, readwrite, copy) NSString *sizeShapeCn;
@property (nonatomic, readwrite, strong) NSNumber *sideStoneNum;
@property (nonatomic, readwrite, copy) NSString *materialCn;
@property (nonatomic, readwrite, copy) NSString *sizeTypeCn;
@property (nonatomic, readwrite, copy) NSString *sizeShapeLevel;


//"side_stone" : "-",
//"d_type_z_cn" : "3-4爪",
//"order_sx" : 0,
//"order_tj" : 0,
//"sign" : "",
//"s_id" : 332556,
//"is_delete" : 0,
//"create_time" : "May 9, 2019 5:02:27 PM",
//"status" : 0,

@end

NS_ASSUME_NONNULL_END
