//
//  ManagerSpecialty.h
//  chazuan
//
//  Created by BecksZ on 2019/4/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ManagerSpecialty : MHObject

@property (nonatomic, readwrite, strong) NSNumber *webId; 
@property (nonatomic, readwrite, copy) NSString *indexLogo;
@property (nonatomic, readwrite, assign) BOOL status;
@property (nonatomic, readwrite, copy) NSString *address;
@property (nonatomic, readwrite, copy) NSString *wwwCN;
@property (nonatomic, readwrite, strong) NSNumber *mainId;
@property (nonatomic, readwrite, copy) NSString *company;
@property (nonatomic, readwrite, copy) NSString *phone;
@property (nonatomic, readwrite, strong) NSNumber *fax;
@property (nonatomic, readwrite, copy) NSString *recordNo;
@property (nonatomic, readwrite, copy) NSString *email;
@property (nonatomic, readwrite, copy) NSString *notice;
@property (nonatomic, readwrite, strong) NSNumber *ebyUid;
@property (nonatomic, readwrite, assign) BOOL isWechatNotice;
@property (nonatomic, readwrite, copy) NSString *weixinSign;
@property (nonatomic, readwrite, copy) NSString *deadline;
@property (nonatomic, readwrite, assign) NSInteger isSourceType;
@property (nonatomic, readwrite, copy) NSString *isOwnServer;
@property (nonatomic, readwrite, strong) NSNumber *gid;
@property (nonatomic, readwrite, assign) NSInteger isYGoodsStock;

//{"www":"www.caisezuanshi.com","www_mobile":"","www_big_style_color":"02cab9","www_main_cn":"",,"shortmessage_tpl_id":"13836","shortmessage_type":1,"shortmessage_appkey":"02ea7c6fcb9abaad736460dce360845f","is_own_login":0,"is_all_menu":1,"is_template_advertisement":0,"is_groupby_rate":1,"is_template_online_all":0,"is_diamond_cert_own_all":0,"is_certno_show":1,"is_price_show_on_login":1,"is_location_show":1,"is_have_b_c":2,"is_www_manager":0,"is_own_order":1,"rate_double":1.0,"all_add_rate":0.0,"all_add_rate_master":0.0,"all_add_rate_own":0.0,"diamond_show_power_master":"1","is_diamond_show_power_master":0,"www_profile":"0.....................................................................................","qq_1":"","qq_1_nick_name":"","qq_2":"","qq_2_nick_name":"","qq_3":"","qq_3_nick_name","top_logo":"undefined","login_logo":"undefined","www_2wm":"undefined","create_time":"Jun 20, 2017 10:09:01 AM","update_time":"Apr 14, 2019 5:43:10 PM","template":"template_1","rap_ids_all":"69550,90062,22035,73265,78634,70736,73189,92192,84769,61748,89389,94039,71209,67016,97085,66974,71211,77949,73688,74841,81884,12458,48394,50841,58826,62919,63050,67155,68981,70958,71100,71306,71657,73440,74753,75583,43460,78738,43093,73564,91873,66444,73302,21343,88933,66658,70860,78089,90990,71747,92736,79736,85412,94793,93967,71289,90959,77165,44659,21343C,63050C,48394C,51500,105764,85221,80171,103794,32457,92521,10328C,98440,70554,10300,55550,106769,95745,10444,10309,109313,10455,10452,105042,79892,86761,98508,10195,108049,10447,106725,10437,110477,94264,103138,87222,103938,84970,10159,86803,104455,92056,10208,103828,10193,10351,107950,10442,107902,10400,107588,106360,10446,95830,112065,110364,66622,107027,32952,10499","is_hava_mobile":0,"remark":"虞海俊","is_wei_pay":0,"status":0,"is_own_logo":2,"is_supplier_rate":2,"deadline_remark":"","own_logo_user_num":0,"all_rate_double_lz_color_master":1.0,"shortmessage_num":0,"isdisp":0,"have_xcx":0,"is_all_can_login":1,"is_true_order":0,"is_show_goodssylte":0,,"is_special_goods_stock":0,"order_tj":0,"order_sx":0,"is_xq":0,"is_sj":0,"app_check_code":"0","sign":"","sessionkey":""}

@end

NS_ASSUME_NONNULL_END
