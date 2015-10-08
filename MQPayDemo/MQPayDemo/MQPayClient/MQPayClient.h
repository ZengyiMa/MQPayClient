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




#import <Foundation/Foundation.h>
#import "MQPayClientProtocol.h"

///支付类型
typedef NS_OPTIONS(NSUInteger, MQPayClientType) {
    MQPayClientTypeWeixin = 1 << 0, ///微信
    MQPayClientTypeAlipay = 1 << 1, ///支付宝
};


@interface MQPayClient : NSObject


/**
 *  @brief  注册2个平台的支付相关信息，在didfinsh中调用
 *
 *  @param cientType 支付平台的类型，可以支持微信，支付宝，或者2者都支持
 *
 *  @return 正确返回YES，错误返回NO
 */
- (BOOL)registerClient:(MQPayClientType)cientType;

/**
 *  @brief  获取支付客户端单例，通过单例可以完成支付相关的工作
 *
 *  @return 返回实例对象
 */
+ (MQPayClient *)shareInstance;

/**
 *  @brief  处理微信返回来的url消息
 *
 *  @param url 返回的url
 *
 *  @return 正确处理返回YES,或者则为NO
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

/**
 *  @brief  处理微信返回来的url消息
 *
 *  @param url               返回的url
 *  @param sourceApplication 调用着的app名字
 *
 *  @return 正确处理返回YES,或者则为NO
 */
+ (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

/**
 *  @brief  微信支付的接口，调用此接口完成微信支付
 *
 *  @param orderName     订单名称
 *  @param orderMoney    订单的金额（分）
 *  @param orderNo       订单号
 *  @param completeBlock 完成的回调，里面有错误码和错误信息，可以根据相关消息自己判断错误类型
 */
- (void)weixinPayWithOrderName:(NSString *)orderName orderMoney:(NSString *)orderMoney orderNo:(NSString *)orderNo completeBlock:(MQPayClientCompleteBlock)completeBlock;

/**
 *  @brief  支付宝支付的接口，调用此接口完成支付宝支付
 *
 *  @param orderName     订单名称
 *  @param orderMoney    订单的金额（分）
 *  @param orderNo       订单号
 *  @param completeBlock 完成的回调，里面有错误码和错误信息，可以根据相关消息自己判断错误类型
 */
- (void)alipayWithOrderName:(NSString *)orderName orderMoney:(NSString *)orderMoney orderNo:(NSString *)orderNo completeBlock:(MQPayClientCompleteBlock)completeBlock;
@end
