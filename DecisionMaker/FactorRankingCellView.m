//
//  FactorRankingCellView.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 3/20/14.
//  Copyright (c) 2014 Siyao Xie. All rights reserved.
//

#import "FactorRankingCellView.h"

@implementation FactorRankingCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUpWithFactor:(Factor *)factor andTopFactor:(Factor *)top andIsA:(bool)isA
{
    self.factor = factor;
    self.top = top;
    self.isA = isA;
}

/*

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if (self.isA)
    {

        //[darkGreen setFill];
        //[self.factor.title drawInRect:textRect withFont: [UIFont fontWithName: @"Helvetica" size: 17] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];

        
        //// Rectangle A Drawing
        int widthA = 300*self.factor.finalScore/self.top.finalScore;
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(10, 10, widthA, 25)];
        if (self.factor.isPro)
            [lightGreen setFill];
        else
            [darkGreen setFill];
        [rectanglePath fill];
        
        
        //// label A Drawing
        CGRect textRect = CGRectMake(15, 10, 300, 16);
        //CGRect textRect = CGRectMake(10, 10, 300, 16);
        if (self.factor.isPro)
        {
            [darkGreen setFill];
            [self.factor.title drawInRect:textRect withFont: [UIFont fontWithName: @"Helvetica" size: 17] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
        }
        else
        {
            [bgColor setFill];
            [self.factor.title drawInRect:textRect withFont: [UIFont fontWithName: @"Helvetica" size: 17] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
        }

    }
    else
    {
        
        
        //// Rectangle A Drawing
        int widthA = 300*self.factor.finalScore/self.top.finalScore;
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(10, 10, widthA, 25)];
        if (self.factor.isPro)
            [lightOrange setFill];
        else
            [darkOrange setFill];
        [rectanglePath fill];
        
        //// label A Drawing
        CGRect textRect = CGRectMake(15, 10, 300, 16);
        //CGRect textRect = CGRectMake(10, 10, 300, 16);
        if (self.factor.isPro)
            [darkOrange setFill];
        else
            [bgColor setFill];
        //[darkOrange setFill];
        [self.factor.title drawInRect:textRect withFont: [UIFont fontWithName: @"Helvetica" size: 17] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];

    }
    
}


*/
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    if (self.isA)
    {
        //// label A Drawing
        CGRect textRect = CGRectMake(10, 10, 300, 16);
        [darkGreen setFill];
        [self.factor.title drawInRect:textRect withFont: [UIFont fontWithName: @"Helvetica" size: 17] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
        
        
        //// Rectangle A Drawing
        int widthA = 300*self.factor.finalScore/self.top.finalScore;
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(10, 32, widthA, 20)];
        if (self.factor.isPro)
            [lightGreen setFill];
        else
            [darkGreen setFill];
        [rectanglePath fill];
        
        /*
        
         //// weight A Drawing
         CGRect text3Rect = CGRectMake(15, 34, 30, 20);
         [bgColor setFill];
         NSString * factorAWeight = [NSString stringWithFormat:@"%f",self.factor.finalScore];

         //NSString * factorAWeight = [NSString stringWithFormat:@"%d",(int)roundf(self.factor.finalScore)];
         [factorAWeight drawInRect: text3Rect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
        */
        
    }
    else
    {
        //// label A Drawing
        CGRect textRect = CGRectMake(10, 10, 300, 16);
        [darkOrange setFill];
        [self.factor.title drawInRect:textRect withFont: [UIFont fontWithName: @"Helvetica" size: 17] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
        
        
        //// Rectangle A Drawing
        int widthA = 300*self.factor.finalScore/self.top.finalScore;
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(10, 32, widthA, 20)];
        if (self.factor.isPro)
            [lightOrange setFill];
        else
            [darkOrange setFill];
        [rectanglePath fill];
        
        /*
         //// weight A Drawing
         CGRect text3Rect = CGRectMake(15, 34, 30, 20);
         [bgColor setFill];
         NSString * factorAWeight = [NSString stringWithFormat:@"%f",self.factor.finalScore];
         //NSString * factorAWeight = [NSString stringWithFormat:@"%d",(int)roundf(self.factor.finalScore)];
         [factorAWeight drawInRect: text3Rect withFont: [UIFont fontWithName: @"Helvetica-Bold" size: 13] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentLeft];
        */
        
    }
    
}



@end
