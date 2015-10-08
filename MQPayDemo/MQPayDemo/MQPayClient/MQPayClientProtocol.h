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

///回调的block类型
typedef void(^MQPayClientCompleteBlock)(id respObj);

///支付协议
@protocol MQPayClientProtocol <NSObject>

@required
///回调block
@property (nonatomic, copy) MQPayClientCompleteBlock completeBlock;

/**
 *  @brief  第一步，注册一个app
 *
 *  @return 注册成功返回YES ，否则NO
 */
- (BOOL)registerApp;

/**
 *  @brief  第二部处理返回的url
 *
 *  @param url 返回的url
 *
 *  @return 成功处理返回YES ，否则NO
 */
- (BOOL)HandleOpenURL:(NSURL *)url;

/**
 *  @brief  支付接口
 *
 *  @param orderName  订单名字
 *  @param orderMoney 金额（分）
 *  @param orderNo    订单号
 */
- (void)payWithOrderName:(NSString *)orderName orderMoney:(NSString *)orderMoney orderNo:(NSString *)orderNo;
@end
