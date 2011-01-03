//
//  IdeaDetailViewController.m
//  Ideas
//
//  Created by Oscar Del Ben on 1/1/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "IdeaDetailViewController.h"
#import "RootViewController.h"
#import "ApplicationHelper.h"


@implementation IdeaDetailViewController

@synthesize name;
@synthesize idea;
@synthesize newIdea;
@synthesize delegate;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	name.delegate = self;
	
	name.text = [idea valueForKey:@"name"];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Configure the navigation bar
    self.navigationItem.title = @"Add Entry";
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:53/255.0 green:161/255.0 blue:95/255.0 alpha:1];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-dark.png"]]];
	
	[name becomeFirstResponder];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}



#pragma mark -
#pragma mark UITextViewDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self save];
	return YES;
}

- (void)save
{
	if (name.text.length == 0) {
		[idea.managedObjectContext deleteObject:idea];
		[delegate ideaDetailViewControllerDidForceDelete:self];
		return;
	}
	[idea setValue:name.text forKey:@"name"];
	
	NSError *error = nil;
	if (![idea.managedObjectContext save:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
		[ApplicationHelper showApplicationError];
	}
	
	[name resignFirstResponder];

	[delegate ideaDetailViewController:self didSaveIdea:idea];
}

- (void)cancel
{
	if (newIdea) {
		[idea.managedObjectContext deleteObject:idea];
		
		NSError *error = nil;
		if (![idea.managedObjectContext save:&error]) {
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			
			[ApplicationHelper showApplicationError];
		}
	}
	
	
	[name resignFirstResponder];
	
	[delegate ideaDetailViewController:self didSaveIdea:nil];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.name = nil;
}


- (void)dealloc {
	[name release];
	[idea release];
	[delegate release];
    [super dealloc];
}


@end
