//
//  IdeaDetailViewController.h
//  Ideas
//
//  Created by Oscar Del Ben on 1/1/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IdeaDetailDelegate;

@class RootViewController;

@interface IdeaDetailViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *name;
	NSManagedObject *idea;
	BOOL newIdea;
	
	id <IdeaDetailDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) NSManagedObject *idea;
@property (nonatomic, assign) BOOL newIdea;

@property (nonatomic, retain) id <IdeaDetailDelegate> delegate;

- (void)save;
- (void)cancel;

@end


@protocol IdeaDetailDelegate <NSObject>

- (void)ideaDetailViewController:(IdeaDetailViewController *)ideaDetailViewController didSaveIdea:(NSManagedObject *)idea;

@end