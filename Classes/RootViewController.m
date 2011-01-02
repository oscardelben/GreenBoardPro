//
//  RootViewController.m
//  Ideas
//
//  Created by Oscar Del Ben on 12/27/10.
//  Copyright 2010 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "RootViewController.h"
#import "IdeaDetailViewController.h"
#import "UIButton+Glossy.h"
#import "ApplicationHelper.h"


@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)editCurrentObject:(id)sender;
- (void)showDetailView:(NSManagedObject *)aObject newIdea:(BOOL)newIdea;
- (void)setupTableView;
@end


@implementation RootViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

@synthesize selectedIdea;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self updateTitle];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								  target:self 
								  action:@selector(insertNewObject)];
	
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
	
	[self setupTableView];
}



// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}



/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}
*/


#pragma mark -
#pragma mark Helper methods

- (UIButton *)deleteButton
{
	UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	deleteButton.frame = CGRectMake(10, 60, 300, 34);
	
	UIColor *redColor = [UIColor colorWithRed:.65 green:.05 blue:.05 alpha:1];
	
	[deleteButton setBackgroundToGlossyRectOfColor:redColor withBorder:YES forState:UIControlStateNormal];
	
	[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	[deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[deleteButton setTitleShadowColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1] forState:UIControlStateNormal];
	[deleteButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
	[deleteButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
	
	[deleteButton addTarget:self action:@selector(showDeleteConfirmation:) forControlEvents:UIControlEventTouchUpInside];
	
	return deleteButton;
}

- (UIButton *)editButton
{
	UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	
	editButton.frame = CGRectMake(10, 10, 300, 34);
	
	UIColor *greenColor = [UIColor colorWithRed:.05 green:.65 blue:.05 alpha:1];
	
	[editButton setBackgroundToGlossyRectOfColor:greenColor withBorder:YES forState:UIControlStateNormal];
	
	[editButton setTitle:@"Edit" forState:UIControlStateNormal];
	[editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[editButton setTitleShadowColor:[UIColor colorWithRed:.25 green:.25 blue:.25 alpha:1] forState:UIControlStateNormal];
	[editButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
	[editButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
	
	[editButton addTarget:self action:@selector(editCurrentObject:) forControlEvents:UIControlEventTouchUpInside];
	
	return editButton;
}

- (void)setupTableView {
	if (!selectedIdea) {
		return;
	}
	
	// http://www.mlsite.net/blog/?p=232
	
	UIView *footerContainerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)] autorelease];
	
	[footerContainerView addSubview:[self editButton]];
	[footerContainerView addSubview:[self deleteButton]];
	
	self.tableView.tableFooterView = footerContainerView;
}


- (void)updateTitle
{
	
	NSString *countText;
	if ([[self.fetchedResultsController fetchedObjects] count] > 0) {
		countText = [NSString stringWithFormat:@" (%d)", [[self.fetchedResultsController fetchedObjects] count]];
	} else {
		countText = @"";
	}

	
	if (selectedIdea) {
		self.navigationItem.title = [NSString stringWithFormat:@"%@%@",
									 [selectedIdea valueForKey:@"name"], countText];
	} else {
		self.navigationItem.title = [NSString stringWithFormat:@"Ideas%@", countText];
	}
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.textLabel.text = [managedObject valueForKey:@"name"];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
	
	cell.accessoryType = UIButtonTypeRoundedRect;
	
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.textLabel.numberOfLines = 0;
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

- (void)editCurrentObject:(id)sender
{
	[self showDetailView:selectedIdea newIdea:FALSE];
}

- (void)showDetailView:(NSManagedObject *)aObject newIdea:(BOOL)newIdea
{
	IdeaDetailViewController *detailViewController = [[IdeaDetailViewController alloc] initWithNibName:@"IdeaDetailViewController" bundle:nil];
	detailViewController.idea = aObject;
	detailViewController.delegate = self;
	detailViewController.newIdea = newIdea;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
	
	[self presentModalViewController:navigationController animated:YES];

	[detailViewController release];
	[navigationController release];
}

#pragma mark - IdeaDetailDelegate

- (void)ideaDetailViewController:(IdeaDetailViewController *)ideaDetailViewController didSaveIdea:(NSManagedObject *)idea
{
	[self.tableView reloadData];
	[self updateTitle];
	[self dismissModalViewControllerAnimated:YES];
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
	NSManagedObject *newManagedObject = [NSEntityDescription 
										 insertNewObjectForEntityForName:@"Idea" 
										 inManagedObjectContext:self.managedObjectContext];
	
	
	[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
	
	if (selectedIdea) {
		[newManagedObject setValue:selectedIdea forKey:@"parent"];
	}
	
	[self showDetailView:newManagedObject newIdea:YES];
}

- (void)deleteCurrentObject
{
	
	NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
	
	[context deleteObject:selectedIdea];
	
	NSError *error = nil;
	if (![context save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		
		[ApplicationHelper showApplicationError];
	}
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {

    // Prevent new objects being added when in editing mode.
    [super setEditing:(BOOL)editing animated:(BOOL)animated];
    self.navigationItem.rightBarButtonItem.enabled = !editing;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self.fetchedResultsController fetchedObjects] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TableViewCell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


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
            
			[ApplicationHelper showApplicationError];
        }
    }   
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (!selectedIdea) {
		return nil;
	}
	
	return [selectedIdea valueForKey:@"name"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSString *cellText = [managedObject valueForKey:@"name"];
	
	UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
    return labelSize.height + 20;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	rootViewController.managedObjectContext = self.managedObjectContext;
	
	NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
	rootViewController.selectedIdea = managedObject;
	
	[self.navigationController pushViewController:rootViewController animated:YES];
	[rootViewController release];
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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
	
	// Filter for parent_id
	NSPredicate *predicate;
	
	if (selectedIdea) {
		predicate = [NSPredicate predicateWithFormat:@"parent == %@", selectedIdea];
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
        
		[ApplicationHelper showApplicationError];
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
    NSLog(@"Foo");
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
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self updateTitle]; // reload title after deletion
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
	[selectedIdea release];
    [super dealloc];
}


@end

