//
//  CustomCell.m
//  Ideas
//
//  Created by Oscar Del Ben on 12/27/10.
//  Copyright 2010 Dibi Store di Del Ben Oscar. All rights reserved.
//

#import "CustomCell.h"


@implementation CustomCell

@synthesize name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	[name release];
    [super dealloc];
}


@end
