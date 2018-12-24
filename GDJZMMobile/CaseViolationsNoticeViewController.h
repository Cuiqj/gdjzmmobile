//
//  ViolationsNoticeViewController.h
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-25.
//
//

#import "CasePrintViewController.h"

/*
 *  公路违法案件告知表编辑界面
 */
@interface CaseViolationsNoticeViewController : CasePrintViewController
@property (weak, nonatomic) IBOutlet UITextField *caseNumTextField;   //案件编号
@property (weak, nonatomic) IBOutlet UITextField *informingDepartmentTextField;   //被告知单位
@property (weak, nonatomic) IBOutlet UITextField *informingDateTextField;   //告知时间
@property (weak, nonatomic) IBOutlet UITextField *informingMethodTextField;   //告知方式
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;    //案件时间
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;   // 地址
@property (weak, nonatomic) IBOutlet UITextView *caseBaseContentTextView;   //案件发生的基本情况
@property (weak, nonatomic) IBOutlet UITextView *suggestingTextView;   //公路管理机构处理建议
@property (weak, nonatomic) IBOutlet UITextField *receptionPersonTextField;   //抄报
@property (weak, nonatomic) IBOutlet UITextField *linkmanTextField;   //告知单位联系人
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;   //联系电话
@property (weak, nonatomic) IBOutlet UITextField *faxTextField;   //传真
@end
