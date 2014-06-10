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

#import "ImageTextVC.h"
#import "baseapi.h"
#include <math.h>
static inline double radians (double degrees) {return degrees * M_PI/180;}


@interface ImageTextVC ()

@end

@implementation ImageTextVC
@synthesize img,strConverted,keyboardToolbar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Tollbar above key board =======
    keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width, 44)];
    keyboardToolbar.tintColor = [UIColor blackColor];
    UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemFlexibleSpace) target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemDone) target:self action:@selector(resignKeyboard:)];
    [keyboardToolbar setItems:[[NSArray alloc] initWithObjects:extraSpace, done, nil]];
    txtView.inputAccessoryView  = keyboardToolbar;
    //==================
    
    
    appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    [self startTesseract];
    self.strConverted= @"__";
	HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[[[UIApplication sharedApplication] keyWindow] addSubview:HUD];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // iAd delegate Set ====
    if(appDelegate.isiAdLoaded)
        [self performSelector:@selector(iAdLoaded)];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdLoaded) name:@"AddBannerViewDidLoaded" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(iAdLoadingFalied) name:@"AddBannerViewDidFaliedToLoad" object:nil];
    // iAd ===========
    if([strConverted isEqualToString:@"__"])
    {
        [HUD show:YES];
        [self performSelector:@selector(ImageToText) withObject:nil afterDelay:1.0];
    }
    else
        txtView.text = strConverted;
}
- (void) ImageToText
{
    UIImage *newImage = [self resizeImage:img];
    NSString *text = [self ocrImage:newImage];
    self.strConverted = text;
    txtView.text = text;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -

- (NSString *) applicationDocumentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	return documentsDirectoryPath;
}

#pragma mark -
#pragma mark Image Processsing
- (void) startTesseract
{
	//code from http://robertcarlsen.net/2009/12/06/ocr-on-iphone-demo-1043
    
	NSString *dataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"tessdata"];
	/*
	 Set up the data in the docs dir
	 want to copy the data to the documents folder if it doesn't already exist
	 */
	NSFileManager *fileManager = [NSFileManager defaultManager];
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:dataPath])
    {
		// get the path to the app bundle (with the tessdata dir)
		NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
		NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
		if (tessdataPath)
        {
			[fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
		}
	}
	
	NSString *dataPathWithSlash = [[self applicationDocumentsDirectory] stringByAppendingString:@"/"];
	setenv("TESSDATA_PREFIX", [dataPathWithSlash UTF8String], 1);
	
	// init the tesseract engine.
	tess = new TessBaseAPI();
	
	tess->SimpleInit([dataPath cStringUsingEncoding:NSUTF8StringEncoding],  // Path to tessdata-no ending /.
					 "eng",  // ISO 639-3 string or NULL.
					 false);
	
	
}

- (NSString *) ocrImage: (UIImage *) uiImage
{
	
	//code from http://robertcarlsen.net/2009/12/06/ocr-on-iphone-demo-1043
	
	CGSize imageSize = [uiImage size];
	double bytes_per_line	= CGImageGetBytesPerRow([uiImage CGImage]);
	double bytes_per_pixel	= CGImageGetBitsPerPixel([uiImage CGImage]) / 8.0;
	
	CFDataRef data = CGDataProviderCopyData(CGImageGetDataProvider([uiImage CGImage]));
	const UInt8 *imageData = CFDataGetBytePtr(data);
	
	// this could take a while. maybe needs to happen asynchronously.
	char* text = tess->TesseractRect(imageData,(int)bytes_per_pixel,(int)bytes_per_line, 0, 0,(int) imageSize.height,(int) imageSize.width);
	
	// Do something useful with the text!
	//NSLog(@"Converted text: %@",[NSString stringWithCString:text encoding:NSUTF8StringEncoding]);
   [HUD hide:YES];
	return [NSString stringWithCString:text encoding:NSUTF8StringEncoding];
}

