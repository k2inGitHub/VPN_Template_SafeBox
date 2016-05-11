//
//  SBTableViewCell.m
//  SafeBox
//
//  Created by SongYang on 14-3-18.
//  Copyright (c) 2014年 SongYang. All rights reserved.
//

#import "SBTableViewCell.h"
#import "KTUIFactory.h"

@implementation SBTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 30, 30)];
        [self.contentView addSubview:_icon];
        
        _title = [KTUIFactory customLabelWithFrame:CGRectMake(48, 5, 100, 18) text:@"" textColor:[UIColor blackColor] textFont:@"Arial-BoldMT" textSize:16 textAlignment:UITextAlignmentLeft];
        [self.contentView addSubview:_title];
        
        _subTitle = [KTUIFactory customLabelWithFrame:CGRectMake(48, 25, 60, 14) text:@"" textColor:[UIColor blackColor] textFont:@"Arial-BoldMT" textSize:12 textAlignment:UITextAlignmentLeft];
        [self.contentView addSubview:_subTitle];
        
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        float width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 768 : 320;
        
        UILabel *label = [KTUIFactory customLabelWithFrame:CGRectMake(5, 42, width, 2) text:[KTUIFactory stringForTableViewDotLine] textColor:[UIColor blackColor] textFont:@"Arial-BoldMT" textSize:6 textAlignment:UITextAlignmentLeft];
        [self.contentView addSubview:label];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}



@end
