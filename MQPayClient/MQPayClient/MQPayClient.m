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

#import "MQPayClient.h"
#import "WXApi.h"
#import "MQWeixinPayClient.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MQAlipayClient.h"
@interface MQPayClient ()

///微信支付端
@property (nonatomic, strong) id<MQPayClientProtocol> weixinClient;
///支付宝端
@property (nonatomic, strong) id<MQPayClientProtocol> alipayClient;

@end

@implementation MQPayClient


#pragma mark - 类方法
+ (MQPayClient *)shareInstance
{
    static MQPayClient *payClientInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payClientInstance = [[MQPayClient alloc]init];
    });
    return payClientInstance;
}

+ (BOOL) handleOpenURL:(NSURL *)url
{
 
     return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)[MQPayClient shareInstance].weixinClient];
}

+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return  [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)[MQPayClient shareInstance].weixinClient];
    }
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
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


#pragma mark - 实例方法
- (BOOL)registerClient:(MQPayClientType)cientType;
{
    
    if (MQPayClientTypeWeixin & cientType) {
        _weixinClient = [[MQWeixinPayClient alloc]init];
        [_weixinClient registerApp];
    }
    if(MQPayClientTypeAlipay & cientType)
    {
        _alipayClient = [[MQAlipayClient alloc]init];
        [_alipayClient registerApp];
    }
    return YES;
}

- (void)weixinPayWithOrderName:(NSString *)orderName orderMoney:(NSString *)orderMoney orderNo:(NSString *)orderNo completeBlock:(MQPayClientCompleteBlock)completeBlock
{
    self.weixinClient.completeBlock = completeBlock;
    [self.weixinClient payWithOrderName:orderName orderMoney:orderMoney orderNo:orderNo];
}


- (void)alipayWithOrderName:(NSString *)orderName orderMoney:(NSString *)orderMoney orderNo:(NSString *)orderNo completeBlock:(MQPayClientCompleteBlock)completeBlock
{
    self.alipayClient.completeBlock = completeBlock;
    [self.alipayClient payWithOrderName:orderNo orderMoney:orderMoney orderNo:orderNo];
}


@end
