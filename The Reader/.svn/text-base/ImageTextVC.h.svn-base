/**
 ClassName::		 ImageTextVC
 
 Superclass::		 UIViewController
 
 Class Description:: This is Detail view for display Image ti text convert.
 
 Version::           1.0
 
 Author::            Ketan Parekh
 
 Created Date::      06/12/12
 
 Modified Date::     18/12/12
 
 Copy Right::        Clarion Technologies
 */


#import <UIKit/UIKit.h>
#import "baseapi.h"
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import "ISpeechSDK.h"
#import "AppDelegate.h"
@interface ImageTextVC : UIViewController<MBProgressHUDDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,ISSpeechRecognitionDelegate,ISSpeechSynthesisDelegate>
{
    TessBaseAPI *tess;
    AppDelegate *appDelegate;
    MBProgressHUD *HUD;
    UIImage *img;
    IBOutlet UITextView *txtView;
    NSString *strConverted;
}
@property(nonatomic,retain)    UIImage *img;
@property(nonatomic,retain)    NSString *strConverted;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;

@end
