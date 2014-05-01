//
//  comparisonMaker.m
//  DecisionMaker
//
//  Created by Siyao Clara Xie on 11/23/13.
//  Copyright (c) 2013 Siyao Xie. All rights reserved.
//

#import "ComparisonMaker.h"

@implementation ComparisonMaker

-(id)initWithDecision:(Decision *)decision
{
    self.decision = decision;
    self.choiceA = decision.choices[0];
    self.choiceB = decision.choices[1];
    self.randomCount = 0;
    
    return self;
}

//generate comps:
//A[i] vs. B[i], extra factor randomly compared with whats left
-(NSMutableArray *)inputOrderCompsGenerator
{
    
    NSMutableArray * A = [self.choiceA.factors mutableCopy];
    NSMutableArray * B = [self.choiceB.factors mutableCopy];
    
    int numOfFactorsA = (int)self.choiceA.factors.count;
    int numOfFactorsB = (int)self.choiceB.factors.count;
    int min = MIN(numOfFactorsA, numOfFactorsB);
    int max = MAX(numOfFactorsA, numOfFactorsB);
    
    NSMutableArray *comparisons = [[NSMutableArray alloc]init];
    
    //comparing A's ith factor with B's ith factor
    for (int i = 0; i < min; i++)
    {
        Comparison * comp = [[Comparison alloc]initWithFactorA:A[i] andFactorB:B[i]];
        [comparisons addObject:comp];
        //[[A[i] comparedWith] addObject:B[i]];
        //[[B[i] comparedWith] addObject:A[i]];
    }
    
    //compare the factors that are left with randomly chosen factors
    for (int i = min; i < max; i++)
    {
        Comparison * comp;
        int randomIndex = arc4random_uniform(min);
        if (numOfFactorsA < numOfFactorsB)
        {
            comp = [[Comparison alloc]initWithFactorA:A[randomIndex] andFactorB:B[i]];
            //[[A[randomIndex] comparedWith] addObject:B[i]];
            //[[B[i] comparedWith] addObject:A[randomIndex]];
        }
        else
        {
            comp = [[Comparison alloc]initWithFactorA:A[i] andFactorB:B[randomIndex]];
            //[[A[i] comparedWith] addObject:B[randomIndex]];
            //[[B[randomIndex] comparedWith] addObject:A[i]];
            
        }
        [comparisons addObject:comp];
        
    }
    
    self.decision.round = 1;
    return comparisons;

}

-(NSMutableArray *)inOrderCompsGeneratorWithArrayA:(NSMutableArray *)A andArrayB:(NSMutableArray *)B
{
    
    NSMutableArray *comparisons = [[NSMutableArray alloc]init];
    
    
    if (A.count == 0 && B.count == 0)
    {
         return comparisons;
    }
    else if (A.count == 0)
    {
        for (int i = 0; i < B.count; i++)
        {
            Factor * factorA = [self generateUniqueRandomFactorforFactor:B[i] inArray:self.choiceA.factors];
            Comparison * comp = [[Comparison alloc]initWithFactorA:factorA andFactorB:B[i]];
            
            //[[factorA comparedWith] addObject:B[i]];
            //[[B[i] comparedWith] addObject:factorA];
            [comparisons addObject:comp];
        }
        return comparisons;
    }
    else if (B.count == 0)
    {
        for (int i = 0; i < A.count; i++)
        {
            Factor * factorB = [self generateUniqueRandomFactorforFactor:A[i] inArray:self.choiceB.factors];
            Comparison * comp = [[Comparison alloc]initWithFactorA:A[i] andFactorB:factorB];
            //[[factorB comparedWith] addObject:A[i]];
            //[[A[i] comparedWith] addObject:factorB];
            [comparisons addObject:comp];
        }
        return comparisons;

    }
    else
    {
        if ([A[0] alreadyComparedWithFactor:B[0]]== NO) {
            Comparison * comp = [[Comparison alloc]initWithFactorA:A[0] andFactorB:B[0]];
            //[[A[0] comparedWith] addObject:B[0]];
            //[[B[0] comparedWith] addObject:A[0]];
            [comparisons addObject:comp];
        }

        //recursively generate comparisons,skip repeated ones (***not ideal)
        //FIXME
        //when the ordering is the exact same as the first round, no comparisons will be generated, thus no new comps are generated
        [A removeObjectAtIndex:0];
        [B removeObjectAtIndex:0];
        [comparisons addObjectsFromArray:[self inOrderCompsGeneratorWithArrayA:A andArrayB:B]];
        
        NSLog(@"%lu",(unsigned long)comparisons.count);

        return comparisons;
 
    }
}




