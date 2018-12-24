//
//  CaseReserachViewController.h
//  GDJZMMobile
//
//  Created by quxiuyun on 14-3-14.
//
//

#import "CasePrintViewController.h"

//调查报告
@interface CaseReserachViewController : CasePrintViewController


@property (nonatomic, weak) IBOutlet UITextField *textcase_short_desc;//单行多文本框    案由
  
@property (nonatomic, weak) IBOutlet UITextField *textInvestigator1;//单行多文本框    案件调查人员姓名

@property (nonatomic, weak) IBOutlet UITextField *textID1;//单行多文本框    证件号
@property (weak, nonatomic) IBOutlet UITextField *textInvestigator2;
@property (weak, nonatomic) IBOutlet UITextField *textID2;

@property (nonatomic, weak) IBOutlet UITextField *textPartiesConcernedName;//单行多文本框    当事人姓名
@property (weak, nonatomic) IBOutlet UITextField *textInvestigator3;
@property (weak, nonatomic) IBOutlet UITextField *textID3;

@property (nonatomic, weak) IBOutlet UITextField *textUnitName;//单行多文本框    当事人单位名称

@property (nonatomic, weak) IBOutlet UITextField *textAdd;//单行多文本框    地址
@property (nonatomic, weak) IBOutlet UITextField *textVehicleLocated;//单行多文本框    车辆所在地
@property (nonatomic, weak) IBOutlet UITextField *textRepresentative;//单行多文本框    法定代表人
@property (nonatomic, weak) IBOutlet UITextField *textprover2_duty;//单行多文本框    车型车牌

@property (nonatomic, weak) IBOutlet UITextView *textConclusionCase;//单行多文本框    结论案件
@property (nonatomic, weak) IBOutlet UITextView *textEvidenceMaterial;//单行多文本框    证据材料
@property (nonatomic, weak) IBOutlet UITextView *textLeadershipOpinion;//单行多文本框    领导意见

@property (nonatomic, weak) IBOutlet UITextView *textparty;//单行多文本框    备注
@property (weak, nonatomic) IBOutlet UITextView *textCourse;


@property (nonatomic, weak) IBOutlet UITextField *textMark2;
@property (nonatomic, weak) IBOutlet UITextField *textMark3;
- (IBAction)resetInvestigator:(id)sender;
@end
