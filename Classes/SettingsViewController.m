//
//  SettingsViewController.m
//  Ideas
//
//  Created by Oscar Del Ben on 1/5/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "SettingsViewController.h"
#import "RootViewController.h"
#import "ApplicationHelper.h"

@interface SettingsViewController(PrivateMethods)

- (UITableViewCell *)themeCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)emailCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end


@implementation SettingsViewController

@synthesize rootViewController;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *theme = [ApplicationHelper theme];
	
	// Configure the navigation bar
    self.navigationItem.title = @"Settings";
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
	
	int r = [[theme objectForKey:@"red"] intValue];
	int g = [[theme objectForKey:@"green"] intValue];
	int b = [[theme objectForKey:@"blue"] intValue];
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

- (void)dismiss
{
	[self dismissModalViewControllerAnimated:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    // return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{	
	return [[ApplicationHelper themes] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"ThemeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	NSString *themeID = [NSString stringWithFormat:@"theme%d", indexPath.row + 1];
	
	NSDictionary *cellTheme = [[ApplicationHelper themes] objectForKey:themeID];
	
	NSString *name = [cellTheme objectForKey:@"name"];
	cell.textLabel.text = name;
	
	// Display an indicator if it's the one in use
	NSString *currentThemeName = [[ApplicationHelper theme] objectForKey:@"name"];
	
	if ([currentThemeName isEqualToString:name]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	// Set the background color
	
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-white.png"]];
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Theme";
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	NSString *themeID = [NSString stringWithFormat:@"theme%d", indexPath.row+1];
	
	[ApplicationHelper saveTheme:themeID];
	
	[rootViewController reloadTheme];
	
	[self dismiss];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[rootViewController release];
    [super dealloc];
}


@end

