//
//  Idea.h
//  Ideas
//
//  Created by Oscar Del Ben on 1/6/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Idea :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* children;
@property (nonatomic, retain) Idea * parent;

- (NSString *)dump;
- (NSString *)subject;

@end


@interface Idea (CoreDataGeneratedAccessors)
- (void)addChildrenObject:(Idea *)value;
- (void)removeChildrenObject:(Idea *)value;
- (void)addChildren:(NSSet *)value;
- (void)removeChildren:(NSSet *)value;

@end

