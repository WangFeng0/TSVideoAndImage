//
//  TSHomeViewController.m
//  avplayer
//
//  Created by Feng on 2018/7/2.
//  Copyright © 2018年 Feng. All rights reserved.
//

#import "TSHomeViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "TSVideoPlayback.h"

@interface TSHomeViewController ()<TSVideoPlaybackDelegate>

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer
@property (nonatomic,assign) TSBANNERTYPE type;
@property (nonatomic,strong) TSVideoPlayback *video;

@end

@implementation TSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialControlUnit];
}
#pragma mark - TSVideoPlaybackDelegate
-(void)videoView:(TSVideoPlayback *)view didSelectItemAtIndexPath:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
}

-(void)initialControlUnit
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.video = [[TSVideoPlayback alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) ];
    self.video.delegate = self;
    if (self.type == TSBANNERTYPEIMAGE) {
        self.title = @"纯图片详情";
        [self.video setWithIsVideo:TSDETAILTYPEIMAGE andDataArray:[self imgArray]];
    }else{
        self.title = @"视频图片详情";
        [self.video setWithIsVideo:TSDETAILTYPEVIDEO andDataArray:[self bannerArray]];
    }
    [self.view addSubview:self.video];
}

-(NSArray *)bannerArray
{
    return @[
             @"http://img.ptocool.com/video/2018-06-30_RGq4iDnu.mov",
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}
-(NSArray *)imgArray
{
    return @[
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}

-(instancetype)initWithType:(TSBANNERTYPE)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

//清除缓存必须写
-(void)dealloc
{
    [self.video clearCache];
}
@end
