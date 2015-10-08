//
//  ViewController.m
//  MQPayDemo
//
//  Created by WsdlDev on 15/10/8.
//  Copyright © 2015年 mazengyi. All rights reserved.
//

#import "ViewController.h"
#import "MQPayClient.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weixinpay:(id)sender {
    [[MQPayClient shareInstance]weixinPayWithOrderName:@"1" orderMoney:@"1" orderNo:@"1231231" completeBlock:^(id respObj) {
        NSLog(@"%@", respObj);
    }];
}
- (IBAction)alipay:(id)sender {
    [[MQPayClient shareInstance]alipayWithOrderName:@"1" orderMoney:@"1" orderNo:@"1231231" completeBlock:^(id respObj) {
        NSLog(@"%@", respObj);
    }];
    
    
}

@end
