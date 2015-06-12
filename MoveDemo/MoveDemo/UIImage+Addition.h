//
//  UIImage+Addition.h
//  universalT800
//
//  Created by Rose Jack on 13-2-20.
//  Copyright (c). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 etc:
 UIImage *niceImage = [[UIImage imageNamed:@"image_name"] imageWithBackgroundColor:[UIColor colorWithRed:41.0/255.0 green:147.0/255.0 blue:239.0/255.0 alpha:1.0]   
 shadeAlpha1:0.6                                                                              
 shadeAlpha2:0.0                                                                              
 shadeAlpha3:0.4                                                                              
 shadowColor:[UIColor blackColor]                                                             
 shadowOffset:CGSizeMake(0.0f, -1.0f)                                                          
 shadowBlur:3.0];
 
 */

@interface UIImage (category) 

- (UIImage *) imageWithBackgroundColor:(UIColor *)bgColor                                                                                                          
                           shadeAlpha1:(CGFloat)alpha1                                                                                                             
                           shadeAlpha2:(CGFloat)alpha2                                                                                                             
                           shadeAlpha3:(CGFloat)alpha3                                                                                                             
                           shadowColor:(UIColor *)shadowColor                                                                                                      
                          shadowOffset:(CGSize)shadowOffset                                                                                                        
                            shadowBlur:(CGFloat)shadowBlur;


+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
@end
