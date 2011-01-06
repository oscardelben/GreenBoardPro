//
//  Idea.m
//  Ideas
//
//  Created by Oscar Del Ben on 1/5/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "Idea.h"


@implementation Idea

@dynamic name;
@dynamic timeStamp;
@dynamic parent;
@dynamic children;

- (NSString *)recursiveDump:(BOOL)first andIndentation:(int)indentation
{
	NSMutableString *result = [NSMutableString string];
	
	if (first) {
		[result appendString:[self name]];
	} else {
		NSMutableString *indentationString = [NSMutableString string];
		
		for (int i = 0; i < indentation; i++) {
			[indentationString appendString:@" "];
		}
		
		[result appendFormat:@"%@- %@", indentationString, [self name]];
	}
	
	
	// repeat for every children
	
	// NSSet is not ordered!
	NSSet *ideaChildren = [self valueForKey:@"children"];
	
	for (Idea *child in ideaChildren) {
		[result appendFormat:@"\n"];
		[result appendFormat:@"%@", [child recursiveDump:NO andIndentation:indentation + 2]];
	}
	
	return result;
}

- (NSString *)dump
{
	return [self recursiveDump:YES andIndentation:0];
}

@end
