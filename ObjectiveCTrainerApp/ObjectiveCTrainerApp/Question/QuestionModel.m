//
//  QuestionModel.m
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 2014-05-02.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import "QuestionModel.h"
#import "Question.h"

@implementation QuestionModel

- (id)init
{
    self = [super init];
    if (self) {
        // Init stuff here
        self.easyQuestion = [[NSMutableArray alloc] init];
        self.mediumQuestion = [[NSMutableArray alloc] init];
        self.hardQuestion = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray *)getQuestions: (QuizQuestionDifficulty)difficulty
{
    // Create som easy questions
    Question *newQuestion = [[Question alloc] init];
    
    newQuestion.questionDifficulty = QuestionDifficultyEasy;
    newQuestion.questionType = QuestionTypeMC;
    newQuestion.questionText = @"This is a test question";
    newQuestion.questionAnswer1 = @"Ansver 1";
    newQuestion.questionAnswer2 = @"Ansver 2";
    newQuestion.questionAnswer3 = @"Ansver 3";
    newQuestion.correctMCQuestionIndex = 1;
    [self.easyQuestion addObject:newQuestion];
    
    newQuestion = [[Question alloc] init];
    
    newQuestion.questionDifficulty = QuestionDifficultyEasy;
    newQuestion.questionType = QuestionTypeBlank;
    newQuestion.questionText = @"This is a ______ question";
    newQuestion.correctAnswerForBlank = @"test";
    [self.easyQuestion addObject:newQuestion];
    
    newQuestion.questionDifficulty = QuestionDifficultyEasy;
    newQuestion.questionType = QuestionTypeImage;
    newQuestion.questionImageName = @"TestQuestionImage";
    newQuestion.offset_x = 50;
    newQuestion.offset_y = 50;
    [self.easyQuestion addObject:newQuestion];
    
    return self.easyQuestion;
}

@end
