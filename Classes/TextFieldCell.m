//
//  TextFieldCell.m
//  Ideas
//
//  Created by Oscar Del Ben on 1/6/11.
//  Copyright 2011 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "TextFieldCell.h"


@implementation TextFieldCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        textField.delegate = self;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[textField dealloc];
    [super dealloc];
}


@end
