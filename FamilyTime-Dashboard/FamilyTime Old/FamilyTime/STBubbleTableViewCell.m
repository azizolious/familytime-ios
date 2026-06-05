//
//  STBubbleTableViewCell.m
//  STBubbleTableViewCellDemo
//
//  Created by Cedric Vandendriessche on 24/08/13.
//  Copyright 2013 FreshCreations. All rights reserved.
//

#import "STBubbleTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat STBubbleWidthOffset = 30.0f;
const CGFloat STBubbleImageSize = 50.0f;

@implementation STBubbleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{	
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		_bubbleView = [[UIImageView alloc] initWithFrame:CGRectZero];
		_bubbleView.userInteractionEnabled = YES;
		[self.contentView addSubview:_bubbleView];
		
		self.textLabel.backgroundColor = [UIColor clearColor];
		self.textLabel.numberOfLines = 0;
		self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
		self.textLabel.textColor = [UIColor blackColor];
		self.textLabel.font = [UIFont systemFontOfSize:14.0];
		
		self.imageView.userInteractionEnabled = YES;
		self.imageView.layer.cornerRadius = 5.0;
		self.imageView.layer.masksToBounds = YES;
		
        // Defaults
		_selectedBubbleColor = STBubbleTableViewCellBubbleColorAqua;
    }
    
    return self;
}

- (void)updateFramesForAuthorType:(AuthorType)type
{
	[self setImageForBubbleColor:self.bubbleColor];
	
	CGFloat minInset = 0.0f;
	if([self.dataSource respondsToSelector:@selector(minInsetForCell:atIndexPath:)])
    {
		minInset = [self.dataSource minInsetForCell:self atIndexPath:[[self tableView] indexPathForCell:self]];
    }
	
	CGSize size;
	if(self.imageView.image)
    {
        size = [self.textLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - minInset - STBubbleWidthOffset - STBubbleImageSize - 8.0f, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:self.textLabel.font}
                                                 context:nil].size;
    }
	else
    {
        size = [self.textLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width - minInset - STBubbleWidthOffset, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:self.textLabel.font}
                                                 context:nil].size;
    }
	
	// You can always play with these values if you need to
	if(type == STBubbleTableViewCellAuthorTypeSelf)
	{
		if(self.imageView.image)
		{
			self.bubbleView.frame = CGRectMake(self.frame.size.width - (size.width + STBubbleWidthOffset) - STBubbleImageSize - 8.0f, self.frame.size.height - (size.height + 15.0f), size.width + STBubbleWidthOffset, size.height + 15.0f);
			self.imageView.frame = CGRectMake(self.frame.size.width - STBubbleImageSize - 5.0f, self.frame.size.height - STBubbleImageSize - 2.0f, STBubbleImageSize, STBubbleImageSize);
			self.textLabel.frame = CGRectMake(self.frame.size.width - (size.width + STBubbleWidthOffset - 10.0f) - STBubbleImageSize - 8.0f, self.frame.size.height - (size.height + 15.0f) + 6.0f, size.width + STBubbleWidthOffset - 23.0f, size.height);
		}
		else
		{
			self.bubbleView.frame = CGRectMake(self.frame.size.width - (size.width + STBubbleWidthOffset), 0.0f, size.width + STBubbleWidthOffset, size.height + 15.0f);
			self.imageView.frame = CGRectZero;
			self.textLabel.frame = CGRectMake(self.frame.size.width - (size.width + STBubbleWidthOffset - 10.0f), 6.0f, size.width + STBubbleWidthOffset - 23.0f, size.height);
		}
		
		self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		self.bubbleView.transform = CGAffineTransformIdentity;
	}
	else
	{
		if(self.imageView.image)
		{
			self.bubbleView.frame = CGRectMake(STBubbleImageSize + 8.0f, self.frame.size.height - (size.height + 15.0f), size.width + STBubbleWidthOffset, size.height + 15.0f);
			self.imageView.frame = CGRectMake(5.0, self.frame.size.height - STBubbleImageSize - 2.0f, STBubbleImageSize, STBubbleImageSize);
			self.textLabel.frame = CGRectMake(STBubbleImageSize + 8.0f + 16.0f, self.frame.size.height - (size.height + 15.0f) + 6.0f, size.width + STBubbleWidthOffset - 23.0f, size.height);
		}
		else
		{
			self.bubbleView.frame = CGRectMake(0.0f, 0.0f, size.width + STBubbleWidthOffset, size.height + 15.0f);
			self.imageView.frame = CGRectZero;
			self.textLabel.frame = CGRectMake(16.0f, 6.0f, size.width + STBubbleWidthOffset - 23.0f, size.height);
		}
		
		self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
		self.bubbleView.transform = CGAffineTransformIdentity;
		self.bubbleView.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
	}
}

- (void)setImageForBubbleColor:(BubbleColor)color
{
	self.bubbleView.image = [[UIImage imageNamed:@"bubble"] resizableImageWithCapInsets:UIEdgeInsetsMake(12.0f, 15.0f, 16.0f, 18.0f)];
}

- (void)layoutSubviews
{
	[self updateFramesForAuthorType:self.authorType];
}

- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    
    while(tableView)
    {
        if([tableView isKindOfClass:[UITableView class]])
        {
            return (UITableView *)tableView;
        }
        
        tableView = tableView.superview;
    }
    
    return nil;
}

#pragma mark - Setters

- (void)setAuthorType:(AuthorType)type
{
	_authorType = type;
	[self updateFramesForAuthorType:_authorType];
}

- (void)setBubbleColor:(BubbleColor)color
{
	_bubbleColor = color;
	[self setImageForBubbleColor:_bubbleColor];
}

@end
