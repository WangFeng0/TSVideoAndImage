//
//  TSVideoPlayback.m
//  avplayer
//
//  Created by Feng on 2018/7/1.
//  Copyright © 2018年 Feng. All rights reserved.
//

#import "TSVideoPlayback.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"

@interface TSVideoPlayback ()<UIScrollViewDelegate>
{
    BOOL isVideos;
    NSInteger imgIndex;
}
@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面

@property (nonatomic,strong) UIScrollView * scrolView;
@property (nonatomic,strong) UILabel *indexLab;//当前播放页数
@property (nonatomic,strong) UIButton *playBtn;//播放按钮
@property (nonatomic,strong) UIButton *videoBtn;//切换到视频
@property (nonatomic,strong) UIButton *imgBtn;//切换到图片
@property (nonatomic,strong) NSArray *dataArray;


@end

@implementation TSVideoPlayback

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialControlUnit];
        }
    return self;
}

-(void)setWithIsVideo:(BOOL)isVideo andDataArray:(NSArray *)array
{
    self.dataArray = array;
    
    self.scrolView.contentSize = CGSizeMake(self.dataArray.count*self.frame.size.width, self.frame.size.height);
    isVideos = isVideo;
    if (isVideo) {
        [self.playBtn setHidden:NO];
        [self.videoBtn setHidden:NO];
        [self.imgBtn setHidden:NO];
    }else{
        [self.playBtn setHidden:YES];
        [self.videoBtn setHidden:YES];
        [self.imgBtn setHidden:YES];
    }
    for (int i = 0; i < _dataArray.count; i ++) {
        if (isVideo) {
            if (i == 0) {
                NSURL *url = [NSURL URLWithString:self.dataArray[0]];
                self.item = [AVPlayerItem playerItemWithURL:url];
                self.myPlayer = [AVPlayer playerWithPlayerItem:self.item];
                self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.myPlayer];
                self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                self.playerLayer.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
                [self.scrolView.layer addSublayer:self.playerLayer];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            }
            else{
                UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
                img.userInteractionEnabled = YES;
                [img sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i]] placeholderImage:[UIImage imageNamed:@"icon_video"]];
                [self.scrolView addSubview:img];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
                [img addGestureRecognizer:tap];
            }
            
            if (_dataArray.count > 1) {
                self.indexLab.text = [NSString stringWithFormat:@"%d/%d",1,(int)self.dataArray.count - 1];
                self.indexLab.hidden = YES;
                self.videoBtn.selected = YES;
                self.imgBtn.selected = NO;
            }
        }else{//全图片
            UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [img sd_setImageWithURL:[NSURL URLWithString:self.dataArray[i]] placeholderImage:[UIImage imageNamed:@"icon_video"]];
            img.userInteractionEnabled = YES;
            [self.scrolView addSubview:img];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapClick)];
            [img addGestureRecognizer:tap];
            
            self.indexLab.text = [NSString stringWithFormat:@"%d/%d",1,(int)self.dataArray.count];
            self.indexLab.hidden = NO;
            self.videoBtn.selected = YES;
            self.imgBtn.selected = YES;
        }
    }
}
/** 视频播放结束 */
- (void)videoPlayEnd:(NSNotification *)notic
{
    [self.playBtn setHidden:YES];
}

-(void)clearCache
{
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.myPlayer = nil;
}

