//
//  ViewController.m
//  avplayer
//
//  Created by Feng on 2018/6/30.
//  Copyright © 2018年 Feng. All rights reserved.
//

#import "ViewController.h"
#import "TSHomeViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UIButton *imgBtn;
@property (nonatomic,strong) UIButton *videoBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initialControlUnit];
}

-(void)tapCLick:(UIButton *)btn
{
    if (btn.tag == 1) {
        TSHomeViewController *vc = [[TSHomeViewController alloc] initWithType:TSBANNERTYPEIMAGE];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        TSHomeViewController *vc = [[TSHomeViewController alloc] initWithType:TSBANNERTYPEVIDEO];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)initialControlUnit
{
    [self.view addSubview:self.imgBtn];
    [self.view addSubview:self.videoBtn];
}

-(UIButton *)imgBtn
{
    if (!_imgBtn) {
        _imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-90, 200, 180, 30)];
        [_imgBtn setTitle:@"只有图片" forState:UIControlStateNormal];
        [_imgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _imgBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _imgBtn.backgroundColor = [UIColor orangeColor];
        _imgBtn.tag = 1;
        [_imgBtn addTarget:self action:@selector(tapCLick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBtn;
}
-(UIButton *)videoBtn
{
    if (!_videoBtn) {
        _videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-90, 260, 180, 30)];
        [_videoBtn setTitle:@"图片和视频混合" forState:UIControlStateNormal];
        [_videoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _videoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _videoBtn.backgroundColor = [UIColor blackColor];
        _videoBtn.tag = 2;
        [_videoBtn addTarget:self action:@selector(tapCLick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
