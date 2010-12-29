//
//  RootViewController.m
//  Ideas
//
//  Created by Oscar Del Ben on 12/27/10.
//  Copyright 2010 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "RootViewController.h"
#import "CustomCell.h"
#import "UIButton+Glossy.h"


@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation RootViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

@synthesize currentObject, isEnteringText;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
	
	if (currentObject) {
		self.navigationItem.title = [NSString stringWithFormat:@"%@ (%d)",
									 [currentObject valueForKey:@"name"], [[self.fetchedResultsController fetchedObjects] count]];
	} else {
		self.navigationItem.title = [NSString stringWithFormat:@"Ideas (%d)", [[self.fetchedResultsController fetchedObjects] count]];
	}
	
	if (currentObject) {
		// Configure header
		
		NSString *text = [currentObject valueForKey:@"name"];
		
		CGSize withinSize = CGSizeMake(300, 2000); // max size allowed
		CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:withinSize lineBreakMode:UILineBreakModeWordWrap];
		
		UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, size.height + 20)] autorelease];
		UITextView *textArea = [[[UITextView alloc] initWithFrame:CGRectMake(10, 20, 300, size.height)] autorelease];
		textArea.backgroundColor = [UIColor whiteColor];
		textArea.text = text;
		[containerView addSubview:textArea];
		self.tableView.tableHeaderView = containerView;
		
		
		// Configure footer
		// http://www.mlsite.net/blog/?p=232
		
		UIView *footerContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 54)] autorelease];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		// button.frame = CGRectMake(0, 0, 310, 54);
		button.frame = CGRectMake(10, 10, 300, 34);
		
		UIColor *redColor = [UIColor colorWithRed:.65 green:.05 blue:.05 alpha:1];
		
		[button setBackgroundToGlossyRectOfColor:redColor withBorder:YES forState:UIControlStateNormal];
		
		[button setTitle:@"Delete" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[button setTitleShadowColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1] forState:UIControlStateNormal];
		[button.titleLabel setShadowOffset:CGSizeMake(0, -1)];
		[button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		
		[button addTarget:self action:@selector(showDeleteConfirmation:) forControlEvents:UIControlEventTouchUpInside];
		
		[footerContainerView addSubview:button];
		
		self.tableView.tableFooterView = footerContainerView;
	}
}



// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */


- (void)configureCell:(CustomCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.name.text = [managedObject valueForKey:@"name"];
	cell.name.delegate = self;
}

- (void)showDeleteConfirmation:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Deleting this entry will also delete all of its children" 
								  delegate:self 
								  cancelButtonTitle:@"Cancel" 
								  destructiveButtonTitle:@"Confirm" 
								  otherButtonTitles:nil];
	
	[actionSheet showInView:self.view];
	
	[actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[self deleteCurrentObject];
	}
}


#pragma mark -
#pragma mark Add a new object


- (void)insertNewObject {
    // Create a new instance of the entity managed by the fetched results controller.
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
	
	if (currentObject) {
		[newManagedObject setValue:currentObject forKey:@"parent"];
	}
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"We experienced an error. Please quit the application by pressing the Home button." 
													   delegate:self cancelButtonTitle:nil 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
	
}

- (void)updateObject:(NSIndexPath *)indexPath andName:(NSString *)name {
	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];

	[managedObject setValue:name forKey:@"name"];
	
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"We experienced an error. Please quit the application by pressing the Home button." 
													   delegate:self cancelButtonTitle:nil 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)deleteCurrentObject
{
	
	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	
	[context deleteObject:currentObject];
	
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"We experienced an error. Please quit the application by pressing the Home button." 
													   delegate:self cancelButtonTitle:nil 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {

    // Prevent new objects being added when in editing mode.
    [super setEditing:(BOOL)editing animated:(BOOL)animated];
    self.navigationItem.rightBarButtonItem.enabled = !editing;
}

- (void)showKeyboard:(NSIndexPath *)indexPath
{
	CustomCell *cell = (CustomCell *)[self.tableView cellForRowAtIndexPath:indexPath];

	[cell.name becomeFirstResponder];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCell";
    
	CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        // cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		NSArray *topLevelObjects = [[NSBundle mainBundle]
									loadNibNamed:@"CustomCell" owner:nil options:nil];
		
		for (id theObject in topLevelObjects) {
			if ([theObject isKindOfClass:[UITableViewCell class]]) {
				cell = (CustomCell *)theObject;
				break;
			}
		}
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
															message:@"We experienced an error. Please quit the application by pressing the Home button." 
														   delegate:self cancelButtonTitle:nil 
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
        }
    }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (isEnteringText) {
		return;
	}
	
	RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	rootViewController.managedObjectContext = self.managedObjectContext;
	
	NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	rootViewController.currentObject = managedObject;
	
	[self.navigationController pushViewController:rootViewController animated:YES];
	[rootViewController release];
}


#pragma mark -
#pragma mark UITextField delegate methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	isEnteringText = YES;
	
	self.navigationItem.rightBarButtonItem.enabled = FALSE;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField endEditing:YES];
	
	isEnteringText = FALSE;
	
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
	
	CustomCell *cell = (CustomCell *)textField.superview.superview;

	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	
	[self updateObject:indexPath andName:textField.text];
	
	return YES;
}


#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController_ != nil) {
        return fetchedResultsController_;
    }
    
    /*
     Set up the fetched results controller.
    */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Idea" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
	
	// Filter for parent_id
	NSPredicate *predicate;
	
	if (currentObject) {
		predicate = [NSPredicate predicateWithFormat:@"parent == %@", currentObject];
	} else {
		predicate = [NSPredicate predicateWithFormat:@"parent == %@", [NSNull null]];
	}

	
	[fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	
	// For now I'm setting cacheName to nil as I don't think it will impact performances
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] 
															 initWithFetchRequest:fetchRequest 
															 managedObjectContext:self.managedObjectContext 
															 sectionNameKeyPath:nil 
															 cacheName:nil];
	
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    NSError *error = nil;
    if (![fetchedResultsController_ performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"We experienced an error. Please quit the application by pressing the Home button." 
													   delegate:self cancelButtonTitle:nil 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
    
    return fetchedResultsController_;
}    


#pragma mark -
#pragma mark Fetched results controller delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];

			[self performSelector:@selector(showKeyboard:)
								 withObject:newIndexPath
								 afterDelay:0.5];
			
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [fetchedResultsController_ release];
    [managedObjectContext_ release];
	[currentObject release];
    [super dealloc];
}


@end

