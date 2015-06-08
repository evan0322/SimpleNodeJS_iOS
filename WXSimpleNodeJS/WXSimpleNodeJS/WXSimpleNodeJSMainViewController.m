//
//  WXSimpleNodeJSMainViewController.m
//  WXSimpleNodeJS
//
//  Created by Wei Xie on 2015-06-05.
//  Copyright (c) 2015 Wei Xie. All rights reserved.
//

#import "WXSimpleNodeJSMainViewController.h"

@interface WXSimpleNodeJSMainViewController ()

@property (nonatomic,strong) NSString *responseString;
@property (nonatomic,strong) NSString *responseMessage;
@property (nonatomic,strong) NSDictionary *responseDictionary;

@end

@implementation WXSimpleNodeJSMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.responseStringLabel.text = @"";
    self.responseMessageLabel.text = @"";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getResponse:(id)sender {
    self.responseStringLabel.text = @"Loading..";
    self.responseMessageLabel.text = @"Loading..";
    NSURL *url = [[NSURL alloc] initWithString:@"https://wxsimplenodejs.herokuapp.com/entrust"];
    NSMutableURLRequest *httpRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [httpRequest setHTTPMethod:@"GET"];
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration defaultSessionConfiguration];
    conf.timeoutIntervalForRequest = 15.0;
    conf.timeoutIntervalForResource = 15.0;
    conf.HTTPMaximumConnectionsPerHost = 1;
    conf.allowsCellularAccess = YES;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:conf];
    NSLog(@"start to fetch message from the server..");
    [[session dataTaskWithRequest:httpRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@" Got message from the server..");
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
        if (!error && [httpResponse statusCode] == 200) {
            self.responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            self.responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            if (!error) {
                NSDictionary *address = self.responseDictionary[@"Address"];
                NSString *name = self.responseDictionary[@"Name"];
                NSString *group = self.responseDictionary[@"Group"];
                NSString *country = address[@"Country"];
                NSString *province = address[@"Province"];
                NSString *city = address[@"City"];
                self.responseMessage = [NSString stringWithFormat:@"The company %@ belongs to group %@ and is located at %@, %@, %@. ", name,group,city,province,country];
                [self setResponseStringLabelText:self.responseString andReponseMessageLabelText:self.responseMessage];
            } else {
                NSLog(@"Fail to parse response from the server");
            }
        } else {
            NSString *errorMessage = [NSString stringWithFormat:@"Fail to get response from the server, error code:%ld",[httpResponse statusCode]];
            NSLog(@"%@",errorMessage);
            [self setResponseStringLabelText:@"" andReponseMessageLabelText:errorMessage];
        }
    }] resume];
}

- (void) setResponseStringLabelText:(NSString *)responseString andReponseMessageLabelText:(NSString *)responseMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.responseStringLabel.text = responseString;
        self.responseMessageLabel.text = responseMessage;
    });
}

- (IBAction)clear:(id)sender {
    self.responseStringLabel.text = @"";
    self.responseMessageLabel.text = @"";
}
@end
