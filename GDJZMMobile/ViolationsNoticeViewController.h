//
//  ViolationsNoticeViewController.h
//  GDJZMMobile
//
//  Created by lintie.zhen on 14-4-25.
//
//

#import "CasePrintViewController.h"

/*
 *  违法案件编辑界面
 */
@interface ViolationsNoticeViewController : CasePrintViewController
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;// 地址
@property (weak, nonatomic) IBOutlet UITextField *sendNameTextField;// 发送单位
@property (weak, nonatomic) IBOutlet UITextField *behaviorTextField;// 违法行为
@property (weak, nonatomic) IBOutlet UITextField *tiao1TextField;// 中华人民共和国公路法第几条
@property (weak, nonatomic) IBOutlet UITextField *kuan1TextField;// 款1
@property (weak, nonatomic) IBOutlet UITextView *remark1TextView;// 备注1
@property (weak, nonatomic) IBOutlet UITextField *tiao2TextField;// 公路安全保护条例第几条
@property (weak, nonatomic) IBOutlet UITextField *kuan2TextField;// 款2
@property (weak, nonatomic) IBOutlet UITextView *remark2TextView;// 备注2
@property (weak, nonatomic) IBOutlet UITextField *tiao3TextField;// 广东省公路条例第几条
@property (weak, nonatomic) IBOutlet UITextField *kuan3TextField;// 款3
@property (weak, nonatomic) IBOutlet UITextView *remark3TextView;// 备注3


@end
