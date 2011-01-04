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
	NSDictionary *theme1 = [NSDictionary 
							dictionaryWithObjects:
							[NSArray arrayWithObjects:
								[NSInteger initWithInt:53], 
								[NSInteger initWithInt:161], 
								[NSInteger initWithInt:95],
								@"bg-white",
								@"bg-yellow",
								@"bg-yellow",
								nil] 
							forKeys:
							[NSArray arrayWithObjects:@"red", @"green", @"blue", @"background", @"foreground", @"selected", nil]];
	
	NSDictionary *theme4 = [NSDictionary 
							dictionaryWithObjects:
								[NSArray arrayWithObjects:19, 60, 101, nil] 
							forKeys:
								[NSArray arrayWithObjects:@"red", @"green", @"blue", nil]];
}

@end
