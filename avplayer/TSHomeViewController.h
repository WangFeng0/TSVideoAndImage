//
//  TSHomeViewController.h
//  avplayer
//
//  Created by Feng on 2018/7/2.
//  Copyright © 2018年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TSBANNERTYPEIMAGE,
    TSBANNERTYPEVIDEO,
} TSBANNERTYPE;

@interface TSHomeViewController : UIViewController

-(instancetype)initWithType:(TSBANNERTYPE)type;

@end
