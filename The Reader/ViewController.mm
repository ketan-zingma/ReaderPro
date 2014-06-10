/**
 ClassName::		 ViewController
 
 Superclass::		 UIViewController
 
 Class Description:: This class is main class of application having functionality of power button , clap sound.
 
 Version::           1.0
 
 Author::            Ketan Parekh
 
 Created Date::      03/12/12
 
 Modified Date::     18/12/12
 
 Copy Right::        Clarion Technologies
 */

#import "ViewController.h"
#import <iAd/iAd.h>
#import "SEFilterControl.h"
#import "ImageTextVC.h"
#import "baseapi.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "InfoVC.h"
static NSString* kAppId = @"485514334825660"; // Mobileclarion3 == Reader Pro
@implementation ViewController
@synthesize filter;
@synthesize strobeTimer, strobeFlashTimer, powerButton,recorder;
@synthesize strobeActivated;
@synthesize flashController,facebook,permissions;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)show
{
    if(HUD)
        [HUD removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[[[UIApplication sharedApplication] keyWindow] addSubview:HUD];
    [HUD show:YES];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initialize Facebook
    facebook = [[Facebook alloc] initWithAppId:kAppId andDelegate:self];
    permissions = [[NSArray alloc] initWithObjects:@"email",@"publish_actions",nil];
    
    // init the tesseract engine.
    self.navigationController.navigationBarHidden = YES;
    appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    imgPickerController = [[UIImagePickerController alloc] init];
    
    strobeIsOn = NO;
	strobeActivated = NO;
	strobeFlashOn = NO;
	
	flashController = [[FlashController alloc] init];
	// Slider Control ======
    self.filter = [[SEFilterControl alloc]initWithFrame:CGRectMake(40, 367, 240, 35) Titles:[NSArray arrayWithObjects:@"|", @"|", @"|", @"|", @"|", @"|", @"|", @"|", @"|", @"|", @"|", nil]];
    [filter addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:filter];
    
    t=  0.300000011920929;
	self.strobeTimer = [NSTimer scheduledTimerWithTimeInterval:t target:self selector:@selector(strobeTimerCallback:) userInfo:nil repeats:YES];
	self.strobeFlashTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(strobeFlashTimerCallback:) userInfo:nil repeats:YES];
    [filter setSelectedIndex:0];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [filter release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    // iAd delegate Set ====
    if(appDelegate.isiAdLoaded)
        [self performSelector:@selector(iAdLoaded)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdLoaded) name:@"AddBannerViewDidLoaded" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdLoadingFalied) name:@"AddBannerViewDidFaliedToLoad" object:nil];
    // iAd ===========
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationPortrait == interfaceOrientation);
}
#pragma mark - FBDialogDelegate Methods

/**
 * Called when a UIServer Dialog successfully return. Using this callback
 * instead of dialogDidComplete: to properly handle successful shares/sends
 * that return ID data back.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url
{
    if (![url query])
    {
        NSLog(@"User canceled dialog or there was an error");
        return;
    }
    //NSDictionary *params = [self parseURLParams:[url query]];

}

- (void) dialogDidNotComplete:(FBDialog *)dialog
{
    NSLog(@"Dialog dismissed.");
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
}

/**
 * Helper method to parse URL query parameters
 */
