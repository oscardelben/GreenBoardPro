//
//  MailComposerViewController.h
//  Ideas
//
//  Created by Oscar Del Ben on 1/5/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class RootViewController;
@class Idea;

@interface MailComposerViewController : UIViewController <MFMailComposeViewControllerDelegate> {
	RootViewController *rootViewController;
	Idea *idea;
}

@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) Idea *idea;

-(IBAction)showPicker;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end
