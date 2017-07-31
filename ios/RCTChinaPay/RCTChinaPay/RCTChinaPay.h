//
//  RCTChinaPay.h
//  RCTChinaPay
//
//  Created by imall on 17/7/25.
//  Copyright © 2017年 imall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridge.h"
#import "RCTBridgeModule.h"
#import "CPPaySDK.h"

@interface RCTChinaPay : NSObject<RCTBridgeModule,CPPayDelegate>
{
    RCTBridge *bridge;
}

@property (nonatomic,retain)RCTBridge *bridge;

@end
