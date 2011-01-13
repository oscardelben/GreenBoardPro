//
//  ApplicationHelper.m
//  Ideas
//
//  Created by Oscar Del Ben on 1/2/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "ApplicationHelper.h"
#import "FlurryAPI.h"


@implementation ApplicationHelper

#pragma mark -
#pragma mark Errors

+ (void)showApplicationError
{
	[FlurryAPI logEvent:@"CAUGHT_ERROR"];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:@"We experienced an error. Please quit the application by pressing the Home button." 
												   delegate:self cancelButtonTitle:@"Ok" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Themes

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

+ (UIColor *)navigationColor
{
	NSDictionary *theme = [self theme];
	
	int r = [[theme objectForKey:@"red"] intValue];
	int g = [[theme objectForKey:@"green"] intValue];
	int b = [[theme objectForKey:@"blue"] intValue];
	
	return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

#pragma mark -
#pragma mark Emails

+ (NSString *)recipient
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *recipient = [userDefaults objectForKey:@"recipient"];
	
	if (recipient == nil) {
		return @"";
	} else {
		return recipient;
	}
}

+ (void)setRecipient:(NSString *)recipient
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:recipient forKey:@"recipient"];
}

@end
