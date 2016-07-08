//
//  ViewController.m
//  base64和钥匙串
//
//  Created by 王奥东 on 16/4/15.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ViewController.h"
#import "SSKeychain.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSString *str = @"http:///login.php";
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSString *username =[SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:@"username"];
    NSString *password =[SSKeychain passwordForService:[NSBundle mainBundle].bundleIdentifier account:@"password"];
    if (username==nil&&password==nil) {
        username = @"张 张";
        
        
        
        NSData *data = [username dataUsingEncoding:NSUTF8StringEncoding];
        username = [data base64EncodedStringWithOptions:0];
        
        
        password = @"saner";
        NSData *data2 = [password dataUsingEncoding:NSUTF8StringEncoding];
        password = [data2 base64EncodedStringWithOptions:0];
        
        [SSKeychain setPassword:username forService:[NSBundle mainBundle].bundleIdentifier account:@"username"];
        [SSKeychain setPassword:password forService:[NSBundle mainBundle].bundleIdentifier account:@"password"];
        
        NSLog(@"%@------%@",username,password);
        
    }
//    
//    [SSKeychain deletePasswordForService:[NSBundle mainBundle].bundleIdentifier account:@"username"];
//    
//    [SSKeychain deletePasswordForService:[NSBundle mainBundle].bundleIdentifier account:@"password"];
    
    request.HTTPMethod = @"POST";
    NSString *para = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    
    request.HTTPBody =[para dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",dict);
    
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
