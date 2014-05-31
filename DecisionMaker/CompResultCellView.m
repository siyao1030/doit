//
//  CompResultCellView.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 12/29/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "CompResultCellView.h"

@implementation CompResultCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withComparison:(Comparison *)comparison
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.comparison = comparison;
        
    }
    return self;
}

- (void)setUpWithComparison:(Comparison *)comparison
{
    self.comparison = comparison;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    //// label A Drawing
    CGRect textRect = CGRectMake(10, 10, 150, 16);
    [darkGreen setFill];
    [self.comparison.factorA.title drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica" size: 16] lineBreakMode: NSLineBreakByCharWrapping alignment: NSTextAlignmentLeft];
    
    
    //// label B Drawing
    CGRect text2Rect = CGRectMake(160, 10, 150, 16);
    [darkOrange setFill];
    [self.comparison.factorB.title drawInRect: text2Rect withFont: [UIFont fontWithName: @"Helvetica" size: 16] lineBreakMode: NSLineBreakByCharWrapping alignment: NSTextAlignmentRight];
    
    
    //// Rectangle A Drawing
    int widthA = 300*self.comparison.factorAWeight/100;
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(10, 32, widthA, 20)];
    if (self.comparison.factorA.isPro)
        [lightGreen setFill];
    else
        [darkGreen setFill];
    [rectanglePath fill];
    
    //// Rectangle B Drawing
    int widthB = 300*self.comparison.factorBWeight/100;
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(310-widthB, 32, widthB, 20)];
    if (self.comparison.factorB.isPro)
        [lightOrange setFill];
    else
        [darkOrange setFill];
    [rectangle2Path fill];
    
    
    //// weight A Drawing
    CGRect text3Rect = CGRectMake(15, 34, 30, 20);
    [bgColor setFill];
    NSString * factorAWeight = [NSString stringWithFormat:@"%d",(int)self.comparison.factorAWeight];
    [factorAWeight drawInRect: text3Rect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
    
    
    //// weight B Drawing
    CGRect text4Rect = CGRectMake(275, 34, 30, 20);
    [bgColor setFill];
    NSString * factorBWeight = [NSString stringWithFormat:@"%d",(int)self.comparison.factorBWeight];
    [factorBWeight drawInRect: text4Rect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentRight];
    
    

}


@end