- (NSDictionary *) parseURLParams:(NSString *)query {
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}
#pragma mark - Wall post view 
-(IBAction)Close:(id)sender
{
    [self fadeOut];
}
- (void)fadeIn
{
    [self.view addSubview:imgPost];
    imgPost.transform = CGAffineTransformMakeScale(1.3, 1.3);
    imgPost.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        imgPost.alpha = 1;
        imgPost.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        imgPost.transform = CGAffineTransformMakeScale(1.3, 1.3);
        imgPost.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [imgPost removeFromSuperview];
        }
    }];
}
-(IBAction) WallPost:(id)sender
{
    //The action links to be shown with the post in the feed
    //NSArray* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                                    @"Get Started",@"name",@"http://m.facebook.com/apps/hackbookios/",@"link", nil], nil];
    //NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
    
    // Dialog parameters
    [self show];
    [txtwallpost resignFirstResponder];
    UIImage *img  = [UIImage imageNamed:@"Upload.png"];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   img, @"picture",[NSString stringWithFormat:@"%@ \n  %@",txtwallpost.text,@"I'm using Reader Pro for iOS app is about to extract editable ASCII text from images.Also Additional functionality to copy text share converted text by EMAIL, text message."],@"message",nil];
    [facebook requestWithGraphPath:@"me/photos"
                         andParams:params
                     andHttpMethod:@"POST"
                       andDelegate:self];
    
    /*NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"I'm using Reader Pro for iOS app", @"name",
     @"Reader Pro for iOS.", @"caption",
     @"Check out Reader Pro for iOS is about to extract editable ASCII text from images. Also Additional functionality to copy text share converted text by EMAIL, text message.", @"description",
     @"http://www.facebookmobileweb.com/hackbook/img/facebook_icon_large.png", @"picture",
     nil];
     [facebook dialog:@"feed"
     andParams:params
     andDelegate:self];*/
    
}
#pragma mark - FBRequestDelegate Methods
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"received response");
}
- (void)request:(FBRequest *)request didLoad:(id)result
{
    txtwallpost.text = @"";
    [HUD hide:YES];
    [self fadeOut];
    
    UIAlertView *showalert = [[UIAlertView alloc]initWithTitle:@"Reader Pro" message:@"Post Sucessfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [showalert show];
    [showalert release];
    //[self showMessage:@"Photo uploaded successfully."];
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    [HUD hide:YES];
    //NSLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    
}
#pragma mark - FBSessionDelegate Methods

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin
{
    // Save authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [self fadeIn];
    //[self WallPost];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled
{
    [HUD hide:YES];
    //NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout
{
    [HUD hide:YES];
    //[self showLoggedOut:YES];
}
#pragma mark - URL Handle
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self.facebook handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //NSLog(@"%@ ==",self.HUD);
    [self show];
    return [self.facebook handleOpenURL:url];
}
#pragma mark - Slider Value change delegate
-(void)filterValueChanged:(SEFilterControl *) sender
{
    [self.strobeTimer invalidate];
	//Min = 0.0500000007450581
    //Max = 0.300000011920929
    //0.025000000112
    t = 0.300000011920929 - (0.025000000112*filter.SelectedIndex);
	self.strobeTimer = [NSTimer scheduledTimerWithTimeInterval:t target:self selector:@selector(strobeTimerCallback:) userInfo:nil repeats:YES];
    lblSpeed.text = [NSString stringWithFormat:@"%d",filter.SelectedIndex];
}

#pragma mark - Private Methods 
/*!
 @method      SetRecorder
 @abstract    It is an Method for Set Recorder object. 
 @discussion
 @result      Set Recorder object for clap sound detection.
 */
- (void) SetRecorder
{
    // Clap Recorder ====
    [btnClap setImage:[UIImage imageNamed:@"ClapSelected.png"] forState:UIControlStateNormal];
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error: nil];
    [audioSession setActive:YES error: nil];
    
    NSURL *url = [NSURL fileURLWithPath:@"dev/null"];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    self.recorder = nil;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (self.recorder)
    {
         //NSLog(@"%@ ====",[self.recorder description]);
        [self.recorder prepareToRecord];
        self.recorder.meteringEnabled = YES;
    }
}
/*!
 @method      ReleaseRecorder
 @abstract    It is an Method for Release Recorder object.
 @discussion
 @result      Release Recorder object of clap sound detection.
 */
-(void) ReleaseRecorder
{
//    if(recorder)
//        [recorder release];
//    if(levelTimer && [levelTimer isValid])
//        [levelTimer invalidate];
    [btnClap setImage:[UIImage imageNamed:@"Clap.png"] forState:UIControlStateNormal];
    if(recorder)
    {
        recorder = nil;
        [recorder release];
    }
    if(levelTimer)
    {
        [levelTimer invalidate];
        levelTimer = nil;
    }
    if(strobeActivated)
    {
        [powerButton setImage:[UIImage imageNamed:@"PowerD.png"] forState:UIControlStateNormal];
        strobeActivated = NO;
    }
    [self startStopStrobe:strobeActivated];
    
}
/*!
 @method      strobeTimerCallback
 @abstract
 @discussion
 @result      
 */

- (void)strobeTimerCallback:(id)sender
{
	if (strobeActivated)
    {
		strobeIsOn = !strobeIsOn;
		strobeFlashOn = YES;
	}
    else
    {
		strobeFlashOn = NO;
	}
}
/*!
 @method      strobeFlashTimerCallback
 @abstract
 @discussion
 @result
 */
- (void)strobeFlashTimerCallback:(id)sender
{
	if (strobeFlashOn)
    {
		strobeFlashOn = !strobeFlashOn;
		[self startStopStrobe:strobeIsOn];
	}
    else
    {
		[self startStopStrobe:NO];
	}
}
/*!
 @method      powerButtonPressed
 @abstract
 @discussion
 @result
 */
- (IBAction)powerButtonPressed:(id)sender
{
	if(strobeActivated)
    {
        [powerButton setImage:[UIImage imageNamed:@"PowerD.png"] forState:UIControlStateNormal];
		strobeActivated = NO;
	}
    else
    {
       [powerButton setImage:[UIImage imageNamed:@"Power.png"] forState:UIControlStateNormal];
		strobeActivated = YES;
	}
	[self startStopStrobe:strobeActivated];
}
/*!
 @method      btnCamera_Clap
 @abstract
 @discussion
 @result
 */
-(IBAction)btnCamera_Clap
{
    if(self.recorder)
    {
        [self ReleaseRecorder];
    }
    else
    {
        [self SetRecorder];
        [self.recorder record];
        lowPassResults = 0.0;
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }
}
/*!
 @method      levelTimerCallback
 @abstract
 @discussion
 @result
 */
- (void)levelTimerCallback:(NSTimer *)timer
{
    [self.recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    //NSLog(@"Average input: %f Peak input: %f Low pass results: %f peakPowerForChannel %f", [self.recorder averagePowerForChannel:0], [self.recorder peakPowerForChannel:0], lowPassResults,peakPowerForChannel);
    //if (lowPassResults > 0.80000  && lowPassResults < 0.95000)
    if (lowPassResults > 0.65000 && lowPassResults < 0.67000)
    {
     
        [self.recorder pause];
		if(strobeActivated)
        {
            [powerButton setImage:[UIImage imageNamed:@"PowerD.png"] forState:UIControlStateNormal];
            strobeActivated = NO;
        }
        else
        {
            [powerButton setImage:[UIImage imageNamed:@"Power.png"] forState:UIControlStateNormal];
            strobeActivated = YES;
        }
        [self startStopStrobe1:strobeActivated];
    }
}
/*!
 @method      btnCamera_Clicked
 @abstract
 @discussion
 @result
 */
-(IBAction)btnCamera_Clicked
{
    [self ReleaseRecorder];
    /*if(!strobeActivated)
    {
        [powerButton setImage:[UIImage imageNamed:@"Power.png"] forState:UIControlStateNormal];
        strobeActivated = YES;
    }*/
    [self startStopStrobe:strobeActivated];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self loadPhotoPick];
    }
    else
    {
        UIAlertView *showalert = [[UIAlertView alloc]initWithTitle:@"Reader Pro" message:@"No camera device found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [showalert show];
        [showalert release];
    }
}
/*!
 @method      btnShareClick
 @abstract
 @discussion
 @result
 */
-(IBAction)btnShareClick
{
    if(self.recorder)
    {
        [self ReleaseRecorder];
    }
    
    NSArray *options = [NSArray arrayWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"facebook.png"],@"img",@"Facebook",@"text", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"twitter.png"],@"img",@"Twitter",@"text", nil],nil];
    LeveyPopListView *lplv = [[LeveyPopListView alloc] initWithTitle:@"Share Application" options:options];
    lplv.delegate = self;
    [lplv showInView:self.view animated:YES];
    [lplv release];
}
/*!
 @method      btnInfoClick
 @abstract
 @discussion
 @result
 */
