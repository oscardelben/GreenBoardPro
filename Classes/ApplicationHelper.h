//
//  ApplicationHelper.h
//  Ideas
//
//  Created by Oscar Del Ben on 1/2/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ApplicationHelper : NSObject {

}

+ (void)showApplicationError;

+ (NSDictionary *)themes;
+ (NSDictionary *)theme;
+ (void)saveTheme:(NSString *)themeID;
+ (UIColor *)navigationColor;

+ (NSString *)recipient;
+ (void)setRecipient:(NSString *)recipient;


@end
