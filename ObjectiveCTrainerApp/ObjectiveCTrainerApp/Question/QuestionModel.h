//
//  QuestionModel.h
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 2014-05-02.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject

@property (strong, nonatomic) NSMutableArray *easyQuestion;
@property (strong, nonatomic) NSMutableArray *mediumQuestion;
@property (strong, nonatomic) NSMutableArray *hardQuestion;

- (NSMutableArray *)getQuestions: (QuizQuestionDifficulty)difficulty;

@end
