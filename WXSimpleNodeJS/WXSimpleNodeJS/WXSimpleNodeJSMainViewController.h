//
//  WXSimpleNodeJSMainViewController.h
//  WXSimpleNodeJS
//
//  Created by Wei Xie on 2015-06-05.
//  Copyright (c) 2015 Wei Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXSimpleNodeJSMainViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *responseStringLabel;
@property (strong, nonatomic) IBOutlet UILabel *responseMessageLable;

- (IBAction)getResponse:(id)sender;
- (IBAction)clear:(id)sender;
@end
