//
//  CaseReportsViewController.h
//  GDJZMMobile
//
//  Created by quxiuyun on 14-3-14.
//
//

#import "CasePrintViewController.h"

//结案报告视图
@interface CaseReportsViewController : CasePrintViewController



@property (nonatomic, weak) IBOutlet UITextField *textcase_short_desc;//单行多文本框    案由

@property (nonatomic, weak) IBOutlet UITextField *textPromoterName1;//单行多文本框    案件承办人姓名1
@property (nonatomic, weak) IBOutlet UITextField *textID1;//单行多文本框    证件号1

@property (nonatomic, weak) IBOutlet UITextField *textPromoterName2;//单行多文本框案件承办人姓名2
@property (nonatomic, weak) IBOutlet UITextField *textID2;//单行多文本框    证件号2

@property (nonatomic, weak) IBOutlet UITextView *textDecision;//单行多文本框    赔补偿决定
@property (nonatomic, weak) IBOutlet UITextView *textImplementation;//单行多文本框    执行情况
@property (nonatomic, weak) IBOutlet UITextView *textNote;//单行多文本框    备注

@property (weak, nonatomic) IBOutlet UITextField *textPromoterSignature;
//承办人签字
@property (strong, nonatomic) IBOutlet UITextField *textSignTime;//承办人签字时间

@property (weak, nonatomic) IBOutlet UILabel *labelYear;
@property (weak, nonatomic) IBOutlet UILabel *labelMonth;
@property (weak, nonatomic) IBOutlet UILabel *labelDay;




@property (nonatomic, weak) IBOutlet UITextField *textMark2;
@property (nonatomic, weak) IBOutlet UITextField *textMark3;

- (IBAction)selectDateAndTime:(UITextField *)sender;




@end
