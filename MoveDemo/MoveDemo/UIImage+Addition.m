//
//  UIImage+Addition.m
//  universalT800
//
//  Created by Rose Jack on 13-2-20.
//  Copyright (c). All rights reserved.
//

#import "UIImage+Addition.h"


@implementation UIImage (category)

- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor                                                                                                          
                           shadeAlpha1:(CGFloat)alpha1                                                                                                             
                           shadeAlpha2:(CGFloat)alpha2                                                                                                             
                           shadeAlpha3:(CGFloat)alpha3                                                                                                             
                           shadowColor:(UIColor *)shadowColor                                                                                                      
                          shadowOffset:(CGSize)shadowOffset                                                                                                        
                            shadowBlur:(CGFloat)shadowBlur {                                                                                                       
    UIImage *image = self;                                                                                                                                        
    CGColorRef cgColor = [bgColor CGColor];                                                                                                                        
    CGColorRef cgShadowColor = [shadowColor CGColor];                                                                                                              
    CGFloat components[16] = {1,1,1,alpha1,1,1,1,alpha1,1,1,1,alpha2,1,1,1,alpha3};                                                                                
    CGFloat locations[4] = {0,0.5,0.6,1};                                                                                                                          
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();                                                                                                    
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, (size_t)4);                                               
    CGRect contextRect;                                                                                                                                            
    contextRect.origin.x = 0.0f;                                                                                                                                   
    contextRect.origin.y = 0.0f;                                                                                                                                   
    contextRect.size = [image size];                                                                                                                               
    //contextRect.size = CGSizeMake([image size].width+5,[image size].height+5);                                                                                   
    // Retrieve source image and begin image context                                                                                                               
    UIImage *itemImage = image;                                                                                                                                    
    CGSize itemImageSize = [itemImage size];                                                                                                                       
    CGPoint itemImagePosition;                                                                                                                                    
    itemImagePosition.x = ceilf((contextRect.size.width - itemImageSize.width) / 2);                                                                               
    itemImagePosition.y = ceilf((contextRect.size.height - itemImageSize.height) / 2);                                                                             
    UIGraphicsBeginImageContext(contextRect.size);                                                                                                                
    CGContextRef c = UIGraphicsGetCurrentContext();                                                                                                                
    // Setup shadow                                                                                                                                                
    CGContextSetShadowWithColor(c, shadowOffset, shadowBlur, cgShadowColor);                                                                                       
    // Setup transparency layer and clip to mask                                                                                                                   
    CGContextBeginTransparencyLayer(c, NULL);                                                                                                                      
    CGContextScaleCTM(c, 1.0, -1.0);                                                                                                                               
    CGContextClipToMask(c, CGRectMake(itemImagePosition.x, -itemImagePosition.y, itemImageSize.width, -itemImageSize.height), [itemImage CGImage]);                
    // Fill and end the transparency layer                                                                                                                         
    CGContextSetFillColorWithColor(c, cgColor);                                                                                                                    
    contextRect.size.height = -contextRect.size.height;                                                                                                            
    CGContextFillRect(c, contextRect);                                                                                                                            
    CGContextDrawLinearGradient(c, colorGradient,CGPointZero,CGPointMake(contextRect.size.width*1.0/4.0,contextRect.size.height),0);                              
    CGContextEndTransparencyLayer(c);                                                                                                                              
    //CGPointMake(contextRect.size.width*3.0/4.0, 0)                                                                                                               
    // Set selected image and end context                                                                                                                          
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();                                                                                            
    UIGraphicsEndImageContext();                                                                                                                                  
    CGColorSpaceRelease(colorSpace);                                                                                                                              
    CGGradientRelease(colorGradient);                                                                                                                              
    return resultImage;                                                                                                                                            
}


static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}
@end    
