//
//  UIButton+Glossy.h
//  Ideas
//
//  Created by Oscar Del Ben on 12/29/10.
//  Copyright 2010 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIButton (Glossy)

+ (void)setPathToRoundedRect:(CGRect)rect forInset:(NSUInteger)inset inContext:(CGContextRef)context;
+ (void)drawGlossyRect:(CGRect)rect withColor:(UIColor*)color inContext:(CGContextRef)context;
- (void)setBackgroundToGlossyRectOfColor:(UIColor*)color withBorder:(BOOL)border forState:(UIControlState)state;

@end