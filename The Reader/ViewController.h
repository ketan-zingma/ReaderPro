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

#import <UIKit/UIKit.h>
#import "FlashController.h"
#import "SEFilterControl.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "LeveyPopListView.h"
#import "FBConnect.h"
#import "MBProgressHUD.h"
@class MBProgressHUD;

@interface ViewController : UIViewController<ADBannerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LeveyPopListViewDelegate,MBProgressHUDDelegate,FBRequestDelegate,FBDialogDelegate,FBSessionDelegate>
{
    NSTimer *strobeTimer;
    AppDelegate *appDelegate;
	NSTimer *strobeFlashTimer;
    MBProgressHUD *HUD;
    NSArray *permissions;
	BOOL strobeIsOn; // For our code to turn strobe on and off
	BOOL strobeActivated; // To allow user to turn off the light all together
	BOOL strobeFlashOn; // For our code to turn strobe on and off rapidly

	IBOutlet UIButton *powerButton;
	BOOL bannerIsVisible;
	
	FlashController *flashController;
    UIImagePickerController *imgPickerController;
    SEFilterControl *filter;
    double t;
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    double lowPassResults;
    IBOutlet UILabel *lblSpeed;
    IBOutlet UIButton *btnClap;
    IBOutlet UIView *imgPost;
    IBOutlet UITextView *txtwallpost;
    Facebook *facebook;
}
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) AVAudioRecorder *recorder;
@property (nonatomic, retain) NSTimer *strobeTimer;
@property (nonatomic, retain) NSTimer *strobeFlashTimer;
@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) IBOutlet UIButton *powerButton;


@property (nonatomic, assign) BOOL strobeActivated;
@property (nonatomic, assign) SEFilterControl *filter;
@property (nonatomic, retain) FlashController *flashController;

- (IBAction)powerButtonPressed:(id)sender;
- (void)strobeTimerCallback:(id)sender;
- (void)strobeFlashTimerCallback:(id)sender;
- (void)startStopStrobe:(BOOL)strobeOn;
-(IBAction)btnCamera_Clicked;
- (void)loadPhotoPick;

@end
