//
//  TextFieldCell.h
//  Ideas
//
//  Created by Oscar Del Ben on 1/6/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TextFieldCell : UITableViewCell <UITextFieldDelegate> {
	IBOutlet UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

@end
