//
//  QuestionViewController.m
//  ObjectiveCTrainerApp
//
//  Created by Jimmy Mjällby on 2014-05-02.
//  Copyright (c) 2014 StrictDesign. All rights reserved.
//

#import "QuestionViewController.h"
#import "SWRevealViewController.h"

@interface QuestionViewController ()
{
    Question *_currentQuestion;
    
    UIView *_tappablePortionOfImageQuestion;
    UITapGestureRecognizer *_tapRecognizer;
    UITapGestureRecognizer *_scrollViewTapGestureRecognizer;
}

@end

@implementation QuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add tap gesture to scrollview
    _scrollViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped)];
    [self.questionScrollView addGestureRecognizer:_scrollViewTapGestureRecognizer];
    
    // Add pan gesture recognizer for menu reveal
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Hide everything
    [self hideAllQuestionElements];
    
    // Create the Quiz Model
    self.model = [[QuestionModel alloc] init];
    
    // Check difficulty level and retrive questions for desired level
    self.questions = [self.model getQuestions:self.questionDifficulty];
    
    // Display a random question
    [self randomizeQuestionForDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hideAllQuestionElements
{
    self.questionText.hidden = YES;
    self.questionMCAnswer1.hidden = YES;
    self.questionMCAnswer2.hidden = YES;
    self.questionMCAnswer3.hidden = YES;
    self.submitAnswerForBlankButton.hidden = YES;
    self.blankTextField.hidden = YES;
    self.instructionsLabelForBlank.hidden = YES;
    self.imageQuestionImageView.hidden = YES;
    
    // Remove the tappable uiview for image questions
    if (_tappablePortionOfImageQuestion.superview != nil)
    {
        [_tappablePortionOfImageQuestion removeFromSuperview];
    }
}

#pragma mark Questions Methods

- (void)displayCurrentQuestion
{
    switch (_currentQuestion.questionType) {
        case QuestionTypeMC:
            [self displayMCQuestion];
            break;
            
        case QuestionTypeBlank:
            [self displayBlankQuestion];
            break;
            
        case QuestionTypeImage:
            [self displayImageQuestion];
            break;
            
        default:
            break;
    }
}

- (void)displayMCQuestion
{
    // Hide all the elements
    [self hideAllQuestionElements];
    
    // Set question elements
    self.questionText.text = _currentQuestion.questionText;
    [self.questionMCAnswer1 setTitle:_currentQuestion.questionAnswer1 forState:UIControlStateNormal];
    [self.questionMCAnswer2 setTitle:_currentQuestion.questionAnswer2 forState:UIControlStateNormal];
    [self.questionMCAnswer3 setTitle:_currentQuestion.questionAnswer3 forState:UIControlStateNormal];
    
    // Adjust scrollView
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width, self.skipButton.frame.origin.y + self.skipButton.frame.size.height + 30);
    
    // Reveal question elements
    self.questionText.hidden = NO;
    self.questionMCAnswer1.hidden = NO;
    self.questionMCAnswer2.hidden = NO;
    self.questionMCAnswer3.hidden = NO;
}

- (void)displayImageQuestion
{
    // Hide all the elements
    [self hideAllQuestionElements];
    
    // Set question elements
    
    // TODO: Set Image
    self.imageQuestionImageView.backgroundColor = [UIColor greenColor];
    
    // Create tappable part
    int tappable_x = self.imageQuestionImageView.frame.origin.x + _currentQuestion.offset_x - 10;
    int tappable_y = self.imageQuestionImageView.frame.origin.y + _currentQuestion.offset_y - 10;
    
    _tappablePortionOfImageQuestion = [[UIView alloc] initWithFrame:CGRectMake(tappable_x, tappable_y, 20, 20)];
    _tappablePortionOfImageQuestion.backgroundColor = [UIColor redColor];
    
    // Create and attach gesture recognizer
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageQuestionAnswered)];
    [_tappablePortionOfImageQuestion addGestureRecognizer:_tapRecognizer];
    
    // Add tappable part
    [self.questionScrollView addSubview:_tappablePortionOfImageQuestion];
    
    self.imageQuestionImageView.hidden = NO;
}

- (void)displayBlankQuestion
{
    // Hide all the elements
    [self hideAllQuestionElements];
    
    // Set question elements
    self.questionText.text = _currentQuestion.questionText;
    
    // Adjust scrollView
    self.questionScrollView.contentSize = CGSizeMake(self.questionScrollView.frame.size.width, self.skipButton.frame.origin.y + self.skipButton.frame.size.height + 30);
    
    // Reveal question elements
    self.questionText.hidden = NO;
    self.submitAnswerForBlankButton.hidden = NO;
    self.blankTextField.hidden = NO;
    self.instructionsLabelForBlank.hidden = NO;
}

