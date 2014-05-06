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
        
        // Load questions.json and parse out questions into array
        [self loadQuestions];
        
    }
    return self;
}

- (NSMutableArray *)getQuestions: (QuizQuestionDifficulty)difficulty
{
    if (difficulty == QuestionDifficultyEasy) {
        return self.easyQuestion;
    }
    else if (difficulty == QuestionDifficultyMedium)
    {
        return self.mediumQuestion;
    }
    else if (difficulty == QuestionDifficultyHard)
    {
        return self.hardQuestion;
    }
    else
    {
        return [[NSMutableArray alloc] init];
    }
    
    return self.easyQuestion;
}

- (void)loadQuestions
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"json"];
    
    NSError *myError;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&myError];
    
    NSData *myJsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *myJsonDictionary =  [NSJSONSerialization JSONObjectWithData:myJsonData options:NSJSONReadingAllowFragments error:nil];
    
    // Parse out easy questions
    NSArray *easyJsonArray = myJsonDictionary[@"easy"];
    self.easyQuestion = [self parseJsonArrayIntoQuestions:easyJsonArray forDifficulty:QuestionDifficultyEasy];
    
    // Parse out medium questions
    NSArray *mediumJsonArray = myJsonDictionary[@"easy"];
    self.easyQuestion = [self parseJsonArrayIntoQuestions:mediumJsonArray forDifficulty:QuestionDifficultyMedium];
    
    // Parse out hard questions
    NSArray *hardJsonArray = myJsonDictionary[@"easy"];
    self.easyQuestion = [self parseJsonArrayIntoQuestions:hardJsonArray forDifficulty:QuestionDifficultyHard];
}

- (NSMutableArray*)parseJsonArrayIntoQuestions:(NSArray *)jsonArray forDifficulty:(QuizQuestionDifficulty)difficulty
{
    // Create new temporary array to store newly created questions
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    // Loop through json objects in the passed in array
    for (int i = 0; i < jsonArray.count; i++) {
        NSDictionary *jsonObject = jsonArray[i];
        
        // Create a new Question object
        Question *newQuestion = [[Question alloc] init];
        newQuestion.questionDifficulty = difficulty;
        
        if ([jsonObject[@"type"] isEqualToString:@"mc"]) {
            
            // Parse multiple choise type question
            newQuestion.questionType = QuestionTypeMC;
            newQuestion.questionText = jsonObject[@"question"];
            newQuestion.questionAnswer1 = jsonObject[@"answer0"];
            newQuestion.questionAnswer2 = jsonObject[@"answer1"];
            newQuestion.questionAnswer3 = jsonObject[@"answer2"];
            newQuestion.correctMCQuestionIndex = [jsonObject[@"correctanswer"] intValue];
            
        }
        else if ([jsonObject[@"type"] isEqualToString:@"image"])
        {
            
            // Parse out image type question
            newQuestion.questionType = QuestionTypeImage;
            newQuestion.questionText = jsonObject[@"question"];
            newQuestion.questionImageName = jsonObject[@"imagename"];
            newQuestion.offset_x = [jsonObject[@"x_coord"] intValue];
            newQuestion.offset_y = [jsonObject[@"y_coord"] intValue];
            newQuestion.answerImageName = jsonObject[@"answerimage"];
            
        }
        else if ([jsonObject[@"type"] isEqualToString:@"blank"])
        {
            // Parse out of fill in the blank questions
            newQuestion.questionType = QuestionTypeBlank;
            newQuestion.questionImageName = jsonObject[@"imagename"];
            newQuestion.answerImageName = jsonObject[@"answerimage"];
            newQuestion.correctAnswerForBlank = jsonObject[@"answer"];
        }
        
        // Add newly created question to temp array
        [tempArray addObject:newQuestion];
    }
    // Return tempArray
    return tempArray;
}

@end
