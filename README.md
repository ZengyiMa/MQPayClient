# MQPayClient

#### ****集成说明：****

1. 把openssl文件夹放在你的工程目录下面，并且在项目中右键选择`add files` 把openssl导入到项目中, 打开工程->Build Settings -> Search Paths -> Header Search Paths点击添加`$(PROJECT_DIR)/`(将openssl下面文件添加到头文件搜索路径)，并且把`MQPayClient`文件拖入项目中。
   
2. 添加依赖库 `SystemConfiguration.framework` 、`libsqlite3.tbd`（xcode7是tbd格式，xcode6添加相应的即可） 、`libz.tbd`(同上)、`CoreTelephony.framework`。
   
3. 在AppDelegate 中导入头文件``#import “MQPayClient.h”``，在`didFinishLaunchingWithOptions`调用
   
   ``` 
   [[MQPayClient shareInstance]registerClient:MQPayClientTypeWeixin|MQPayClientTypeAlipay];
   
   ```
   
   最后的参数是Type，指明你要初始化的是微信还是支付宝或者两者都要。
   
   在 `-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url`
   
   中调用`[MQPayClient handleOpenURL:url];`
   
   在`- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation`中调用
   
   `[MQPayClient handleOpenURL:url sourceApplication:sourceApplication];`
   
4. 在`MQPayClient`目录下有`Pay_config.plist`文件配置微信和支付宝的aped，key等关键配置项，配置微信和支付宝的Url Type，具体可看官方文档。
   
5. 在需要微信支付的地方调用
   
   ``` 
   [[MQPayClient shareInstance]weiXinPayWithOrderName:@"订单名字" orderMoney:@"金额" orderNo:@"订单号" completeBlock:^(id respObj) {    NSLog(@"%@", respObj);     }];
   
   ```
   
   在需要支付宝支付的地方调用
   
   ``` 
   [[MQPayClient shareInstance]alipayWithOrderName:@"订单名字" orderMoney:@"金额" orderNo:@"订单号" completeBlock:^(id respObj) {        NSLog(@"%@", respObj);    }];
   
   ```
   
   ​
   
   完。
   
   ​

