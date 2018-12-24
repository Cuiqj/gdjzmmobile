//
//  OrgSyncViewController.m
//  GuiZhouRMMobile
//
//  Created by yu hongwu on 12-10-15.
//
//

#import "OrgSyncViewController.h"
#import "AGAlertViewWithProgressbar.h"


@interface OrgSyncViewController ()
- (void)downLoadFinished;
@end

@implementation OrgSyncViewController
@synthesize textServerAddress = _textServerAddress;
@synthesize dataDownLoader = _dataDownLoader;

- (DataDownLoad *)dataDownLoader{
    _dataDownLoader = nil;
    if (_dataDownLoader == nil) {
        _dataDownLoader = [[DataDownLoad alloc] init];
    }
    return _dataDownLoader;
}

- (void)viewDidLoad
{
	self.versionName.text = VERSION_NAME;
	self.versionTime.text = VERSION_TIME;
    self.textServerAddress.text = [[AppDelegate App] serverAddress];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated{
    self.dataDownLoader = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DOWNLOADFINISHNOTI object:nil];
    [self.delegate pushLoginView];
}

- (void)viewDidUnload
{
    [self setTextServerAddress:nil];
    [self setDataDownLoader:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setVersionName:nil];
    [self setVersionTime:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


- (IBAction)setCurrentOrg:(UIBarButtonItem *)sender {
    if (![self.textServerAddress.text isEqualToString:[[AppDelegate App] serverAddress]]) {
        NSString *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *plistFileName = @"Settings.plist";
        NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
        NSDictionary *serverSettingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.textServerAddress.text, [AppDelegate App].fileAddress, nil]
                                                                       forKeys:[NSArray arrayWithObjects: @"server address", @"file address", nil]];
        NSPropertyListFormat format;
        NSString *errorDesc = nil;
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
        NSMutableDictionary *plistDict = [[NSPropertyListSerialization
                                           propertyListFromData:plistXML
                                           mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                           format:&format
                                           errorDescription:&errorDesc] mutableCopy];
        [plistDict setObject:serverSettingsDict forKey:@"Server Settings"];
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&error];
        
        if ([[NSFileManager defaultManager] isWritableFileAtPath:plistPath]) {
            if(plistData) {
                [plistData writeToFile:plistPath atomically:YES];
            }
        }
        [AppDelegate App].serverAddress=self.textServerAddress.text;
    }
    [self.dataDownLoader startDownLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinished) name:DOWNLOADFINISHNOTI object:nil];
}

- (void)downLoadFinished{
    [self dismissModalViewControllerAnimated:YES];
}

@end
