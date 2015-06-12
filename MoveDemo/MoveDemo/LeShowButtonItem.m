//
//  LeShowButtonItem.m
//  LeShow
//
//  Created by xusc on 13-11-1.
//  Copyright (c) 2013年 HTTD. All rights reserved.
//

#import "LeShowButtonItem.h"

@implementation LeShowButtonItem
- (id)init
{
    self = [super init];
    if (self) {
        self.contentImage = nil;
        self.canDelete = YES;
    }
    return self;
}

- (void)dealloc
{
    
    self.titleStr =nil;;
    self.gameID=nil;
    
    self.image=nil;;
    self.imageUrlStr=nil;
    
    
    self.indexStr=nil;;
    
    self.contentImage=nil;
    self.contentUrlStr=nil;
    
    self.titleFont=nil;
    
    self.titleColor=nil;
    
    
    
    
    // 爱添加专用
    self.webUrlStr=nil;
    self.webSiteId=nil;
    
    // 视频
    self.videoUrl=nil;
    self.videoId=nil;
    
    

    self.photo_album_id=nil;
    [super dealloc];
}
@end
