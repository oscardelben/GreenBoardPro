//
//  ApplicationHelper.m
//  Ideas
//
//  Created by Oscar Del Ben on 1/2/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "ApplicationHelper.h"


@implementation ApplicationHelper

+ (void)showApplicationError
{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:@"We experienced an error. Please quit the application by pressing the Home button." 
												   delegate:self cancelButtonTitle:@"Ok" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+ (NSDictionary *)themes
{
	
	NSArray *keys = [NSArray arrayWithObjects:@"name", @"red", @"green", @"blue", @"background", @"foreground", @"selected", nil];
	
	
	NSDictionary *theme1 = [NSDictionary 
							dictionaryWithObjects:
							[NSArray arrayWithObjects:
							 @"Ocean",
							 [NSNumber numberWithInt:19], 
							 [NSNumber numberWithInt:60], 
							 [NSNumber numberWithInt:101], 
							 @"bg-white.png",
							 @"bg-yellow.png",
							 @"bg-yellow.png",
							 nil] 
							forKeys: keys];
	
	NSDictionary *theme2 = [NSDictionary 
							dictionaryWithObjects:
							[NSArray arrayWithObjects:
							 @"Vibrant",
							 [NSNumber numberWithInt:101], 
							 [NSNumber numberWithInt:94], 
							 [NSNumber numberWithInt:57],
							 @"bg-blue.png",
							 @"bg-yellow.png",
							 @"bg-yellow.png",
							 nil] 
							forKeys: keys];
	
	NSDictionary *theme3 = [NSDictionary 
							dictionaryWithObjects:
							[NSArray arrayWithObjects:
							 @"Fashion",
							 [NSNumber numberWithInt:208], 
							 [NSNumber numberWithInt:31], 
							 [NSNumber numberWithInt:60], 
							 @"bg-white.png",
							 @"bg-yellow.png",
							 @"bg-yellow.png",
							 nil] 
							forKeys: keys];
	
	NSDictionary *theme4 = [NSDictionary 
							dictionaryWithObjects:
							[NSArray arrayWithObjects:
							 @"Nature",
							 [NSNumber numberWithInt:53], 
							 [NSNumber numberWithInt:161], 
							 [NSNumber numberWithInt:95],
							 @"bg-green-dark.png",
							 @"bg-green-light.png",
							 @"bg-green-middle.png",
							 nil] 
							forKeys: keys];
	
	NSDictionary *themes = [NSDictionary 
							dictionaryWithObjects:[NSArray arrayWithObjects:
													theme1, theme2, theme3, theme4, nil]
							forKeys:[NSArray arrayWithObjects:
									 @"theme1", @"theme2", @"theme3", @"theme4", nil]];
	
	return themes;
	
}

+ (NSDictionary *)theme
{	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	NSString *themeID = [userDefaults objectForKey:@"themeID"];
	
	if (themeID == nil) {
		return [[self themes] objectForKey:@"theme1"];
	} else {
		return [[self themes] objectForKey:themeID];
	}

}

+ (void)saveTheme:(NSString *)themeID
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
	[userDefaults setObject:themeID forKey:@"themeID"];
}

+ (NSString *)recipient
{
	NSUserDefaults *useDefaults = [NSUserDefaults standardUserDefaults];
	NSString *recipient = [useDefaults objectForKey:@"recipient"];
	
	if (recipient == nil) {
		return @"";
	} else {
		return recipient;
	}
}

@end
