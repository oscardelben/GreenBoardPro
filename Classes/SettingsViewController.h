//
//  SettingsViewController.h
//  Ideas
//
//  Created by Oscar Del Ben on 1/5/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;

@interface SettingsViewController : UITableViewController {
	RootViewController *rootViewController;
}

@property (nonatomic, retain) RootViewController *rootViewController;

@end
