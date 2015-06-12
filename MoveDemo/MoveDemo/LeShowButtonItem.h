//
//  LeShowButtonItem.h
//  LeShow
//
//  Created by xusc on 13-11-1.
//  Copyright (c) 2013年 HTTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 总共俩个TBImageView, 跟button 大小一样的imageVIew
//defaultImage = image;
// urlPath = imageUrlStr;

//缩进十个像素的imageVIew defalutImage = contentImage
// urlPath = contentUrlStr 

@interface LeShowButtonItem : NSObject



@property (nonatomic,assign) BOOL isCorner;
@property (nonatomic,assign) BOOL canDelete;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,retain) NSString *titleStr;
@property (nonatomic,retain) NSString * gameID;

@property (nonatomic,retain) UIImage *image;

@property (nonatomic,retain) NSString *imageUrlStr;


@property (nonatomic,retain) NSString *indexStr;

@property (nonatomic,retain) UIImage *contentImage;
@property (nonatomic,retain) NSString *contentUrlStr;

@property (nonatomic,retain) UIFont *titleFont;

@property (nonatomic,retain) UIColor *titleColor;




// 爱添加专用
@property (nonatomic,retain) NSString *webUrlStr;
@property (nonatomic,retain) NSString *webSiteId;

// 视频
@property (nonatomic,retain) NSString *videoUrl;
@property (nonatomic,retain) NSString *videoId;



//   适用于图片秀的一级界面
//   0  基本相册    1  自定义相册  2添加相册按钮
@property (nonatomic,assign) NSInteger photoShowType;
@property (nonatomic,retain) NSString *photo_album_id;


@end