-(UIImage *)resizeImage:(UIImage *)image
{
	
	CGImageRef imageRef = [image CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
	
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	int width, height;
	
	width = 640;//[image size].width;
	height = 640;//[image size].height;
	
	CGContextRef bitmap;
	
	if (image.imageOrientation == UIImageOrientationUp | image.imageOrientation == UIImageOrientationDown)
    {
		bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
		
	}
    else
    {
		bitmap = CGBitmapContextCreate(NULL, height, width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
		
	}
	
	if (image.imageOrientation == UIImageOrientationLeft)
    {
		NSLog(@"image orientation left");
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -height);
		
	}
    else if (image.imageOrientation == UIImageOrientationRight)
    {
		NSLog(@"image orientation right");
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -width, 0);
		
	}
    else if (image.imageOrientation == UIImageOrientationUp)
    {
		NSLog(@"image orientation up");
		
	}
    else if (image.imageOrientation == UIImageOrientationDown)
    {
		NSLog(@"image orientation down");
		CGContextTranslateCTM (bitmap, width,height);
		CGContextRotateCTM (bitmap, radians(-180.));
		
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;
}
#pragma mark - Speech delegate
- (void)recognition:(ISSpeechRecognition *)speechRecognition didGetRecognitionResult:(ISSpeechRecognitionResult *)result {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
	//NSLog(@"Result: %@", result.text);
	[speechRecognition release];
}

- (void)recognition:(ISSpeechRecognition *)speechRecognition didFailWithError:(NSError *)error {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
	NSLog(@"Error: %@", error);
	
	[speechRecognition release];
}

- (void)recognitionCancelledByUser:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
	
	[speechRecognition release];
}

- (void)recognitionDidBeginRecording:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}

- (void)recognitionDidFinishRecording:(ISSpeechRecognition *)speechRecognition {
	NSLog(@"Method: %@", NSStringFromSelector(_cmd));
}
- (void)synthesis:(ISSpeechSynthesis *)speechSynthesis didFailWithError:(NSError *)error
{
    NSLog(@"Error:======== %@", error);
 	[speechSynthesis release];
}
 - (void)synthesisDidStartSpeaking:(ISSpeechSynthesis *)speechSynthesis
{
    //NSLog(@"EEEEEEEEE");
}
 - (void)synthesisDidFinishSpeaking:(ISSpeechSynthesis *)speechSynthesis userCancelled:(BOOL)userCancelled
{
     	[speechSynthesis release];
}
#pragma mark - private Methods 
-(void) resignKeyboard:(id)sender
{
    if ([txtView isFirstResponder])
        [txtView resignFirstResponder];
}
-(IBAction)btnMailClick:(id)sender
{
    //NSLog(@"%@ ==",strConverted);
    if([strConverted isEqualToString:@""] || strConverted.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro" message:@"No converted text to share." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    MFMailComposeViewController *mailClass = [[[MFMailComposeViewController alloc] init] autorelease];
    if ([MFMailComposeViewController canSendMail])
    {
        
        mailClass.mailComposeDelegate = self;
        mailClass.title=@"E-mail your converted text (Reader Pro)";
        mailClass.navigationBar.tintColor = [UIColor colorWithRed:63.0/255 green:63.0/255 blue:73.0/255 alpha:0.0];
        
        [mailClass setSubject:@"Reader Pro"];
        NSMutableArray *arr=[[NSMutableArray alloc] init];
        [arr addObject:@""];
        [mailClass setToRecipients:arr];
        NSString *body= [NSString stringWithFormat:@"Hi, \n %@",strConverted];
        [mailClass setMessageBody:body isHTML:NO];
        [self presentViewController:mailClass animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro" message:@"Please set up your E-mail account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(IBAction)btnMessageClick:(id)sender
{
    if([strConverted isEqualToString:@""] || strConverted.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro" message:@"No converted text to share." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = [NSString stringWithFormat:@"%@" ,strConverted];
        controller.navigationBar.tintColor = [UIColor colorWithRed:63.0/255 green:63.0/255 blue:73.0/255 alpha:0.0];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro"
                                                        message:@"Decice can not send text message."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
-(IBAction)btnHomeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnSpeechClick:(id)sender
{
    if([txtView.text isEqualToString:@""] || txtView.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro" message:@"No converted text to Speech." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    NSArray *arr = [txtView.text componentsSeparatedByString:@" "];
    if([arr count] < 50)
    {
        ISSpeechSynthesis *synthesis = [[ISSpeechSynthesis alloc] initWithText:txtView.text];
        [synthesis setSpeed:-3];
        [synthesis setDelegate:self];
        NSError *err;
        
        if(![synthesis speak:&err])
        {
            NSLog(@"ERROR: %@", err);
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro" message:@"Sorry !!! Text to speech is up to 50 words only." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

#pragma mark -
#pragma mark message and mail Compose delegate--
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
		case MessageComposeResultCancelled:
			break;
        case MessageComposeResultFailed:
        {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro" message:@"Error :" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
			break;
        }
		case MessageComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro"
                                                            message:@"Message Sent!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            break;
        }
		default:
			break;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*!
 @method mailComposeController
 @abstract It is a mail Compose Controller delegate method.
 @discussion .
 @result .
 */
-(void)mailComposeController:(MFMailComposeViewController *)mailer didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro"
                                                            message:@"Email Sent!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            break;
        }
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            break;
        }
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Pro"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            break;
        }
    }
    
    [self becomeFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
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


@end