-(IBAction)btnInfoClick
{
    if(self.recorder)
    {
        [self ReleaseRecorder];
    }
    InfoVC *objInfoVC = [[InfoVC alloc] initWithNibName:@"InfoVC" bundle:Nil];
    [self.navigationController pushViewController:objInfoVC animated:YES];
    [objInfoVC release];

}
/*!
 @method      loadPhotoPick
 @abstract
 @discussion
 @result
 */
- (void)loadPhotoPick 
{
	imgPickerController.delegate = self;
	imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	imgPickerController.mediaTypes = [NSArray arrayWithObject:@"public.image"];
	imgPickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
	imgPickerController.allowsEditing = NO;
	imgPickerController.showsCameraControls = YES;
    [self presentViewController:imgPickerController animated:YES completion:nil];
}
/*!
 @method      startStopStrobe1
 @abstract
 @discussion
 @result
 */
- (void)startStopStrobe1:(BOOL)strobeOn
{
    [self.recorder record];
	if (strobeOn || (t >= 0.29 && strobeActivated))
    {
		[flashController toggleStrobe:YES];
	}
    else
    {
		[flashController toggleStrobe:NO];
	}
}
/*!
 @method      startStopStrobe
 @abstract
 @discussion
 @result
 */
- (void)startStopStrobe:(BOOL)strobeOn
{
  	if (strobeOn || (t >= 0.29 && strobeActivated))
    {
		[flashController toggleStrobe:YES];
	}
    else
    {
		[flashController toggleStrobe:NO];
	}
}
#pragma mark - leveyPopListView Delegate
-(BOOL)isTwitterAvailable
{
    return NSClassFromString(@"TWTweetComposeViewController") != nil;
}

