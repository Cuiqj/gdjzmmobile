//
//  ForceNoticePrintViewController.h
//  GDXERHMMobile
//
//  Created by wangfaqaun on 11/7/13.
//
//

#import "CasePrintViewController.h"

@interface ForceNoticePrintViewController : CasePrintViewController

@property (weak, nonatomic) IBOutlet UILabel *anhao;

@property (weak, nonatomic) IBOutlet UITextField *sendname;
@property (weak, nonatomic) IBOutlet UITextField *road;

@property (weak, nonatomic) IBOutlet UITextField *behavior;
@property (weak, nonatomic) IBOutlet UITextField *tiao;
@property (weak, nonatomic) IBOutlet UITextField *kuan;
@property (weak, nonatomic) IBOutlet UITextField *limitday;
@property (weak, nonatomic) IBOutlet UITextField *change;
@property (weak, nonatomic) IBOutlet UITextField *textlineMan;
@property (weak, nonatomic) IBOutlet UITextField *textlineTel;
@property (strong, nonatomic) IBOutlet UIView *Phone;
@property (weak, nonatomic) IBOutlet UITextField *Phones;


@end
