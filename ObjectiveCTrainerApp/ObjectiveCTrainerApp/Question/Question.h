//
//  Question.h
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 05/05/14.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic) QuizQuestionType questionType;
@property (nonatomic) QuizQuestionDifficulty questionDifficulty;

@property (strong, nonatomic) NSString *questionText;

// Property for MC
@property (strong, nonatomic) NSString *questionAnswer1;
@property (strong, nonatomic) NSString *questionAnswer2;
@property (strong, nonatomic) NSString *questionAnswer3;
@property (nonatomic) int correctMCQuestionIndex;

// Property for fill in the blank
@property (strong, nonatomic) NSString *correctAnswerForBlank;

//Property for find within the image
@property (nonatomic) int offset_x;
@property (nonatomic) int offset_y;
@property (strong, nonatomic) NSString *questionImageName;
@property (strong, nonatomic) NSString *answerImageName;

@end
