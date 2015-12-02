#import "SIMProductViewController.h"
#import <PassKit/PassKit.h>
#import <Simplify/SIMSimplify.h>
#import <Simplify/SIMChargeCardViewController.h>
#import <Simplify/UIImage+Simplify.h>
#import <Simplify/UIColor+Simplify.h>
#import <Simplify/SIMResponseViewController.h>
#import <Simplify/SIMTokenProcessor.h>
#import <Simplify/SIMWaitingView.h>

//1. Sign up to be a SIMChargeViewControllerDelegate so that you get the callback that gives you a token
@interface SIMProductViewController ()<SIMChargeCardViewControllerDelegate>
@property (nonatomic, strong) SIMChargeCardViewController *chargeController;
@property (strong, nonatomic) IBOutlet UIButton *buyButton;
@property (strong, nonatomic) UIColor *primaryColor;

@end

@implementation SIMProductViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.primaryColor = [UIColor colorWithRed:241.0/255.0 green:100.0/255.0 blue:33.0/255.0 alpha:1.0];
    [self.buyButton setBackgroundColor:self.primaryColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self buySimplifyButton:nil];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Navigation
- (IBAction)buySimplifyButton:(id)sender {
    
        PKPaymentSummaryItem *mposButtons = [[PKPaymentSummaryItem alloc] init];
        mposButtons.label = @"mPOS Buttons";
        mposButtons.amount = [[NSDecimalNumber alloc] initWithString:@"0.50"];
        
        PKPaymentRequest* paymentRequest = [[PKPaymentRequest alloc] init];
        paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        paymentRequest.countryCode = @"US";
        paymentRequest.currencyCode = @"USD";
    
        //2. SDKDemo.entitlements needs to be updated to use the new merchant id
        paymentRequest.merchantIdentifier = @"ddd";
    
        paymentRequest.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS;
        paymentRequest.paymentSummaryItems = @[mposButtons];
        paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
        paymentRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress;

        //3. Create a SIMChargeViewController with your public api key
        SIMChargeCardViewController *chargeController = [[SIMChargeCardViewController alloc] initWithPublicKey:@"lvpb_sbpb_Yjc1ZmU1MzEtYjIyNy00ZDJkLWJmZDAtNzMwNmRjZTlhNzBm" paymentRequest:paymentRequest primaryColor:self.primaryColor];
    
        //4. Assign your class as the delegate to the SIMChargeViewController class which takes the user input and requests a token
        chargeController.delegate = self;
        chargeController.amount = mposButtons.amount;
        chargeController.isCVCRequired = NO;
        chargeController.isZipRequired = YES;
        self.chargeController = chargeController;

        //5. Add SIMChargeViewController to your view hierarchy
        [self presentViewController:self.chargeController animated:YES completion:nil];
    
}

#pragma mark - SIMChargeViewController Protocol
-(void)chargeCardCancelled {
    //User cancelled the SIMChargeCardViewController
    [self.chargeController dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"User Cancelled");
}

-(void)creditCardTokenFailedWithError:(NSError *)error {

    //There was a problem generating the token
    NSLog(@"Card Token Generation failed with error:%@", error);
    SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:nil primaryColor:self.primaryColor title:@"Failure." description:@"There was a problem with the payment.\nPlease try again."];
    viewController.isPaymentSuccessful = NO;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

//6. This method will be called on your class whenever the user presses the Charge Card button and tokenization succeeds
-(void)creditCardTokenProcessed:(SIMCreditCardToken *)token {
    //Token was generated successfully, now you must use it
    //Process Request on your own server
    //See https://github.com/simplifycom/simplify-php-server for a sample implementation.

    NSURL *url= [NSURL URLWithString:@"<#INSERT_YOUR_SIMPLIFY_SERVER_HERE#>"];
    
    SIMWaitingView *waitingView = [[SIMWaitingView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:waitingView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];

    NSString *postString = [NSString stringWithFormat:@"simplifyToken=%@&amount=50", token.token];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *paymentTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        [waitingView removeFromSuperview];
        
        NSString *responseData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        BOOL isResponseApproved = [responseData containsString:@"APPROVED"];
        NSLog(@"response:%@", responseData);
        
        if (error || !isResponseApproved) {

            NSLog(@"error:%@", error);
            SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:nil primaryColor:self.primaryColor title:@"Failure." description:@"There was a problem with the payment.\nPlease try again."];
            viewController.isPaymentSuccessful = NO;
            [self presentViewController:viewController animated:YES completion:nil];
            
        } else {
            
            SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:nil primaryColor:self.primaryColor title:@"Success!" description:@"You purchased a pack of buttons!"];
            viewController.isPaymentSuccessful = YES;
            [self presentViewController:viewController animated:YES completion:nil];
        }
    }];
    
    [paymentTask resume];
    
    
}

@end
