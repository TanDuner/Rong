//
//  ViewController.m
//  MoveDemo
//
//  Created by JDMAC on 14-11-20.
//  Copyright (c) 2014年 JDMAC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置数据
    [self configData];
    
    //父类的属性 设置 顶部空隙 标题的样式
    centerSpaceY = 12;
    titleStyle = LeshowBtnModeBottomTitle;

    
    // 这句话设置 按钮的 个数 每行个数
    [self setViewLayOutParamsWithNumInRow:3 leftSpace:8 Size:CGSizeMake(95, 125)];

}


-(void)configData
{
    for (int i = 0; i<8; i++) {
        LeShowButtonItem *addItem = [[LeShowButtonItem alloc] init];
        //        addItem.titleStr = @"下载视频";
        addItem.image = [UIImage imageNamed:@"1.jpeg"];
        //        addItem.imageUrlStr = @"111";
        addItem.titleColor = [UIColor whiteColor];
        addItem.titleFont = [UIFont systemFontOfSize:13.0f];
        addItem.index = i;
        // 设置是否可长按出抖动效果
        addItem.canDelete = YES;
        
        [self.itemArray addObject:addItem];
    }

}

@end
