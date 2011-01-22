//
//  SettingsViewController.m
//  Ideas
//
//  Created by Oscar Del Ben on 1/5/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "SettingsViewController.h"
#import "RootViewController.h"
#import "MailComposerViewController.h"
#import "ApplicationHelper.h"

@interface SettingsViewController (PrivateMethods)
- (void)dismiss;
@end


@implementation SettingsViewController

@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (mailComposerViewController == nil) {
		mailComposerViewController = [[MailComposerViewController alloc] init];
		mailComposerViewController.delegate = self;
		mailComposerViewController.recipient = @"info@oscardelben.com";
		mailComposerViewController.subject = @"[Green Board Pro] Feedback";
	}

	// Configure the navigation bar
	
    self.navigationItem.title = @"Settings";
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
	
	self.navigationController.navigationBar.tintColor = [ApplicationHelper navigationColor];
	
	
	// configure table
	
	tableModel = [[SCTableViewModel alloc] initWithTableView:self.tableView withViewController:self];
	
	// Themes
	
	SCTableViewSection *themesSection = [SCTableViewSection sectionWithHeaderTitle:@"Themes"];
	[tableModel addSection:themesSection];
	
	for (int i = 0; i < [[ApplicationHelper themes] count]; i++)
	{
		NSString *themeID = [NSString stringWithFormat:@"theme%d", i+1];
		NSDictionary *theme = [[ApplicationHelper themes] objectForKey:themeID];
		NSString *name = [theme objectForKey:@"name"];
		
		SCLabelCell *cell = [SCLabelCell cellWithText:name];
		
		NSString *currentThemeName = [[ApplicationHelper theme] valueForKey:@"name"];
		
		if ([name isEqualToString:currentThemeName])
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		
		
		[themesSection addCell:cell];
	}
	
	// Defaults settings
	
	SCTableViewSection *defaultsSection = [SCTableViewSection sectionWithHeaderTitle:@"Defaults"];
	[tableModel addSection:defaultsSection];
	
	SCTextFieldCell *textFieldCell = [SCTextFieldCell cellWithText:@"Email" withPlaceholder:@"enter email" 
													  withBoundKey:@"email" withTextFieldTextValue:[ApplicationHelper recipient]];

	textFieldCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	
	[defaultsSection addCell:textFieldCell];
	
	// Feedback
	
	SCTableViewSection *supportSection = [SCTableViewSection sectionWithHeaderTitle:@"Support"];
	[tableModel addSection:supportSection];
	
	SCLabelCell *feedbackCell = [SCLabelCell cellWithText:@"Send feedback"];
	feedbackCell.label.numberOfLines = 0;
	feedbackCell.label.lineBreakMode = UILineBreakModeWordWrap;
	[supportSection addCell:feedbackCell];
	
}

#pragma mark -
#pragma mark SCTableViewModelDelegate methods

- (void)tableViewModel:(SCTableViewModel *) tableViewModel valueChangedForRowAtIndexPath:(NSIndexPath *) indexPath
{
	if (indexPath.section == 1)
	{
		[ApplicationHelper setRecipient:[tableModel.modelKeyValues valueForKey:@"email"]];
	}
}

- (void)tableViewModel:(SCTableViewModel *) tableViewModel didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
	switch (indexPath.section) {
		case 0:
		{
			NSString *themeID = [NSString stringWithFormat:@"theme%d", indexPath.row+1];
			
			[ApplicationHelper saveTheme:themeID];
			
			[delegate reloadTheme];
			
			[self dismiss];
			break;
		}
		case 2:
			[mailComposerViewController showPicker];
			break;
	}
}

#pragma mark -
#pragma mark Helper methods

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


- (void)dealloc {
	[delegate release];
	[tableModel release];
    [super dealloc];
}


@end

