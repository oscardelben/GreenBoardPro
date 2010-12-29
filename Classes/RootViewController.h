//
//  RootViewController.h
//  Ideas
//
//  Created by Oscar Del Ben on 12/27/10.
//  Copyright 2010 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate> {
	
	NSManagedObject *currentObject;
	
	BOOL isEnteringText;

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) NSManagedObject *currentObject;
@property (nonatomic, assign) BOOL isEnteringText;


- (void)showDeleteConfirmation:(id)sender;
- (void)deleteCurrentObject;

@end
