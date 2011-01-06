// 
//  Idea.m
//  Ideas
//
//  Created by Oscar Del Ben on 1/6/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "Idea.h"


@implementation Idea 

@dynamic timeStamp;
@dynamic name;
@dynamic children;
@dynamic parent;


- (NSArray *)orderedChildren
{
	NSSet *children = [self valueForKey:@"children"];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
	
	[sortDescriptor release];
	
	return [children sortedArrayUsingDescriptors:sortDescriptors];
}

- (NSString *)dumpIter:(BOOL)firstTime indentation:(int)indentation
{
	NSMutableString *result = [NSMutableString string];
	
	NSString *name = [self valueForKey:@"name"];
	
	if (firstTime) {
		[result appendString:name];
	} else {
		NSMutableString *stringIndentation = [NSMutableString string];
		
		for (int i = 0; i < indentation; i++) {
			// two spaces for every indentation
			[stringIndentation appendString:@"  "];
		}
		
		[result appendFormat:@"%@- %@", stringIndentation, name];
	}
	
	for (Idea *child in [self orderedChildren]) {
		[result appendString:@"\n"];
		
		[result appendString:[child dumpIter:NO indentation:indentation+1]];
	}
	
	return result;
}

- (NSString *)dump
{
	return [self dumpIter:YES indentation:0];
}

- (NSString *)subject
{
	NSString *str = [self valueForKey:@"name"];
	
	if ([str length] > 60) {
		NSString *subject = [str substringToIndex:60];
		return [NSString stringWithFormat:@"%@...", subject];
	} else {
		return str;
	}

}

@end