//can move to factor
-(Factor *)generateUniqueRandomFactorforFactor:(Factor *)factor inArray:(NSMutableArray *)targetFactors
{
    int randomIndex = arc4random_uniform(targetFactors.count);
    

    while ([factor alreadyComparedWithFactor:targetFactors[randomIndex]]) {
        randomIndex = arc4random_uniform(targetFactors.count);
    }
    return targetFactors[randomIndex];
}


-(NSMutableArray *)randomCompsGenerator
{
    int numOfFactorsA = (int)self.choiceA.factors.count;
    int numOfFactorsB = (int)self.choiceB.factors.count;
    
    int max;
    int min;
    NSMutableArray * baseFactors;
    NSMutableArray * targetFactors;
    
    
    if (numOfFactorsA > numOfFactorsB)
    {
        max = numOfFactorsA;
        min = numOfFactorsB;
        baseFactors = [self.choiceA.factors mutableCopy];
        targetFactors = [self.choiceB.factors mutableCopy];
    }
    else
    {
        max = numOfFactorsB;
        min = numOfFactorsA;
        baseFactors = [self.choiceB.factors mutableCopy];
        targetFactors = [self.choiceA.factors mutableCopy];
        
    }

    NSMutableArray * comparisons = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < max; i++)
    {
        //only generate if not already compared with all target factors
        if ([baseFactors[i] comparedWith].count < targetFactors.count) {
            int randomIndex = arc4random_uniform(min);
            while ([baseFactors[i] alreadyComparedWithFactor:targetFactors[randomIndex]]) {
                randomIndex = arc4random_uniform(min);
            }
            
            Comparison * uniqueComp;
            if (numOfFactorsA > numOfFactorsB)
            {
                 uniqueComp = [[Comparison alloc]initWithFactorA:baseFactors[i] andFactorB:targetFactors[randomIndex]];
            }
            else
            {
                uniqueComp = [[Comparison alloc]initWithFactorA:targetFactors[randomIndex] andFactorB:baseFactors[i]];
            }
           
            //[[baseFactors[i] comparedWith] addObject:targetFactors[randomIndex]];
            //[[targetFactors[randomIndex] comparedWith] addObject:baseFactors[i]];
            [comparisons addObject:uniqueComp];
            
        }
        
    }
    
    
    self.decision.round = 3;
    return comparisons;
    
    
    
}



-(NSMutableArray *)currentWeightRankingCompsGenerator
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"averageWeight"
                                                 ascending:NO];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    
    NSMutableArray * A = [self.choiceA.factors mutableCopy];
    NSMutableArray * B = [self.choiceB.factors mutableCopy];

    [A sortUsingDescriptors:sortDescriptors];
    [B sortUsingDescriptors:sortDescriptors];
    
    
    self.decision.round = 2;
    return [self inOrderCompsGeneratorWithArrayA:A andArrayB:B];
    
}


-(NSMutableArray *)restCompsGenerator
{
    NSMutableArray * comparisons = [[NSMutableArray alloc]init];
    
    for (Factor * factorA in self.choiceA.factors)
    {
        for (Factor * factorB in self.choiceB.factors)
        {
            if (![factorA alreadyComparedWithFactor:factorB])
            {
                [comparisons addObject:[[Comparison alloc]initWithFactorA:factorA andFactorB:factorB]];
                //[factorA.comparedWith addObject:factorB];
                //[factorB.comparedWith addObject:factorA];
            }
        }
    }
    return comparisons;
}



/*
-(Comparison *)singleRandomCompGeneratorWithAArray:(NSMutableArray *)A andBArray:(NSMutableArray *)B
{

    int randomIndexA = arc4random_uniform(A.count);
    int randomIndexB = arc4random_uniform(B.count);
    // how should i handle the case when the items left have already compared with each other
    // currently if have to repeat, let it repeat *** not ideal
    if ([self.choiceA.factors[randomIndexA] alreadyComparedWithFactor:self.choiceB.factors[randomIndexB]] && self.randomCount <=MAX(A.count,B.count))
    {
        self.randomCount+=1;
        //NSLog(@"shuffle again: %d",self.randomCount);
        
        return [self singleRandomCompGeneratorWithAArray:self.choiceA.factors andBArray:self.choiceB.factors];

    }
    else
    {
        [[self.choiceA.factors[randomIndexA] comparedWith] addObject:self.choiceB.factors[randomIndexB]];
        [[self.choiceB.factors[randomIndexB] comparedWith] addObject:self.choiceA.factors[randomIndexA]];
        return [[Comparison alloc]initWithFactorA:self.choiceA.factors[randomIndexA]
                                         andIndex:randomIndexA
                                       andFactorB:self.choiceB.factors[randomIndexB]
                                         andindex:randomIndexB];
    }
    
}


*/

@end
