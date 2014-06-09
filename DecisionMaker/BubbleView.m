//
//  BubbleView.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 12/3/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "BubbleView.h"

@implementation BubbleView

#define darkGreen [UIColor colorWithRed:103/255.0 green:192/255.0 blue:145/255.0 alpha:1]
#define lightGreen [UIColor colorWithRed:102/255.0 green:248/255.0 blue:167/255.0 alpha:0.6]

#define darkOrange [UIColor colorWithRed:248/255.0 green:178/255.0 blue:3/255.0 alpha:1]
#define lightOrange [UIColor colorWithRed:255.0/255.0 green:210/255.0 blue:0/255.0 alpha:0.6]


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andSizeFactor:(float)factor
{
    self = [super initWithFrame:frame];
    self.factor = factor;
    return self;
    
}


-(void)setUpWithItemALabel:(NSString *)labelA andASize:(int)sizeA andItemBLabel: (NSString *)labelB andBSize:(int)sizeB andShouldDisplaySize:(BOOL)shouldDisplay
{
    self.sizeA = sizeA;
    self.labelA= labelA;
    self.sizeB = sizeB;
    self.labelB= labelB;
    self.displaySize = shouldDisplay;
    self.isProA = -1;
    self.isProB = -1;
    
}


-(void)setUpWithItemALabel:(NSString *)labelA andASize:(int)sizeA andisPro:(BOOL)isProA andItemBLabel: (NSString *)labelB andBSize:(int)sizeB  andisPro:(BOOL)isProB andShouldDisplaySize:(BOOL)shouldDisplay
{
    self.sizeA = sizeA;
    self.labelA= labelA;
    self.isProA = isProA;
    self.sizeB = sizeB;
    self.labelB= labelB;
    self.isProB = isProB;
    self.displaySize = shouldDisplay;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // gets the coordinats of the touch with respect to the specified view.
    CGPoint touchPoint = [touch locationInView:self];
    
    // test the coordinates however you wish,
    // within circle A
    int radiusA = 170*(self.sizeA/100.0)/2;
    float Axdiff = fabsf(touchPoint.x-160);
    float Aydiff = fabsf(touchPoint.y-(200*self.factor-radiusA));
    
    int radiusB = 170*(self.sizeB/100.0)/2;
    float Bxdiff = fabsf(touchPoint.x-160);
    float Bydiff = fabsf(touchPoint.y-(200*self.factor+radiusB));
    
    if (Axdiff*Axdiff + Aydiff*Aydiff <=radiusA*radiusA)
    {
        [self.target performSelector:self.increaseA withObject:nil];
        //[self setNeedsDisplay];
    }
    
    if (Bxdiff*Bxdiff + Bydiff*Bydiff <=radiusB*radiusB)
    {
        [self.target performSelector:self.increaseB withObject:nil];
        //[self setNeedsDisplay];
    }
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.


- (void)drawRect:(CGRect)rect
{
    float d = 170*self.factor;
    float f = 60*self.factor;
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Abstracted Attributes
    NSString* sizeContentA = [NSString stringWithFormat:@"%d",self.sizeA];
    NSString* sizeContentB = [NSString stringWithFormat:@"%d",self.sizeB];
    int diameterA = d*(self.sizeA/100.0);
    int diameterB = d*(self.sizeB/100.0);
    int sizeFontA = f*(self.sizeA/100.0);
    int sizeFontB = f*(self.sizeB/100.0);
    
    if (diameterA < 17) {
        diameterA = 17;
        diameterB = d*0.9;
        sizeFontA = 6;
        sizeFontB = f*0.9;
    }
    if (diameterB < 17)
    {
        diameterA = d*0.9;
        diameterB = 17;
        sizeFontA = f*0.9;
        sizeFontB = 6;
    }


    
    //// Oval Drawing
    CGRect ovalRect = CGRectMake(160-diameterA/2, 200*self.factor-diameterA, diameterA, diameterA);
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: ovalRect];
    UIColor * colorGreen;
    if (self.isProA == NO)
        colorGreen = darkGreen;
    else
        colorGreen = lightGreen;
    
    [colorGreen setFill];
    [ovalPath fill];
    [colorGreen setStroke];
    ovalPath.lineWidth = 0.5;
    [ovalPath stroke];
    [fillColor setFill];
    [sizeContentA drawInRect: CGRectInset(ovalRect, 0, (diameterA-sizeFontA)/2) withFont: [UIFont fontWithName: @"HelveticaNeue-Light"  size: sizeFontA] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    
    //// Text 1 Drawing
    
    CGRect text1Rect = CGRectMake(5, 200*self.factor-diameterA-39, 310, 39);

    UIFont* font = [self getFontForString:self.labelA toFitInRect:text1Rect seedFont:[UIFont systemFontOfSize:30]];
    text1Rect = CGRectMake(5, 200*self.factor-diameterA-39+(30-font.pointSize), 310, 39);
    // code for breaking into two lines
    //CGSize constraint = CGSizeMake(300,NSUIntegerMax);
    //CGSize size = [self.labelA sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];

    [darkGreen setFill];
    //CGRect text1Rect = CGRectMake((320-size.width)/2, 200-diameterA-size.height-7, size.width, size.height);
    [self.labelA drawInRect: text1Rect withFont: font lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    
    // Construct your label

    //// Text 2 Drawing
    CGRect text2Rect = CGRectMake(5, 200*self.factor+diameterB, 310, 39);
    UIFont* font2 = [self getFontForString:self.labelB toFitInRect:text2Rect seedFont:[UIFont systemFontOfSize:30]];
    
    [darkOrange setFill];
    //CGRect text1Rect = CGRectMake((320-size.width)/2, 200-diameterA-size.height-7, size.width, size.height);
    [self.labelB drawInRect: text2Rect withFont: font2 lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];

    
    //// Oval 2 Drawing
    CGRect oval2Rect = CGRectMake(160-diameterB/2, 200*self.factor, diameterB, diameterB);
    UIBezierPath* oval2Path = [UIBezierPath bezierPathWithOvalInRect: oval2Rect];
    
    UIColor * colorOrange;
    if (self.isProB == NO)
        colorOrange = darkOrange;
    else
        colorOrange = lightOrange;
    
    [colorOrange setFill];
    [oval2Path fill];
    [colorOrange setStroke];
    oval2Path.lineWidth = 0.5;
    [oval2Path stroke];
    [fillColor setFill];
    [sizeContentB drawInRect: CGRectInset(oval2Rect, 0, (diameterB-sizeFontB)/2) withFont: [UIFont fontWithName: @"HelveticaNeue-Light"  size: sizeFontB] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    
    

    

}


-(UIFont*)getFontForString:(NSString*)string
               toFitInRect:(CGRect)rect
                  seedFont:(UIFont*)seedFont
{
    UIFont* returnFont = seedFont;
    CGSize stringSize = [string sizeWithFont:returnFont];
    
    while(stringSize.width > rect.size.width){
        returnFont = [UIFont systemFontOfSize:returnFont.pointSize -1];
        stringSize = [string sizeWithFont:returnFont];
    }
    
    return returnFont;
}

@end
