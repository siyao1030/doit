//
//  Decision.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/22/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "Decision.h"

@implementation Decision

-(id)initWithChoiceA:(Choice *)choice1 andChoiceB:(Choice *)choice2 andTitle:(NSString *)title
{
    self.title = title;
    self.choices = [[NSMutableArray alloc]initWithObjects:choice1, choice2,nil];
    self.comparisons = [[NSMutableArray alloc]init];
    //self.Ascore = 0.0;
    //self.Bscore = 0.0;
    self.AcontributionScore = 0.0;
    self.BcontributionScore = 0.0;
    self.Arate = 0.0;
    self.Brate = 0.0;
    //self.AResult = 0;
    //self.BResult = 0;
    self.round = 0;
    self.rowid = -1;
    self.numOfCompsDone = 0;
    return self;
}

-(void)resetStats
{
    /*
    self.AcontributionScore = 0.0;
    self.BcontributionScore = 0.0;
    self.round = 1;
    self.numOfCompsDone = 0;
    
    for (Comparison * comp in self.comparisons)
    {
        [comp resetStats];
    }
    
    
    [(Choice *)self.choices[0] resetStats];
    [(Choice *)self.choices[1] resetStats];
     */
    //self.numOfCompsDone = 0;

    
    
    self.tempDecision = [self copy];
    self.tempDecision.AcontributionScore = 0.0;
    self.tempDecision.BcontributionScore = 0.0;
    self.tempDecision.round = 1;
    self.tempDecision.numOfCompsDone = 0;

    for (Comparison * comp in self.tempDecision.comparisons)
    {
        [comp resetStats];
    }
    
    
    [(Choice *)self.tempDecision.choices[0] resetStats];
    [(Choice *)self.tempDecision.choices[1] resetStats];
    
    
    
    [self.history addObject:[self copy]];
    
}

-(id)copyWithZone:(NSZone *)zone
{
    Decision *copy = [[Decision alloc] init];
    copy.title = [self.title copyWithZone:zone];
    copy.choices = [self.choices copyWithZone:zone];
    copy.comparisons = [self.comparisons copyWithZone:zone];
    
    copy.AcontributionScore = self.AcontributionScore;
    copy.BcontributionScore = self.BcontributionScore;
    copy.Arate = self.Arate;
    copy.Brate = self.Brate;
    copy.title = [self.title copyWithZone:zone];
    
    copy.round = self.round;
    copy.rowid = self.rowid;
    copy.numOfCompsDone = self.numOfCompsDone;
    
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.choices forKey:@"choices"];
    [aCoder encodeObject:self.comparisons forKey:@"comparisons"];
    //[aCoder encodeFloat:self.Ascore forKey:@"Ascore"];
    //[aCoder encodeFloat:self.Bscore forKey:@"Bscore"];
    [aCoder encodeFloat:self.Arate forKey:@"Arate"];
    [aCoder encodeFloat:self.Brate forKey:@"Brate"];
    //[aCoder encodeInt:self.AResult forKey:@"AResult"];
    //[aCoder encodeInt:self.BResult forKey:@"BResult"];
    [aCoder encodeInt:self.stage forKey:@"stage"];
    [aCoder encodeInt:self.round forKey:@"round"];
    [aCoder encodeInt:self.numOfCompsDone forKey:@"numOfCompsDone"];
    

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.choices = [aDecoder decodeObjectForKey:@"choices"];
        self.comparisons = [aDecoder decodeObjectForKey:@"comparisons"];
        //self.Ascore = [aDecoder decodeFloatForKey:@"Ascore"];
        //self.Bscore = [aDecoder decodeFloatForKey:@"Bscore"];
        self.Arate = [aDecoder decodeFloatForKey:@"Arate"];
        self.Brate = [aDecoder decodeFloatForKey:@"Brate"];
        //self.AResult = [aDecoder decodeIntForKey:@"AResult"];
        //self.BResult = [aDecoder decodeIntForKey:@"BResult"];
        self.stage = [aDecoder decodeIntForKey:@"stage"];
        self.round = [aDecoder decodeIntForKey:@"round"];
        self.numOfCompsDone = [aDecoder decodeIntForKey:@"numOfCompsDone"];
    }
    return self;
}


