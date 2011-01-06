//
//  Idea.h
//  Ideas
//
//  Created by Oscar Del Ben on 1/5/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Idea : NSManagedObject {

}

@property (assign) NSString *name;
@property (assign) NSDate *timeStamp;
@property (assign) NSManagedObject *parent;
@property (assign) NSManagedObject *children;

- (NSString *)dump;

@end