- (void)randomizeQuestionForDisplay
{
    // Randomize a question
    int randomQuestionIndex = arc4random() % self.questions.count;
    _currentQuestion = self.questions[randomQuestionIndex];
    
    // Display the question
    [self displayCurrentQuestion];
}

#pragma mark Question Answer Handlers

- (IBAction)skipButtonClicked:(id)sender
{
    // Randomize and display another question
    [self randomizeQuestionForDisplay];
}

- (IBAction)questionMCAnswer:(id)sender
{
    UIButton *selectedButton = (UIButton *)sender;
    BOOL isCorrect = NO;
    
    if (selectedButton.tag == _currentQuestion.correctMCQuestionIndex)
    {
        // User got it right
        isCorrect = YES;
        
        // TODO: display message for correct answer
        
    }
    else
    {
        // User got it wrong
    }
    
    // Record questions data
    [self savedQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:isCorrect];
    
    // Display the next question
    [self randomizeQuestionForDisplay];
}

-(void)imageQuestionAnswered
{
    // User got it right
    
    // TODO: display message for right answer
    
    [self savedQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:YES];
    
    // Display the next question
    [self randomizeQuestionForDisplay];
}

-(IBAction)blankSubmitted:(id)sender
{
    NSString *answer = self.blankTextField.text;
    BOOL isCorrect = NO;
    
    if ([answer isEqualToString:_currentQuestion.correctAnswerForBlank])
    {
        // User got it right
        isCorrect = YES;
        
        // TODO: display message for correct answer
    }
    else
    {
        // User got it wrong
    }
    
    self.blankTextField.text = @"";
    
    // Record question data
    [self savedQuestionData:_currentQuestion.questionType withDifficulty:_currentQuestion.questionDifficulty isCorrect:isCorrect];
    
    // Display the next question
    [self randomizeQuestionForDisplay];
}

- (void)savedQuestionData:(QuizQuestionType)type withDifficulty:(QuizQuestionDifficulty)difficulty isCorrect:(BOOL)correct
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Save data based on type
    NSString *keyToSaveForType = @"";
    
    if (type == QuestionTypeBlank)
    {
        // Record that they answered an Blank question
        keyToSaveForType = @"Blank";
    }
    else if (type == QuestionTypeMC)
    {
        // Record that they answered an MC question
        keyToSaveForType = @"MC";
        
    }
    else if (type == QuestionTypeImage)
    {
        keyToSaveForType = @"Image";
    }
    
    // Record that they answered a question by type
    int questionsAnsweredByType = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionAnswered", keyToSaveForType]];
    questionsAnsweredByType++;
    [userDefaults setInteger:questionsAnsweredByType forKey:[NSString stringWithFormat:@"%@QuestionAnswered", keyToSaveForType]];
    
    // Record that they answered a question correctly by type
    int questionsAnsweredCorrectlyByType = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionAnsweredCorrectly", keyToSaveForType]];
    questionsAnsweredCorrectlyByType++;
    [userDefaults setInteger:questionsAnsweredCorrectlyByType forKey:[NSString stringWithFormat:@"%@QuestionAnsweredCorrectly", keyToSaveForType]];
    
    
    
    
    // Save data based on difficulty
    NSString *keyToSave = @"";
    
    if (difficulty == QuestionDifficultyEasy)
    {
        keyToSave = @"Easy";
    }
    else if (difficulty == QuestionDifficultyMedium)
    {
        keyToSave = @"Meduim";
    }
    else if (difficulty == QuestionDifficultyHard)
    {
        keyToSave = @"Hard";
    }
    
    int questionAnsweredWithDifficulty = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSave]];
    questionAnsweredWithDifficulty++;
    [userDefaults setInteger:questionAnsweredWithDifficulty forKey:[NSString stringWithFormat:@"%@QuestionsAnswered", keyToSave]];
    if (correct)
    {
        int questionAnsweredCorrectlyWithDifficulty = [userDefaults integerForKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSave]];
        questionAnsweredCorrectlyWithDifficulty++;
        [userDefaults setInteger:questionAnsweredCorrectlyWithDifficulty forKey:[NSString stringWithFormat:@"%@QuestionsAnsweredCorrectly", keyToSave]];
    }
    
    [userDefaults synchronize];

}

- (void)scrollViewTapped
{
    [self.blankTextField resignFirstResponder];
}

@end