-(void)changeTitle:(NSString *)title
{
    self.title = title;
}

-(void)addComparison:(Comparison *)comparison
{
    [self.comparisons addObject:comparison];
}


-(void)convergeNetworkScore
{
    
    for (Factor * factor in [[self.choices objectAtIndex:0] factors])
    {
        factor.score = 10.0;
    }
    for (Factor * factor in [[self.choices objectAtIndex:1] factors])
    {
        factor.score = 10.0;
    }
    
    [self updateNetworkScore];
    
    int oldRate = self.Arate;
    int newRate = 0;
    int count = 0;
    while (count<10) {
        if (oldRate == newRate)
            count++;
        oldRate = self.Arate;
        [self updateNetworkScore];
        newRate = self.Arate;
    }
    
}


-(void)updateNetworkScore
{
    NSMutableArray * factorsA = [[self.choices objectAtIndex:0] factors];
    NSMutableArray * factorsB = [[self.choices objectAtIndex:1] factors];
    self.AcontributionScore = 0.0;
    self.BcontributionScore = 0.0;
    
    float a = 0;
    float b = 0;
    
    //accumulate each factor's tempScore using contributions
    
    float ad = 0;
    float bd = 0;
    //NSLog(@"A:");
    for (Factor * factorA in factorsA)
    {
        for (NSArray * compared in factorA.comparedWith)
        {
            Factor * factorB = compared[0];
            float factorBScore =((NSNumber *)compared[1]).floatValue;
            float temp = factorA.score*(factorBScore/factorA.totalContribution);
            // factor B gets a portion
            factorB.tempScore += (factorBScore/100)*temp;
            // factor A keeps the rest
            factorA.tempScore+=(1-factorBScore/100)*temp;
            // for normalization later: denominator
            bd+= (factorBScore/100)*temp;
            ad+=(1-factorBScore/100)*temp;
        }
        
        
    }
    
    //NSLog(@"B:");
    for (Factor * factorB in factorsB)
    {
        for (NSArray * compared in factorB.comparedWith)
        {
            Factor * factorA = compared[0];
            float factorAScore =((NSNumber *)compared[1]).floatValue;
            float temp = factorB.score*(factorAScore/factorB.totalContribution);
            factorA.tempScore += (factorAScore/100)*temp;
            factorB.tempScore += (1-factorAScore/100)*temp;
            // for normalization later: denominator
            ad += (factorAScore/100)*temp;
            bd += (1-factorAScore/100)*temp;
        }
        
    }
    
    //add up and update each factor's score and reset tempScore
    NSLog(@"A:");
    for (Factor * factor in factorsA)
    {

        if (factor.comparedWith.count >0)
        {
            factor.score = factor.tempScore;
            factor.finalScore = factor.score/factor.comparedWith.count;
            //factor.finalScore =factor.averageWeight*factor.score;
            if ([factor isPro])
                a+=factor.finalScore;
                //a+=factor.score/ad*factor.averageWeight;
            //self.AcontributionScore += factor.score;
            else
                a-=factor.finalScore;
                //a-=factor.score/ad*factor.averageWeight;
            //self.AcontributionScore -= factor.score;
            factor.tempScore = 0.0;
        }
        else
        {
            if ([factor isPro])
                a+=factor.finalScore;
            else
                a-=factor.finalScore;
        }
        //NSLog(@"combining: %@, %f -> %f", factor.title, factor.finalScore, a);
        
    }
    self.AcontributionScore = a;
    
    
    NSLog(@"B:");
    for (Factor * factor in factorsB)
    {
        if (factor.comparedWith.count >0)
        {
            factor.score = factor.tempScore;
            factor.finalScore = factor.score/factor.comparedWith.count;
            //factor.finalScore =factor.averageWeight*factor.score;
            if ([factor isPro])
                b+=factor.finalScore;
                ///bd*factor.averageWeight;
            //self.BcontributionScore += factor.score;
            else
                b-=factor.finalScore;
                ///bd*factor.averageWeight;
            //self.BcontributionScore -= factor.score;
            factor.tempScore = 0.0;
        }
        else
        {
            if ([factor isPro])
                b+=factor.finalScore;
            else
                b-=factor.finalScore;
        }
        //NSLog(@"combining: %@, %f -> %f", factor.title, factor.finalScore, b);

    }
    self.BcontributionScore = b;
    
    //NSLog(@"outside: %f vs %f", self.AcontributionScore, self.BcontributionScore);

    
    if (self.AcontributionScore <0 && self.BcontributionScore <0)
    {
        
        //NSLog(@"before : %f vs %f", self.AcontributionScore, self.BcontributionScore);
        float swapTemp = self.AcontributionScore;
        self.AcontributionScore = -self.BcontributionScore;
        self.BcontributionScore = -swapTemp;
        //NSLog(@"after: %f vs %f", self.AcontributionScore, self.BcontributionScore);
    }
    else if (self.AcontributionScore<0 || self.BcontributionScore<0)
    {
        float normalizingFactor = 2*MIN(self.AcontributionScore, self.BcontributionScore);
        self.AcontributionScore-=normalizingFactor;
        self.BcontributionScore-=normalizingFactor;
    }
    
    
    
    if (self.AcontributionScore == self.BcontributionScore)
    {
        self.Arate = 50;
        self.Brate = 50;
    }
    else
    {
        self.Arate = self.AcontributionScore/(self.AcontributionScore+self.BcontributionScore);
        self.Brate = self.BcontributionScore/(self.AcontributionScore+self.BcontributionScore);
        
        self.Arate = (int)roundf(self.Arate*100);
        self.Brate = (int)roundf(self.Brate*100);
        
    }

}


