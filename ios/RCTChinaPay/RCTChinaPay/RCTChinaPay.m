//
//  RCTChinaPay.m
//  RCTChinaPay
//
//  Created by imall on 17/7/25.
//  Copyright © 2017年 imall. All rights reserved.
//

#import "RCTChinaPay.h"

@implementation RCTChinaPay

@synthesize bridge = _bridge;

RCTResponseSenderBlock CallBack;
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(startPay:(nonnull id)infos callback:(RCTResponseSenderBlock)callback)
{
    CallBack = callback;
    
    
    [self signWithDatas:infos];
}

-(NSString *)lowerFirst:(NSString *)key{
    NSString *first = [key substringToIndex:1];
    NSString *changedKey = [NSString stringWithFormat:@"%@%@",[first lowercaseString],[key substringFromIndex:1]];
    return changedKey;
}

RCT_EXPORT_METHOD(startSign:(nonnull id)datas callback:(RCTResponseSenderBlock)callback)
{
    
}

-(NSString *)encodeDic:(NSDictionary *)dic{
    NSData *riskData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:nil];
    NSData *base64Data = [riskData base64EncodedDataWithOptions:NSUTF8StringEncoding];
    NSString *resultStr = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    return  resultStr;
}

- (void)signWithDatas:(NSDictionary *)datas {
    
    NSDictionary *riskDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"MUP",@"PayMode", nil];
    NSString *result = [self encodeDic:riskDic];
    CPPayReq *payReq = [[CPPayReq alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:datas];
    [dict setObject:result forKey:@"RiskData"];
    
    NSMutableString *plainText = [NSMutableString string];
    for (NSString *key in [dict allKeys]){
        [plainText appendFormat:@"%@=%@&", [self lowerFirst:key], [dict objectForKey:key]];
    }
    NSString *urlStr;
    NSString *plain = [plainText substringToIndex:(plainText.length - 1)];
    //内网
    //    urlStr = [NSString stringWithFormat:@"http://131.252.83.233:9080/CPPayWebDemo/MPOrder?%@",plain];
    //外网
    urlStr = [NSString stringWithFormat:@"http://140.206.112.245/CPPayWebDemo/MPOrder?%@",plain];


    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSRange range,rangeRisk;
        rangeRisk = [str rangeOfString:@"riskData="];
        range = [str rangeOfString:@"&signature="];
        NSString *riskData = [str substringWithRange:NSMakeRange((rangeRisk.location + rangeRisk.length), range.location - rangeRisk.location - rangeRisk.length)];
        NSString *signature = [str substringFromIndex:range.location + range.length];
        dispatch_async(dispatch_get_main_queue(), ^{
            [dict setObject:signature forKey:@"Signature"];
            [dict setObject:riskData forKey:@"RiskData"];
            payReq.orderInfo = [[NSDictionary alloc] initWithDictionary:dict];
            payReq.mode = @"02";//内网测试02 公网测试01 生产00
            [CPPaySDK payWithViewController:[self getCurrentVC] withDelegate:self withReq:payReq];
            
        });
    }];
    // 启动任务
    [task resume];
}

-(void)onPayResp:(CPPayResp *)resp{
    if([resp.respCode isEqualToString:@"0000"]){
        //        CPPayResultViewController *resultVC = [[CPPayResultViewController alloc] init];
        //        resultVC.resultTip = @"支付成功！";
        //        [self.navigationController pushViewController:resultVC animated:YES];
    }
    else{
        //        CPPayResultViewController *resultVC = [[CPPayResultViewController alloc] init];
        //        resultVC.resultTip = resp.respMsg;
        //        [self.navigationController pushViewController:resultVC animated:YES];
    }

    CallBack(@[@{@"errCode":resp.respCode,@"msg":resp.respMsg,@"content":resp.respContentStr?resp.respContentStr:@""}]);
//    NSString *response = [NSString stringWithFormat:@"%@:%@%@", resp.respCode, resp.respMsg,resp.respContentStr];
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"应答" message:response delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//    [alert show];
}

- (UIViewController *)getCurrentVC
{
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}

@end
