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

@end
