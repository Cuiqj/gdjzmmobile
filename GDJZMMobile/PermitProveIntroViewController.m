//
//  PermitProveIntroViewController.m
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-10-16.
//
//

#import "PermitProveIntroViewController.h"
#import "PermitProveSyncSettingViewController.h"

@interface PermitProveIntroViewController ()

@property (nonatomic, strong) PermitProveSyncSettingViewController *syncSettingViewController;

@end

@implementation PermitProveIntroViewController

#pragma mark - Object Lifecycle

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - IBActions

- (IBAction)touchEnterPermitProve:(id)sender
{

}

- (IBAction)touchSetSyncAddress:(id)sender
{
    if (!self.syncSettingViewController) {
        self.syncSettingViewController = [[PermitProveSyncSettingViewController alloc] initWithNibName:@"PermitProveSyncSettingViewController" bundle:nil];
        self.syncSettingViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.syncSettingViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    [self presentModalViewController:self.syncSettingViewController animated:YES];
}

- (IBAction)touchDownloadPermitData:(id)sender
{
}

- (IBAction)touchUploadPermitData:(id)sender
{
}

@end