-(BOOL)isSocialAvailable
{
    return NSClassFromString(@"SLComposeViewController") != nil;
}
- (void)leveyPopListViewDidCancel
{
    
}
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
   if(anIndex == 0)
   {
      
       
       if (![facebook isSessionValid])
       {
           facebook.sessionDelegate = self;
           [facebook authorize:permissions];
       }
       else
       {
           [self fadeIn];
           //[self WallPost];
       }
   }
   else if(anIndex ==1)
   {
        if ([self isSocialAvailable])
        {
            // code to tweet with SLComposeViewController
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:@"I'm using Reader Pro for iOS app is about to extract editable ASCII text from images."];
                [tweetSheet addImage:[UIImage imageNamed:@"Icon@2x.png"]];
                [self presentViewController:tweetSheet animated:YES completion:nil];
                
                [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                    
                    NSString *output = @"";
                    switch (result)
                    {
                        case SLComposeViewControllerResultCancelled:
                            //[HUD hide:YES];
                            output = @"ActionCancelled";
                            break;
                        case SLComposeViewControllerResultDone:
                        {
                            output = @"Tweet Successfully !!!";
                            //[HUD hide:YES];
                            UIAlertView *showalert = [[UIAlertView alloc]initWithTitle:@"Reader Pro" message:output delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [showalert show];
                            [showalert release];
                            break;
                        }
                        default:
                            break;
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                //Also Additional functionality to copy text share converted text by EMAIL, text message
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc]
                initWithTitle:@"Sorry"
                message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                delegate:self
                cancelButtonTitle:@"OK"
                otherButtonTitles:nil];
                [alertView show];
            }
       }
       else if ([self isTwitterAvailable])
       {
           TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
           // Set the initial tweet text. See the framework for additional properties that can be set.
           [tweetViewController setInitialText:@"I'm using Reader Pro for iOS app is about to extract editable ASCII text from images."];
           [tweetViewController addImage:[UIImage imageNamed:@"Icon@2x.png"]];
           // Create the completion handler block.
           [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result)
            {
                switch (result)
                {
                    case TWTweetComposeViewControllerResultCancelled:
                        // The cancel button was tapped.
                        NSLog(@"Successfully not Uploading image on twitter");
                        break;
                    case TWTweetComposeViewControllerResultDone:
                    {
                        // The tweet was sent.
                        UIAlertView *showalert = [[UIAlertView alloc]initWithTitle:@"Reader Pro" message:@"Tweet Successfully !!!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [showalert show];
                        [showalert release];
                        NSLog(@"Successfully Uploading image on twitter");
                        break;
                    }
                    default:
                        break;
                }
                
                // Dismiss the tweet composition view controller.
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            ];
         
           // Present the tweet composition view controller modally.
           [self presentViewController:tweetViewController animated:YES completion:nil];
       }
       else
       {
           // Twitter not available, or open a url like https://twitter.com/intent/tweet?text=tweet%20text
       }
       
   }
}
#pragma mark - Ad Banner ====
/*!
 @method iAdLoaded
 @discussion iAd Banner
 @result iAd banner loading
 */
- (void)iAdLoaded
{
    [self.view addSubview:appDelegate.adView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [appDelegate.adView setFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    //viewContainer.frame = CGRectMake(0, 0, ContainerViewWidthForiPhone, ContainerViewWithiAdHeightForiPhone);
    [UIView commitAnimations];
}
/*!
 @method iAdLoadingFalied
 @discussion iAd Banner
 @result iAd banner Failed
 */
- (void)iAdLoadingFalied
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [appDelegate.adView removeFromSuperview];
    //viewContainer.frame = CGRectMake(0, 0, ContainerViewWidthForiPhone, ContainerViewDefaultHeightForiPhone);
    [UIView commitAnimations];
}
//- (void)bannerViewDidLoadAd:(ADBannerView *)banner
//{
//	if(!bannerIsVisible)
//    {
//		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
//		// assumes the banner view is at the top of the screen.
//		banner.frame = CGRectOffset(banner.frame, 0, 70);
//		[UIView commitAnimations];
//		bannerIsVisible = YES;
//	}
//}
//
//- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
//{
//	if(bannerIsVisible)
//    {
//		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
//		// assumes the banner view is at the top of the screen.
//		banner.frame = CGRectOffset(banner.frame, 0, -70);
//		[UIView commitAnimations];
//		bannerIsVisible = NO;
//	}
//}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image  editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    
    ImageTextVC *objImageTextVC = [[ImageTextVC alloc] initWithNibName:@"ImageTextVC" bundle:Nil];
    objImageTextVC.img = image;
    [self.navigationController pushViewController:objImageTextVC animated:YES];
    [objImageTextVC release];
}

#pragma mark - memory management

- (void)dealloc
{
    [permissions release];
    [facebook release];
    [recorder release];
    [levelTimer release];
    [imgPickerController release];
    imgPickerController = nil;
    
    [super dealloc];
}


@end
