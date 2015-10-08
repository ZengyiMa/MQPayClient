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

#import "MQWeixinPayClient.h"

#define kWeixinUnifiedorderUrl @"https://api.mch.weixin.qq.com/pay/unifiedorder"

@interface MQWeixinPayClient ()

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *mchId;
@property (nonatomic, copy) NSString *mchKey;
@property (nonatomic, copy) NSString *notifyUrl;

@end

@implementation MQWeixinPayClient


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *configDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"pay_config" ofType:@"plist"]];
        _appId = configDic[@"weixin"][@"appid"];
        _desc = configDic[@"weixin"][@"desc"];
        _mchId = configDic[@"weixin"][@"mch_id"];
        _mchKey = configDic[@"weixin"][@"mch_key"];
        _notifyUrl = configDic[@"weixin"][@"notifyUrl"];
    }
    return self;
}


- (BOOL)registerApp
{
   return [WXApi registerApp:self.appId withDescription:self.desc];
}

- (BOOL)HandleOpenURL:(NSURL *)url
{
  return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp
{
    if (_completeBlock) {
        _completeBlock(resp);
    }
}


- (void)payWithOrderName:(NSString *)orderName orderMoney:(NSString *)orderMoney orderNo:(NSString *)orderNo
{
    //随机数
    NSString *noncer_str = [NSString stringWithFormat:@"%d", arc4random()];;
    NSString *ip = [MQUntils getIPAddress:YES];
    NSMutableDictionary *parma = [NSMutableDictionary dictionary];
    parma[@"appid"] = self.appId;
    parma[@"body"] = orderName;
    parma[@"mch_id"] = self.mchId;
    parma[@"nonce_str"] = noncer_str;
    parma[@"notify_url"] = self.notifyUrl;
    parma[@"out_trade_no"] = orderNo;
    parma[@"spbill_create_ip"] = ip;
    parma[@"total_fee"] = orderMoney;
    parma[@"trade_type"] = @"APP";
    NSString *reqString =  [NSString stringWithFormat:@"appid=%@&body=%@&mch_id=%@&nonce_str=%@&notify_url=%@&out_trade_no=%@&spbill_create_ip=%@&total_fee=%@&trade_type=APP&key=", self.appId, orderName,self.mchId, noncer_str, self.notifyUrl, orderNo, ip, orderMoney];
    reqString = [reqString stringByAppendingString:self.mchKey];
    NSString *md5 = [MQUntils md5:reqString];
    //生成xml
    NSMutableString *reqPars=[NSMutableString string];
    NSArray *keys = parma.allKeys;
    [reqPars appendString:@"<xml>\n"];
    for (NSString *categoryId in keys) {
        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [parma objectForKey:categoryId],categoryId];
    }
    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", md5];
    NSData *d = [MQUntils httpSend:kWeixinUnifiedorderUrl method:@"post" data:reqPars];
    XMLHelper *xml  = [[XMLHelper alloc]init];
    //开始解析
    [xml startParse:d];
    NSMutableDictionary *resParams = [xml getDict];
    //判断返回
    NSString *return_code   = [resParams objectForKey:@"return_code"];
    NSString *result_code   = [resParams objectForKey:@"result_code"];
    if ([return_code isEqualToString:@"SUCCESS"] && [result_code isEqualToString:@"SUCCESS"]) {
        NSString *prepay_id = resParams[@"prepay_id"];
        PayReq *request = [[PayReq alloc] init];
        request.partnerId = self.mchId;
        request.prepayId= prepay_id;
        request.package = @"Sign=WXPay";
        request.nonceStr= noncer_str;
        request.timeStamp= [NSDate date].timeIntervalSince1970;
        //计算sign
        NSString *s1=  [NSString stringWithFormat:@"appid=%@&noncestr=%@&package=Sign=WXPay&partnerid=%@&prepayid=%@&timestamp=%d&key=%@", self.appId, noncer_str, self.mchId, prepay_id, request.timeStamp,self.mchKey];
        request.sign = [MQUntils md5:s1];
        [WXApi sendReq:request];
    }
}

@end
