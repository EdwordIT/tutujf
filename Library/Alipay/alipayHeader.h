//
//  alipayHeader.h
//  psychic
//
//  Created by zhanbiguang on 15/10/29.
//  Copyright (c) 2015年 wzkn. All rights reserved.
//

#ifndef psychic_alipayHeader_h
#define psychic_alipayHeader_h

#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
#import "DataSigner.h"


#define AliSDK_partner   "2088221411986842"  //支付宝账号使用
#define AliSDK_seller  "sj5i@vip.qq.com"
#define AliSDK_privateKey "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAOiXctKpa8nUr11z87vPE/oU8Fb52YBa5i//CWcOvt7wq2X4LdW3bSuH1UXYSWEeLcETYeDSN6JFhEzROSNoBHMT2Jjsc2nKIVfMyY8L8bkzAALB/Nkdez/5PnnTxuSIMTXer3NJApO1xA9kf5FJBdXHp2fcgVSbzM/g100/gv+1AgMBAAECgYB2ljD+406Hmx7GIQZV7SCcUuyvC7gvTykps3iRyNzcQgzBcqW730eT+C9u6vWOxJpDZKR0wfmHjLYFjG77dF8/bDx6/7Uq9ZndWUdn2rUe/P8uY8+IKXqGaiZE8fml5DN93Ldbl89OrIgDdbz+112kSIU1tecqSZnlEsw9GCf0gQJBAPVsSYPNxVsXBMS5sMWLdbU594dIGU7DDuWGAqAb6etH5mMJiHs6uZ7WuugRhqdKBpJuFE+wwmt3tWeHPLLsQTECQQDynZg03p+GR2Trfol6IzKS6v37k4OYlA+jI0nj3JCgHluh6ljUKdaY4B8qCPeVJloza3IkMs4IxGtT3mpWpOXFAkBQpeUCivvvkwDeJKcSQ2HKy+GrcuXeG/spMYBrXMDhsB7lLJzM4d9dcvK4kAnPr2O5erLx/QPmjM/v1WD86uYBAkBWlN8onvoXFYtybynoqH7351zUVwRzgwNBmOpZovEJ80uIMPWaYYPv8quseJ7CX3l5ODL3sBnPDymuOIWCfj5xAkEAv4yKW0EtF3uNZCPXfl5zc3vdxHQPsZuCY5434QGd6Hik3VPe5OxClxD0II1tE9XmEEsx9KoqvsvugBQBjYXkKw=="
//直接在这里改下，后面也改成RSA
// 支付宝回调页面wapalipay
#define AliSdk_noticfy   "http://m.xipuw.cn/api/payment/alipay/notify_url.aspx"
//#define AliSdk_noticfy   "http://knyy.knjs.net:8088/alipaykey/notifyurl.aspx"
//
//测试商品信息封装在Product中,外部商户可以根据自己商品实际情况定义 支付宝用到
//
@interface Product : NSObject{
@private
    float     _price;
    NSString *_subject;
    NSString *_body;
    NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *orderId;
@end



#endif