/*
 -(void)updateContributionScore
 {
 NSMutableArray * factorsA = [[self.choices objectAtIndex:0] factors];
 NSMutableArray * factorsB = [[self.choices objectAtIndex:1] factors];
 self.AcontributionScore = 0.0;
 self.BcontributionScore = 0.0;
 
 float a = 0;
 float b = 0;
 
 //accumulate each factor's tempScore using contributions
 
 float ad = 0;
 float bd = 0;
 NSLog(@"A:");
 for (Factor * factorA in factorsA)
 {
 for (NSArray * compared in factorA.comparedWith)
 {
 Factor * factorB = compared[0];
 factorB.tempScore += factorA.score*(((NSNumber *)compared[1]).floatValue/factorA.totalContribution);
 bd+=factorA.score*(((NSNumber *)compared[1]).floatValue/factorA.totalContribution);
 }
 
 }
 
 NSLog(@"B:");
 for (Factor * factorB in factorsB)
 {
 for (NSArray * compared in factorB.comparedWith)
 {
 Factor * factorA = compared[0];
 factorA.tempScore += factorB.score*(((NSNumber *)compared[1]).floatValue/factorB.totalContribution);
 ad+=factorB.score*(((NSNumber *)compared[1]).floatValue/factorB.totalContribution);
 }
 
 }
 
 //NSLog(@"denominators: ad %f, bd %f", ad, bd);
 //add up and update each factor's score and reset tempScore
 NSLog(@"A:");
 for (Factor * factor in factorsA)
 {
 
 if (factor.comparedWith.count >0)
 {
 factor.score = factor.tempScore;
 if ([factor isPro])
 a+=factor.averageWeight*factor.score/ad;
 //self.AcontributionScore += factor.score;
 else
 a-=factor.averageWeight*factor.score/ad;
 //self.AcontributionScore -= factor.score;
 factor.tempScore = 0.0;
 }
 //NSLog(@"average weight: %f", factor.averageWeight);
 //NSLog(@"score: %f", factor.score);
 //a+=factor.averageWeight*factor.score;
 
 
 
 }
 self.AcontributionScore = a;
 //NSLog(@"a total contribution score: %f", self.AcontributionScore);
 
 
 NSLog(@"B:");
 for (Factor * factor in factorsB)
 {
 if (factor.comparedWith.count >0)
 {
 factor.score = factor.tempScore;
 if ([factor isPro])
 b+=factor.averageWeight*factor.score/bd;
 //self.BcontributionScore += factor.score;
 else
 b-=factor.averageWeight*factor.score/bd;
 //self.BcontributionScore -= factor.score;
 factor.tempScore = 0.0;
 }
 //NSLog(@"average weight: %f", factor.averageWeight);
 //NSLog(@"score: %f", factor.score);
 //b+=factor.averageWeight*factor.score;
 }
 self.BcontributionScore = b;
 //NSLog(@"b total contribution score: %f", self.BcontributionScore);
 
 
 if (self.AcontributionScore<0 | self.BcontributionScore<0)
 {
 NSLog(@"normalizing neg");
 self.AcontributionScore-=MIN(self.AcontributionScore, self.BcontributionScore);
 self.BcontributionScore-=MIN(self.AcontributionScore, self.BcontributionScore);
 
 }
 
 
 if (self.AcontributionScore == self.BcontributionScore)
 {
 self.Arate = 50;
 self.Brate = 50;
 }
 else
 {
 self.Arate = self.AcontributionScore/(self.AcontributionScore+self.BcontributionScore);
 self.Brate = self.BcontributionScore/(self.AcontributionScore+self.BcontributionScore);
 
 self.Arate = (int)(self.Arate*100+0.5);
 self.Brate = (int)(self.Brate*100+0.5);
 
 }
 
 }
 
 */
