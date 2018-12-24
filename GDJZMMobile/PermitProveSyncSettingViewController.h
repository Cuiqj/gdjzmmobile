//
//  PermitProveSyncSettingViewController.h
//  GDXERHMMobile
//
//  Created by XU SHIWEN on 13-10-22.
//
//

#import <UIKit/UIKit.h>

@interface PermitProveSyncSettingViewController : UIViewController

@property (weak, nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSyncAddress;

- (IBAction)touchConfirm:(id)sender;
- (IBAction)touchCancel:(id)sender;
@end
