//
//
//  Copyright (c) 2015 mazengyi https://github.com/semazengyi/MQPayClient
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "MQAlipayClient.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>


@interface MQAlipayClient ()

@property (nonatomic, copy) NSString *partnerId;
@property (nonatomic, copy) NSString *seller;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *notifyUrl;
@property (nonatomic, copy) NSString *privateKey;
@property (nonatomic, copy) NSString *appScheme;
@end

@implementation MQAlipayClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"pay_config" ofType:@"plist"]];
        _partnerId = configDic[@"alipay"][@"partnerid"];
        _privateKey = configDic[@"alipay"][@"privateKey"];
        _payTime = configDic[@"alipay"][@"paytime"];
        _seller = configDic[@"alipay"][@"seller"];
        _notifyUrl = configDic[@"alipay"][@"notifyUrl"];
        _appScheme = configDic[@"alipay"][@"appScheme"];
    }
    return self;
}

- (BOOL)registerApp
{
    //nothing
    return YES;
}

- (BOOL)HandleOpenURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"platformapi"])
    {
        //支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }

    return YES;
}



- (void)payWithOrderName:(NSString *)orderName orderMoney:(NSString *)orderMoney orderNo:(NSString *)orderNo
{
    Order *order = [[Order alloc] init];
    order.partner =self.partnerId;
    order.seller = self.seller;
    order.tradeNO =orderNo;
    order.productName = orderName; //商品标题
    order.productDescription = [NSString stringWithFormat:@"%@%@", @"订单编号:",orderNo]; //商品描述
    order.amount = orderMoney; //商 品价格
    //order.notifyURL = self.notifyUrl; //回调URL
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = self.payTime;
    order.showUrl = @"m.alipay.com";
    
    NSString *appScheme = self.appScheme;
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSString *alipayKey = self.privateKey;
    
    id<DataSigner> signer = CreateRSADataSigner(alipayKey);
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    //将签名成功字符串格式化为订单字符串,请严格按照该格式 NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
     
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic){
            if (_completeBlock) {
                _completeBlock(resultDic);
            }
        }];
        
       
    }

}




@end
