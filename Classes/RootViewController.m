//
//  RootViewController.m
//  Ideas
//
//  Created by Oscar Del Ben on 12/27/10.
//  Copyright 2010 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "RootViewController.h"
#import "IdeaDetailViewController.h"
#import "SettingsViewController.h"
#import "MailComposerViewController.h"
#import "Idea.h"
#import "ApplicationHelper.h"
#import "FlurryAPI.h"


@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)editCurrentObject:(id)sender;
- (void)showDetailView:(Idea *)aObject newIdea:(BOOL)newIdea;
- (void)showMailView;
- (void)showSettingsView;
- (void)configureTheme;
@end


@implementation RootViewController

@synthesize fetchedResultsController=fetchedResultsController_, managedObjectContext=managedObjectContext_;

@synthesize selectedIdea;
@synthesize mailComposerViewController;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self updateTitle];
	
	if (mailComposerViewController == nil) {
		mailComposerViewController = [[MailComposerViewController alloc] init];
		mailComposerViewController.rootViewController = self;
	}

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] 
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								  target:self 
								  action:@selector(insertNewObject)];
	
    self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];

	if (!selectedIdea) {
		UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] 
										  initWithTitle:@"Settings"
										  style:UIBarButtonItemStyleBordered
										  target:self 
										  action:@selector(showSettingsView)];
		
		self.navigationItem.leftBarButtonItem = optionsButton;
		
		[optionsButton release];
	}
	
	
	self.tableView.backgroundColor = [UIColor clearColor]; // Display image under the view
	
	// TODO separator color
	self.tableView.separatorColor = [UIColor colorWithRed:34/255.0 green:76/255.0 blue:72/255.0 alpha:1];
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	// toolbar
	if (selectedIdea) {
		self.navigationController.toolbarHidden = NO;
		
		UIBarButtonItem *flexibleSPace = [[UIBarButtonItem alloc]
										  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
										  target:nil 
										  action:nil];
		
		UIBarButtonItem *editItem = [[UIBarButtonItem alloc] 
									 initWithImage:[UIImage imageNamed:@"187-pencil.png"]
									 style:UIBarButtonSystemItemReply
									 target:self 
									 action:@selector(editCurrentObject:)];
		UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] 
									 initWithBarButtonSystemItem:UIBarButtonSystemItemTrash 
									 target:self 
									 action:@selector(showDeleteConfirmation:)];
		UIBarButtonItem *mailItem = [[UIBarButtonItem alloc] 
									   initWithImage:[UIImage imageNamed:@"18-envelope.png"]
									   style:UIBarButtonSystemItemReply
									   target:self 
									   action:@selector(showMailView)];
		
		self.toolbarItems = [NSArray arrayWithObjects:
							 flexibleSPace, 
							 editItem, 
							 flexibleSPace, 
							 mailItem, 
							 flexibleSPace, 
							 deleteItem, 
							 flexibleSPace, 
							 nil];
		
		[flexibleSPace release];
		[editItem release];
		[mailItem release];
		[deleteItem release];
	} else {
		self.navigationController.toolbarHidden = YES;
	}

	[self configureTheme];
}



// Implement viewWillAppear: to do additional setup before the view is presented.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	if (selectedIdea) {
		[self.navigationController setToolbarHidden:NO animated:NO];
	} else {
		[self.navigationController setToolbarHidden:YES animated:YES];
	}
}




 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}



#pragma mark -
#pragma mark Helper methods

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

- (void)configureTheme
{
	NSDictionary *theme = [ApplicationHelper theme];
	
	int r = [[theme objectForKey:@"red"] intValue];
	int g = [[theme objectForKey:@"green"] intValue];
	int b = [[theme objectForKey:@"blue"] intValue];
	
    // Override point for customization after application launch.
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
	self.navigationController.toolbar.tintColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
	
	UIDevice *device = [UIDevice currentDevice];
	
	if ([device userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		if ([self.tableView respondsToSelector:@selector(backgroundView)]) {
			self.tableView.backgroundView = nil;
			self.tableView.backgroundView = [[[UIView alloc] init] autorelease];
			self.tableView.backgroundColor = [UIColor clearColor];
		}
	}
	
	self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[theme objectForKey:@"background"]]];
		
	// This should be done only when the theme changed
	[self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
	NSDictionary *theme = [ApplicationHelper theme];
	
    Idea *idea = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.textLabel.text = [idea valueForKey:@"name"];
	cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
	
	cell.accessoryType = UIButtonTypeRoundedRect;
	
	cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
	cell.textLabel.numberOfLines = 0;
	
	cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[theme objectForKey:@"foreground"]]];


	/*
	UIView *selectedView = [[[UIView alloc] init] autorelease];
	selectedView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[theme objectForKey:@"selected"]]];
	cell.selectedBackgroundView = selectedView;
	*/
}

- (void)showDeleteConfirmation:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:@"Deleting this entry will also delete all of its children" 
								  delegate:self 
								  cancelButtonTitle:@"Cancel" 
								  destructiveButtonTitle:@"Confirm" 
								  otherButtonTitles:nil];
	
	[actionSheet showFromToolbar:self.navigationController.toolbar];
	
	[actionSheet release];
}

- (void)editCurrentObject:(id)sender
{
	[self showDetailView:selectedIdea newIdea:FALSE];
}

- (void)showDetailView:(Idea *)aObject newIdea:(BOOL)newIdea
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

- (void)showMailView
{
	mailComposerViewController.idea = selectedIdea;
	[mailComposerViewController showPicker];
}

- (void)showSettingsView
{
	SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
	settingsViewController.delegate = self;
	
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
	
	[self presentModalViewController:navigationController animated:YES];
	
	[settingsViewController release];
	[navigationController release];
}

#pragma mark -
#pragma mark SettingsViewControllerDelegate methods

- (void)reloadTheme
{
	[self configureTheme];
}

#pragma mark - IdeaDetailDelegate

- (void)ideaDetailViewController:(IdeaDetailViewController *)ideaDetailViewController didSaveIdea:(Idea *)idea
{
	[self.tableView reloadData];
	[self updateTitle];
	[self dismissModalViewControllerAnimated:YES];
}

- (void)ideaDetailViewControllerDidForceDelete:(IdeaDetailViewController *)ideaDetailViewController
{
	[self.tableView reloadData];
	[self updateTitle];
	[self dismissModalViewControllerAnimated:YES];
	
	[self.navigationController popViewControllerAnimated:NO];
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
	[FlurryAPI logEvent:@"INSERT_IDEA"];
	
	Idea *newIdea = [NSEntityDescription 
										 insertNewObjectForEntityForName:@"Idea" 
										 inManagedObjectContext:self.managedObjectContext];
	
	
	[newIdea setValue:[NSDate date] forKey:@"timeStamp"];
	
	if (selectedIdea) {
		[newIdea setValue:selectedIdea forKey:@"parent"];
	}
	
	[self showDetailView:newIdea newIdea:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Idea *idea = [self.fetchedResultsController objectAtIndexPath:indexPath];
	NSString *cellText = [idea valueForKey:@"name"];
	
	UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	
    return labelSize.height + 25;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
	rootViewController.managedObjectContext = self.managedObjectContext;
	
	Idea *idea = [self.fetchedResultsController objectAtIndexPath:indexPath];
	rootViewController.selectedIdea = idea;
	
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
	[mailComposerViewController release];
    [super dealloc];
}


@end

