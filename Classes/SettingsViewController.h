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
	id delegate;
}

@property (nonatomic, retain) id delegate;

@end


@protocol SettingsViewControllerDelegate <NSObject>

- (void)didChangeTheme;

@end
