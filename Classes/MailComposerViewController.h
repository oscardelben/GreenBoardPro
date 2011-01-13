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

@interface MailComposerViewController : UIViewController <MFMailComposeViewControllerDelegate> {
	id delegate;
	
	NSString *recipient;
	NSString *subject;
	NSString *content;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSString *recipient;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *content;

-(void)showPicker;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;

@end