/*

-(void)updateScore
{
    int Ascore = 0;
    int Bscore = 0;
    for (Factor * factor in [[self.choices objectAtIndex:0] factors])
    {
        if (factor.isPro)
        {
            Ascore += factor.averageWeight;
            //NSLog(@"add: %f, a score: %d", factor.averageWeight, Ascore);
        }
        else
        {
            Ascore -= factor.averageWeight;
            //NSLog(@"sub: %f, a score: %d", factor.averageWeight, Ascore);

        }
    }
    
    for (Factor * factor in [[self.choices objectAtIndex:1] factors])
    {
        if (factor.isPro)
        {
            Bscore += factor.averageWeight;
            //NSLog(@"add: %f, b score: %d", factor.averageWeight, Bscore);
        }
        else
        {
            Bscore -= factor.averageWeight;
            //NSLog(@"sub: %f, b score: %d", factor.averageWeight, Bscore);
        }
    }
    
    self.Ascore = Ascore;
    self.Bscore = Bscore;
    
    if (self.Ascore<0 | self.Bscore<0)
    {
        NSLog(@"normalizing neg");
        float normalizingFactor = MIN(self.Ascore, self.Bscore);
        self.Ascore-=normalizingFactor;
        self.Bscore-=normalizingFactor;
        
    }

    
    self.Arate = (float)self.Ascore/(self.Ascore+self.Bscore);
    self.Brate = (float)self.Bscore/(self.Ascore+self.Bscore);
    
    self.Arate = self.Arate*100+0.5;
    self.Brate = self.Brate*100+0.5;

    NSLog(@"Normal Score-> a: %f, b: %f", self.Ascore, self.Bscore);
    NSLog(@"a rate: %f", self.Arate);
    NSLog(@"b rate: %f", self.Brate);

}


*/

/* summing up each comp results 
-(void)updateScore
{
    self.Ascore  = 0;
    self.Bscore  = 0;
    
    for (int i = 0; i < self.numOfCompsDone; i++)
    {
        
        Comparison * comp = [self.comparisons objectAtIndex:i];
        if (comp.factorA.isPro)
            self.Ascore  += [comp factorAWeight];
        else
            self.Ascore  -= [comp factorAWeight];
        
        if (comp.factorB.isPro)
            self.Bscore  += [comp factorBWeight];
        else
            self.Bscore  -= [comp factorBWeight];
        
        
    }
    
    
    if (self.Ascore<0 | self.Bscore<0)
    {
        NSLog(@"normalizing neg");
        self.Ascore-=MIN(self.Ascore, self.Bscore);
        self.Ascore+=1;
        self.Bscore-=MIN(self.Ascore, self.Bscore);
        self.Bscore+=1;
        
    }
    
    
    self.Arate = (float)self.Ascore/(self.Ascore+self.Bscore);
    self.Brate = (float)self.Bscore/(self.Ascore+self.Bscore);
    
    NSLog(@"a score: %d, b score: %d", self.Ascore, self.Bscore);
    NSLog(@"a rate: %f", self.Arate);
    NSLog(@"b rate: %f", self.Brate);
    
}
 
 */




@end
