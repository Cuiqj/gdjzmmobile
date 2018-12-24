//
//  getOldCase.m
//  GDJZMMobile
//
//  Created by 田康 on 16/8/3.
//
//
/*
#import "getOldCase.h"
@implementation getOldCase

static NSString *dataNameArray[10]={@"CaseDeformation",@"CaseInfo",@"CaseInquire",@"CaseProveInfo",@"CaseServiceFiles",@"CaseServiceReceipt",@"Citizen",@"CaseMap",@"CaseInvestigate",@"CaseEnd"};
-(void)downLoadOldCase{
    WebServiceInit;
    [service downloadDataSet:@"select * from FileCode"];
}




- (void)xmlParser:(NSString *)webString{
    [self autoParserForDataModel:@"FileCode" andInXMLString:webString];
}

@end


#import "DataUpLoad.h"
#import "AGAlertViewWithProgressbar.h"
#import "TBXML.h"
#import "UploadRecord.h"

//所需上传的表名称
//modify by 田康 2016.08.3


//static NSString *dataNameArray[UPLOADCOUNT]={@"CaseMap"};

@interface DataUpLoad()
@property (nonatomic,assign) NSInteger currentWorkIndex;
@property (nonatomic,retain) AGAlertViewWithProgressbar *progressView;
@property (nonatomic,retain) UploadRecord* uploadedRecord;
- (void)uploadDataAtIndex:(NSInteger)index;
- (void)uploadFinished;
@end

@implementation DataUpLoad
@synthesize currentWorkIndex = _currentWorkIndex;
@synthesize progressView = _progressView;
@synthesize uploadedRecord = _uploadedRecord;

- (void)uploadData{
    self.progressView=[[AGAlertViewWithProgressbar alloc] initWithTitle:@"上传业务数据" message:@"正在上传，请稍候……" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    MAINDISPATCH(^(void){
        [self.progressView show];
    });
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self uploadDataAtIndex:self.currentWorkIndex];
}

- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFinished) name:UPLOADFINISH object:nil];
        self.currentWorkIndex = 0;
        _uploadedRecord = [[UploadRecord alloc] init];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setProgressView:nil];
}

//递归函数
- (void)uploadDataAtIndex:(NSInteger)index{
    NSString *currentDataName = dataNameArray[index];
    NSLog(@"%d", index);
    NSArray *dataArray = [NSClassFromString(currentDataName) uploadArrayOfObject];
    if (dataArray.count > 0) {
        NSString *dataTypeString = [NSClassFromString(currentDataName) complexTypeString];
        NSString *dataXML = @"";
        for (id obj in dataArray) {
            dataXML = [dataXML stringByAppendingString:[obj dataXMLString]];
            [_uploadedRecord addUploadedRecord:currentDataName WitdData:obj];
        }
        if (![dataXML isEmpty]) {
            NSString *uploadXML = [[NSString alloc] initWithFormat:@"%@\n"
                                   "<diffgr:diffgram xmlns:msdata=\"urn:schemas-microsoft-com:xml-msdata\" xmlns:diffgr=\"urn:schemas-microsoft-com:xml-diffgram-v1\">\n"
                                   "   <NewDataSet xmlns=\"\">\n"
                                   "       %@\n"
                                   "   </NewDataSet>\n"
                                   "</diffgr:diffgram>",dataTypeString,dataXML];
            
            WebServiceHandler *service=[[WebServiceHandler alloc] init];
            service.delegate=self;
            NSLog(@"%@\n%@", currentDataName, uploadXML);
            [service uploadDataSet:uploadXML];
        }
    } else {
        self.currentWorkIndex += 1;
        [self.progressView setProgress:(int)(((float)(self.currentWorkIndex)/(float)UPLOADCOUNT)*100.0)];
        if (self.currentWorkIndex < UPLOADCOUNT) {
            [self uploadDataAtIndex:self.currentWorkIndex];
        } else {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.progressView hide];
                UIAlertView *finishAlert = [[UIAlertView alloc] initWithTitle:@"消息" message:@"上传完毕" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [finishAlert show];
            });
        }
    }
}

- (void)uploadFinished{
    NSString *upLoadedDataName = dataNameArray[self.currentWorkIndex];
    NSArray *upLoadedDataArray = [NSClassFromString(upLoadedDataName) uploadArrayOfObject];
    for (id obj in upLoadedDataArray) {
        [obj setValue:@(YES) forKey:@"isuploaded"];
    }
    self.currentWorkIndex += 1;
    [self.progressView setProgress:(int)(((float)(self.currentWorkIndex)/(float)UPLOADCOUNT)*100.0)];
    if (self.currentWorkIndex < UPLOADCOUNT) {
        [self uploadDataAtIndex:self.currentWorkIndex];
    } else {
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView hide];
        });
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
    [_uploadedRecord didWriteDB];
}

- (void)getWebServiceReturnString:(NSString *)webString forWebService:(NSString *)serviceName{
    BOOL success = NO;
    TBXML *xml = [TBXML newTBXMLWithXMLString:webString error:nil];
    TBXMLElement *root = [xml rootXMLElement];
    TBXMLElement *r1 = root->firstChild;
    TBXMLElement *r2 = r1->firstChild;
    TBXMLElement *r3 = r2->firstChild;
    if (r3) {
        NSString *outString = [TBXML textForElement:r3];
        if (outString.boolValue) {
            success = YES;
        }
    }
    if (success) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UPLOADFINISH object:nil];
    } else {
        NSString *upLoadedDataName = dataNameArray[self.currentWorkIndex];
        NSString *message = [[NSString alloc] initWithFormat:@"上传%@出现错误",upLoadedDataName];
        NSLog(@"ERROR!:%@\n%@",upLoadedDataName, webString);
        [self.progressView setMessage:message];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView hide];
        });
    }
}

- (void)requestTimeOut{
    if (self.progressView.isVisible) {
        [self.progressView setMessage:@"网络连接超时，请检查网络连接是否正常。"];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView hide];
        });
    }
}

- (void)requestUnkownError{
    if (self.progressView.isVisible) {
        [self.progressView setMessage:@"网络连接错误，请检查网络连接或服务器地址设置。"];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.progressView hide];
        });
    }
}
@end
 
 
 */
