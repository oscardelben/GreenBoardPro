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
	
	NSArray *keys = [NSArray arrayWithObjects:@"red", @"green", @"blue", @"background", @"foreground", @"selected", nil];
	
	NSDictionary *theme1 = [NSDictionary 
							dictionaryWithObjects:
							[NSArray arrayWithObjects:
								[NSNumber numberWithInt:53], 
								[NSNumber numberWithInt:161], 
								[NSNumber numberWithInt:95],
								@"bg-green-dark.png",
								@"bg-green-light.png",
								@"bg-green-middle.png",
								nil] 
							forKeys: keys];
	
	NSDictionary *theme4 = [NSDictionary 
							dictionaryWithObjects:
								[NSArray arrayWithObjects:
									[NSNumber numberWithInt:19], 
									[NSNumber numberWithInt:60], 
									[NSNumber numberWithInt:101], 
									@"bg-white.png",
									@"bg-yellow.png",
									@"bg-yellow.png",
									nil] 
							forKeys: keys];
	
	
}

@end
