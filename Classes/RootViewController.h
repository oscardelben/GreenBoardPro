//
//  RootViewController.h
//  Ideas
//
//  Created by Oscar Del Ben on 12/27/10.
//  Copyright 2010 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "IdeaDetailViewController.h"

@class MailComposerViewController;
@class Idea;

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate, IdeaDetailDelegate> {
	
	Idea *selectedIdea;
	MailComposerViewController *mailComposerViewController;

@private
    NSFetchedResultsController *fetchedResultsController_;
    NSManagedObjectContext *managedObjectContext_;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) Idea *selectedIdea;
@property (nonatomic, retain) MailComposerViewController *mailComposerViewController;


- (void)showDeleteConfirmation:(id)sender;
- (void)deleteCurrentObject;
- (void)updateTitle;
- (void)reloadTheme;

@end
