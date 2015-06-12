//
//  LeShowButton.m
//  图标
//
//  Created by xusc on 13-10-30.
//  Copyright (c) 2013年 xusc. All rights reserved.
//

#import "LeShowButton.h"

@implementation LeShowButton

@synthesize isEditing,index;
@synthesize delegate;
@synthesize topImageView,bottomImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.indexStr = nil;
    self.topImageView = nil;
    self.bottomImageView = nil;
    self.item = nil;
    [self removeGestureRecognizer:longPress];
    [longPress release];
    [super dealloc];
}

- (id) initWithItem:(LeShowButtonItem *)item andFrame:(CGRect)frame titleStyle:(LeShowBtnMode)myTitleStyle andDelegate:(id)aDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backImage = item.image;
        
        titleText = item.titleStr;
        self.isEditing = NO;
        self.index = item.index;
        self.indexStr = [NSString stringWithFormat:@"%l",index];
        self.item = item;
        self.delegate = aDelegate;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:self.bounds];
        [button setTitleColor:item.titleColor forState:UIControlStateNormal];
        button.titleLabel.font = item.titleFont;
        if (item.isCorner) {
            backImage = [UIImage createRoundedRectImage:backImage size:CGSizeMake(frame.size.width,frame.size.height) radius:10];
        }
//        [button setBackgroundImage:backImage forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        
        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIImageView *bottomImageViewTemp = [[UIImageView alloc] initWithFrame:button.bounds];
//        bottomImageViewTemp.delegate = self;
//        bottomImageViewTemp.localDelegate = self;
        bottomImageViewTemp.userInteractionEnabled = NO;
        bottomImageViewTemp.backgroundColor = [UIColor clearColor];
        bottomImageViewTemp.tag = 100;
//        bottomImageViewTemp.defaultImage = backImage;
//        bottomImageViewTemp.urlPath = item.imageUrlStr;
        self.bottomImageView = bottomImageViewTemp;
        [bottomImageViewTemp release];
        [button addSubview:self.bottomImageView];
        
        
        UIImageView *topImageViewTemp = [[UIImageView alloc] initWithFrame:CGRectInset(button.bounds, 10, 10)];
//        topImageViewTemp.delegate = self;
//        topImageViewTemp.localDelegate = self;
        topImageViewTemp.backgroundColor = [UIColor clearColor];
        topImageViewTemp.tag = 111;
        topImageViewTemp.image = [UIImage imageNamed:@"1.jpeg"];
//        topImageViewTemp.urlPath = item.contentUrlStr;
//        topImageViewTemp.defaultImage = item.contentImage;
        topImageViewTemp.userInteractionEnabled = NO;
        self.topImageView = topImageViewTemp;
        [button addSubview:self.topImageView];
        [topImageViewTemp release];
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectInset(button.bounds, 10, 10)];
//        imageView.image = item.contentImage;
//        imageView.userInteractionEnabled = NO;
//        [button addSubview:imageView];
        
        [self addSubview:button];
        
        switch (myTitleStyle) {
            case 0:
            {
                [button setTitle:titleText forState:UIControlStateNormal];
                break;
            }
                
            case 1:
            {
                
                if (titleText.length>0) {
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20)];
                    label.backgroundColor = [UIColor clearColor];
                    label.layer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4].CGColor;
                    label.text = titleText;
                    label.textColor = item.titleColor;
                    label.font = [UIFont systemFontOfSize:14.0f];
                    label.textAlignment = NSTextAlignmentLeft;
                    [button addSubview:label];
//                    TB_RELEASE_CF_SAFELY(label);
                }
                
                
                break;
            }
                
            case 2:
                [button setTitle:titleText forState:UIControlStateNormal];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(self.bounds.size.height+30, 0, 0, 0)];
                break;
            default:
                break;
        }
        
        
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
        [self addGestureRecognizer:longPress];
        
        
        
        deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        float w = 30;
        float h = 30;
        
        [deleteButton setFrame:CGRectMake(self.bounds.origin.x-3,self.bounds.origin.y-3, w, h)];
