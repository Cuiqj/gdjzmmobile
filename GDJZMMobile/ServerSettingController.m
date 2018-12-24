//
//  ServerSettingController.m
//  GDRMMobile
//
//  Created by yu hongwu on 12-2-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ServerSettingController.h"


@interface ServerSettingController()
@property (retain, nonatomic) DataDownLoad *dataDownLoader;
@property (retain, nonatomic) DataUpLoad *dataUploader;
- (void)upLoadFinished;
- (void)downLoadFinished;
@end

@implementation ServerSettingController
@synthesize activityIndicator=_activityIndicator;
@synthesize txtServer=_txtServer;
@synthesize txtFile=_txtFile;
@synthesize uibuttonInit = _uibuttonInit;
@synthesize uibuttonReset = _uibuttonReset;
@synthesize uibuttonUpload = _uibuttonUpload;
@synthesize dataDownLoader = _dataDownLoader;
@synthesize dataUploader = _dataUploader;

- (DataUpLoad *)dataUploader{
    _dataUploader = nil;
    if (_dataUploader == nil) {
        _dataUploader = [[DataUpLoad alloc] init];
    }
    return _dataUploader;
}


- (DataDownLoad *)dataDownLoader{
    _dataDownLoader = nil;
    if (_dataDownLoader == nil) {
        _dataDownLoader = [[DataDownLoad alloc] init];
    }
    return _dataDownLoader;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [self setDataDownLoader:nil];
    [self setDataUploader:nil];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.txtServer.text = [AppDelegate App].serverAddress;  
    self.txtFile.text = [AppDelegate App].fileAddress;
    
    NSString *imagePath=[[NSBundle mainBundle] pathForResource:@"小按钮" ofType:@"png"];
    UIImage *btnImage=[[UIImage imageWithContentsOfFile:imagePath] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [self.uibuttonInit setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonReset setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.uibuttonUpload setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    imagePath=[[NSBundle mainBundle] pathForResource:@"服务器参数设置 -bg" ofType:@"png"];
    self.view.layer.contents=(id)[[UIImage imageWithContentsOfFile:imagePath] CGImage];

    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setTxtServer:nil];
    [self setTxtFile:nil];
    [self setActivityIndicator:nil];
    [self setUibuttonInit:nil];
    [self setUibuttonReset:nil];
	[self setUibuttonUpload:nil];
    [self setDataDownLoader:nil];
    [self setDataUploader:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)btnSave:(id)sender {
    NSString *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *plistFileName = @"Settings.plist";
    NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
    NSDictionary *serverSettingsDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.txtServer.text, self.txtFile.text, nil]  
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
    [AppDelegate App].serverAddress=self.txtServer.text;
    [AppDelegate App].fileAddress=self.txtFile.text;
    [self.view endEditing:YES];
}

- (IBAction)btnInitData:(id)sender {
    [self.dataDownLoader startDownLoad];
}

- (IBAction)btnUpLoadData:(UIButton *)sender {
    [self.view endEditing:YES];
    [self btnSave:nil];
    NSString *inspectionID=[[NSUserDefaults standardUserDefaults] valueForKey:INSPECTIONKEY];
    if (![inspectionID isEmpty] && inspectionID!=nil) {
        void(^ShowAlert)(void)=^(void){
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误" message:@"当前还有未完成的巡查，请先交班再上传业务数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        MAINDISPATCH(ShowAlert);
    } else {
        if ([WebServiceHandler isServerReachable]) {
            [self.dataUploader uploadData];
        }
    }
}


- (void)downLoadFinished{
    self.dataDownLoader = nil;
}

- (void)upLoadFinished{
    self.dataUploader = nil;
}

- (IBAction)btnUser:(id)sender {
    //初始化使用机内文书格式设置
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *plistFileName = @"Settings.plist";
    NSString *plistPath = [libraryDirectory stringByAppendingPathComponent:plistFileName];
    NSPropertyListFormat format;
    NSString *errorDesc;
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *settings = (NSDictionary *)[NSPropertyListSerialization
                                                    propertyListFromData:plistXML
                                                        mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                  format:&format
                                                        errorDescription:&errorDesc];
    NSDictionary *tables = [settings objectForKey:@"FileToTableMapping"];
    NSArray *fileArray = [tables allValues];
    for (NSString * docXMLSettingFileName in fileArray) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString *libraryDirectory = [paths objectAtIndex:0];
        NSString *docXMLSettingFilesPath = [[NSBundle mainBundle] pathForResource:docXMLSettingFileName ofType:@"xml"];
        NSString *temp=[docXMLSettingFileName stringByAppendingString:@".xml"];
        NSString *destPath=[libraryDirectory stringByAppendingPathComponent:temp];
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:&error];
        if(docXMLSettingFilesPath)
            [[NSFileManager defaultManager] copyItemAtPath:docXMLSettingFilesPath toPath:destPath error:&error];
    }
}

@end