#pragma mark - action
-(void)playClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.myPlayer play];
    }else{
        [self.myPlayer pause];
    }
}
- (void)changeBtnClick:(UIButton *)btn{
    if (btn.tag == 1) {
        self.videoBtn.selected = YES;
        self.imgBtn.selected = NO;
        self.videoBtn.backgroundColor = [UIColor orangeColor];
        self.imgBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        
        if ([self.scrolView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {

            [self.scrolView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self scrollViewDidEndDecelerating:self.scrolView];
        }
    }
    else{
        self.videoBtn.selected = NO;
        self.imgBtn.selected = YES;
        
        self.videoBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        self.imgBtn.backgroundColor = [UIColor orangeColor];
        if (self.scrolView.contentOffset.x < self.frame.size.width) {
            if ([self.scrolView.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
                [self.scrolView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
                [self scrollViewDidEndDecelerating:self.scrolView];
            }
        }
    }
    return;
}

-(void)imgTapClick
{
    if ([self.delegate respondsToSelector:@selector(videoView:didSelectItemAtIndexPath:)]) {
        if (isVideos) {
            [self.delegate videoView:self didSelectItemAtIndexPath:imgIndex];
        }else{
            [self.delegate videoView:self didSelectItemAtIndexPath:imgIndex+1];
        }
    }
}
#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.bounds.size.width;
    imgIndex = index;
    if (isVideos) {
        if (self.scrolView.contentOffset.x < self.frame.size.width) {
            self.indexLab.hidden = YES;
        }
        else{
            self.indexLab.hidden = NO;
        }
        self.indexLab.text = [NSString stringWithFormat:@"%d/%d",(int)index,(int)self.dataArray.count - 1];
    }else{
        self.indexLab.hidden = NO;
        self.indexLab.text = [NSString stringWithFormat:@"%d/%d",(int)index+1,(int)self.dataArray.count];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (isVideos) {
        if (self.scrolView.contentOffset.x < self.frame.size.width) {
            self.videoBtn.selected = YES;
            self.imgBtn.selected = NO;
            [self.playBtn setHidden:NO];
            self.videoBtn.backgroundColor = [UIColor orangeColor];
            self.imgBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        } else{
            self.videoBtn.selected = NO;
            self.imgBtn.selected = YES;
            [self.playBtn setHidden:YES];
            self.videoBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
            self.imgBtn.backgroundColor = [UIColor orangeColor];
            self.playBtn.selected = NO;
            [self.myPlayer pause];
        }
    }else{
        return;
    }
    
}

-(void)initialControlUnit
{
    isVideos = NO;
    _scrolView = [[UIScrollView alloc]init];
    _scrolView.pagingEnabled  = YES;
    _scrolView.delegate = self;
    _scrolView.showsVerticalScrollIndicator = NO;
    _scrolView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrolView];
    self.scrolView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _playBtn = [[UIButton alloc]init];
    _playBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_playBtn setImage:[UIImage imageNamed:@"icon_video"] forState:UIControlStateNormal];
    [self addSubview:_playBtn];
    self.playBtn.frame = CGRectMake((self.frame.size.width - 60)/2.0, (self.frame.size.height - 60)/2.0, 60, 60);
    
    _indexLab = [[UILabel alloc]init];
    _indexLab.textColor = [UIColor whiteColor];
    _indexLab.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    _indexLab.font = [UIFont systemFontOfSize:11];
    _indexLab.textAlignment = 1;
    _indexLab.layer.cornerRadius = 24/2;
    _indexLab.layer.masksToBounds = YES;
    [self.indexLab setHidden:YES];
    [self addSubview:self.indexLab];
    self.indexLab.frame = CGRectMake(self.frame.size.width - 60, self.frame.size.height - 45, 50, 24);
    
    _videoBtn = [[UIButton alloc]init];
    [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
    [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_videoBtn setBackgroundColor:[UIColor orangeColor]];
    _videoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _videoBtn.layer.cornerRadius = 24/2;
    _videoBtn.layer.masksToBounds = YES;
    self.videoBtn.tag = 1;
    [self addSubview:_videoBtn];
    self.videoBtn.frame = CGRectMake(self.center.x - 70, self.frame.size.height - 45, 60, 24);
    
    _imgBtn = [[UIButton alloc]init];
    [_imgBtn setTitle:@"图片" forState:UIControlStateNormal];
    [_imgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _imgBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _imgBtn.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
    _imgBtn.layer.cornerRadius = 24/2;
    _imgBtn.layer.masksToBounds = YES;
    self.imgBtn.tag = 2;
    [self addSubview:_imgBtn];
    self.imgBtn.frame = CGRectMake(self.center.x + 10, self.frame.size.height - 45, 60, 24);
    
    
    [self.videoBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgBtn addTarget:self action:@selector(changeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
}


@end
