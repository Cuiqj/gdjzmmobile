//
//  PaintBriefViewController.h
//  GDRMMobile
//
//  Created by yu hongwu on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PaintBriefOfAdministrativePenaltyViewController.h"
#import "PaintHeader.h"
@interface PaintBriefOfAdministrativePenaltyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *Image;
@property (nonatomic,retain) NSString *caseID;

- (void)loadCasePaint;
@end
