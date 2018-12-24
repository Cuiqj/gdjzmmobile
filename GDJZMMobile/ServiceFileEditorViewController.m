//
//  ServiceFileEditorViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 13-1-21.
//
//

#import "ServiceFileEditorViewController.h"
#import "CaseInfo.h"
#import "CaseDocuments.h"
#import "CaseServiceReceipt.h"
#import "ListSelectViewController.h"

#define MAX_SELECTED_FILE_NUM 3

@interface ServiceFileEditorViewController ()<ListSelectPopoverDelegate>
@property (nonatomic, strong) UIPopoverController *selectServiceFilePopover;
@end

@implementation ServiceFileEditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.file) {
        self.textFileName.text = [self.file service_file];
        self.textRemark.text = [self.file remark];
//        self.textSendAddress.text = [self.file send_address];
//        self.textSendWay.text = [self.file send_way];
    }
}


- (IBAction)btnDismiss:(UIBarButtonItem *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnComfirm:(UIBarButtonItem *)sender {
    if (self.textFileName.text != nil && ![self.textFileName.text isEmpty]) {
        NSArray *filesOwned = [CaseServiceFiles caseServiceFilesForCase:self.caseID];
        // 判断是否已有同名文书
        for (CaseServiceFiles *file in filesOwned){
            if ([file.service_file isEqualToString:self.textFileName.text]) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"该文书已添加过" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                [self dismissModalViewControllerAnimated:YES];
                return;
            } else {
                continue;
            }
        }
        if (self.file == nil) {
            // 在新增文书情况下判断是否已超出文书数量限制
            if ([filesOwned count] >= MAX_SELECTED_FILE_NUM) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能添加三份文书" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            }
            CaseServiceReceipt *serviceReceipt = [CaseServiceReceipt caseServiceReceiptForCase:self.caseID];
            if (serviceReceipt) {
                self.file = [CaseServiceFiles newCaseServiceFilesForCaseServiceReceipt:serviceReceipt.myid];
            }
        }
        if (self.file) {
            self.file.service_file = self.textFileName.text;
        }
        [[AppDelegate App] saveContext];
        [self.delegate reloadDataArray];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)textFieldEditBegin:(UITextField *)sender {
    
    if (self.selectServiceFilePopover == nil) {
        ListSelectViewController *serviceFileSelector = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSelectPopover"];
        serviceFileSelector.delegate = self;
        CaseInfo *caseInfo = [CaseInfo caseInfoForID:self.caseID];
        serviceFileSelector.data = [CaseDocuments allDocumentFullNamesForCaseTypeID:caseInfo.case_type_id];
        self.selectServiceFilePopover = [[UIPopoverController alloc] initWithContentViewController:serviceFileSelector];
        serviceFileSelector.pickerPopover = self.selectServiceFilePopover;
    }

    if ([self.selectServiceFilePopover isPopoverVisible]) {
        [self.selectServiceFilePopover dismissPopoverAnimated:YES];
    } else {
        [self.selectServiceFilePopover presentPopoverFromRect:sender.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self.selectServiceFilePopover setPopoverContentSize:CGSizeMake(400, 300) animated:YES];
    }
    
    
}

- (void)viewDidUnload {
    [self setTextFileName:nil];
    [self setTextRemark:nil];
    [self setTextSendAddress:nil];
    [self setTextSendWay:nil];
    [self setCaseID:nil];
    [self setFile:nil];
    [super viewDidUnload];
}

#pragma mark - ListSelectPopoverDelegate

- (void)setSelectData:(NSString *)data
{
    self.textFileName.text = data;
}

@end
