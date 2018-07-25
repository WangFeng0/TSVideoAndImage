//
//  TSVideoPlayback.h
//  avplayer
//
//  Created by Feng on 2018/7/1.
//  Copyright © 2018年 Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TSVideoPlayback;

@protocol TSVideoPlaybackDelegate <NSObject>

//点击图片索引
-(void)videoView:(TSVideoPlayback *)view didSelectItemAtIndexPath:(NSInteger)index;

@end

@interface TSVideoPlayback : UIView

@property (nonatomic,weak) id<TSVideoPlaybackDelegate> delegate;

/*
 * isVideo  是否带视屏链接
 * array    数据
 */
-(void)setWithIsVideo:(BOOL)isVideo andDataArray:(NSArray *)array;

//清除缓存（必须写）
-(void)clearCache;

@end
