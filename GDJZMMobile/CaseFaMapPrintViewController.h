//
//  CaseFaMapPrintViewController.h
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-28.
//
//

#import "CasePrintViewController.h"

/*
 *  违法案件勘验图编辑界面控制器
 */
@interface CaseFaMapPrintViewController : CasePrintViewController

@property (weak, nonatomic) IBOutlet UITextField *labelTime;
@property (weak, nonatomic) IBOutlet UITextField *textRoadName;
@property (weak, nonatomic) IBOutlet UITextField *roadDrection;
@property (weak, nonatomic) IBOutlet UITextField *textStartK;
@property (weak, nonatomic) IBOutlet UITextField *textStartM;
@property (weak, nonatomic) IBOutlet UITextView *textViewRemark;
@property (weak, nonatomic) IBOutlet UILabel *labelProver;
@property (weak, nonatomic) IBOutlet UILabel *labelDraftMan;
@property (weak, nonatomic) IBOutlet UILabel *labelDraftTime;
@property (weak, nonatomic) IBOutlet UIImageView *mapImage;
@property (weak, nonatomic) IBOutlet UILabel *labelCaseMark;
@property (weak, nonatomic) IBOutlet UITextField *textCaseReason;

@end
