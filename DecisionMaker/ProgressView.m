//
//  ProgressView.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 3/22/14.
//  Copyright (c) 2014 Siyao Xie. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setUpWithDecision:(Decision *)decision;
{
    self.decision = decision;

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    

    

    
    //// Draw the rest of rectangle

    
    //// Rectangle A Drawing
    UIBezierPath* restPath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 320, 16)];
    [darkPink setFill];
    [restPath fill];
    
    //// Rectangle A Drawing
    int acount = [self.decision.choices[0] factors].count;
    int bcount = [self.decision.choices[1] factors].count;
    int totalComps = MIN(acount*bcount, 3*(int)MAX(acount, bcount));
    int widthA = self.frame.size.width*(self.decision.numOfCompsDone)/totalComps;
    NSLog(@"comps done: %d, widthA: %d", self.decision.numOfCompsDone, widthA);
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, widthA, 16)];
    [lightPink setFill];
    [rectanglePath fill];
    

    /*
    
     //// comps done drawing
     CGRect textRect = CGRectMake(widthA-10, 1, 15, 20);
     [bgColor setFill];
     NSString * compsDone = [NSString stringWithFormat:@"%d",(int)(self.decision.numOfCompsDone+1)];
     [compsDone drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
    */

}


@end