//        [deleteButton setImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"deletbutton.png"] forState:UIControlStateNormal];
        deleteButton.backgroundColor = [UIColor clearColor];
        [deleteButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setHidden:YES];
        [self addSubview:deleteButton];
    }
    return self;
    
}


-(void)clickItem:(id)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(leShowButtonDidClicked:)]) {
        [delegate leShowButtonDidClicked:self];
    }
}
- (void) pressedLong:(UILongPressGestureRecognizer *) gestureRecognizer{
    
    if (!self.isCanEdit) {
        return;
    }
    
    if (!self.item.canDelete) {
        return;
    }
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            point = [gestureRecognizer locationInView:self];
            [delegate leShowButtonDidEnterEditingMode:self];
            //放大这个item
//            [self setAlpha:1.0];
            NSLog(@"开始");
            break;
        case UIGestureRecognizerStateEnded:
            point = [gestureRecognizer locationInView:self];
            [delegate leShowButtonDidEndMoved:self withLocation:point moveGestureRecognizer:gestureRecognizer];
            //变回原来大小
//            [self setAlpha:0.5f];
            NSLog(@"结束");
            break;
        case UIGestureRecognizerStateFailed:
            NSLog(@"失败");
            break;
        case UIGestureRecognizerStateChanged:
            //移动
            
            [delegate leShowButtonDidMoved:self withLocation:point moveGestureRecognizer:gestureRecognizer];
            NSLog(@"状态改变");
            break;
        default:
            NSLog(@"press long else");
            break;
    }
}
- (void) enableEditing
{
    if (self.isEditing == YES)
        return;
        self.isEditing = YES;
    
    if (!self.item.canDelete) {
        return;
    }
    [deleteButton setHidden:NO];
    [button setEnabled:NO];

    CGFloat rotation = 0.03;
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform"];
    shake.duration = 0.13;
    shake.autoreverses = YES;
    shake.repeatCount  = MAXFLOAT;
    shake.removedOnCompletion = NO;
    shake.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform,-rotation, 0.0 ,0.0 ,1.0)];
    shake.toValue   = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, rotation, 0.0 ,0.0 ,1.0)];
    
    [self.layer addAnimation:shake forKey:@"shakeAnimation"];
}
- (void) disableEditing {
    [self.layer removeAnimationForKey:@"shakeAnimation"];
    [deleteButton setHidden:YES];
    [button setEnabled:YES];
    self.isEditing = NO;
}

-(void)removeButtonClicked:(LeShowButton *)btn
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(leShowButtonDidDeleted:atIndex:)]) {
        if (self.item.canDelete) {
            [delegate leShowButtonDidDeleted:self atIndex:index];
        }
        else
        {
            
        }
    }
}

#pragma -mark TBImageView Delegate Methods
//
//- (void)imageView:(TBImageView *)imageView didLoadImage:(UIImage*)image
//{
//    if (self.delegate &&[self.delegate respondsToSelector:@selector(imageView:didLoadImage:)]) {
//        [self.delegate performSelector:@selector(imageView:didLoadImage:) withObject:imageView withObject:image];
//    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(leshowButtonDidLoadImage:)]) {
//        [self.delegate performSelector:@selector(leshowButtonDidLoadImage:) withObject:self];
//    }
//}
//
//- (void)imageview:(TBImageView *)imageView didLoadTheLocalImage:(UIImage *)image
//{
//    if (self.delegate &&[self.delegate respondsToSelector:@selector(imageView:didLoadImage:)]) {
//        [self.delegate performSelector:@selector(imageView:didLoadImage:) withObject:imageView withObject:image];
//    }
//
//
//}

//-(void)setTheProxy:(ASIHTTPRequest *)request
//{
//    [request retain];
//    if ([YissDataModelSingleton sharedInstance].IsProxyNet == YES) {
//        [request setProxyDomain:@"proxy.mssp.co"];
//        [request setProxyPort:9090];
//        
//    }
//    else
//    {
//        return;
//    }
//     
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
