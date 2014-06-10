/**
 ClassName::		 AppDelegate
 
 Superclass::		 UIViewController
 
 Class Description::
 
 Version::           1.0
 
 Author::            Ketan Parekh
 
 Created Date::      03/12/12
 
 Modified Date::     18/12/12
 
 Copy Right::        Clarion Technologies
 */

#import "AppDelegate.h"

#import "ViewController.h"
#import "iSpeechSDK.h"
@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize adView = _adView;
@synthesize isiAdLoaded;
- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // iAd
    self.adView = [[ADBannerView alloc]init];
    [self.adView setDelegate:self];

    
    [[iSpeechSDK sharedSDK] setAPIKey:@"041dbcb37af8bcafa1dc66365a6db82a"];
    //[[iSpeechSDK sharedSDK] setAPIKey:@"9bb736869cbba1d4cd062cb2cca95200"];
    // Override point for customization after application launch.
    ViewController *masterViewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    self.window.rootViewController = self.navigationController;
    
    //self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    //self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    [self loadData];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [self saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)loadData
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSString *filePath = [self myFilePath:@"StrobeDuration.archive"];
	
	if([fileManager fileExistsAtPath:filePath])
    {
		NSNumber *aNumber = [NSKeyedUnarchiver unarchiveObjectWithFile:[self myFilePath:@"StrobeDuration.archive"]];
		//[viewController.strobeSlider setValue:[aNumber floatValue]];
        [viewController.filter setSelectedIndex:[aNumber floatValue]];
	}
	else
    {
        
	}
	
	filePath = [self myFilePath:@"StrobeOnOff.archive"];
	
	if([fileManager fileExistsAtPath:filePath]) {
		NSNumber *aNumber = [NSKeyedUnarchiver unarchiveObjectWithFile:[self myFilePath:@"StrobeOnOff.archive"]];
		viewController.strobeActivated = [aNumber boolValue];
		
		if(viewController.strobeActivated) {
			[viewController.powerButton setImage:[UIImage imageNamed:@"powerbuttonon.png"] forState:UIControlStateNormal];
		} else {
			[viewController.powerButton setImage:[UIImage imageNamed:@"powerbuttonoff.png"] forState:UIControlStateNormal];
		}
	}
	else {
		viewController.strobeActivated = YES;
	}
	
	[viewController startStopStrobe:viewController.strobeActivated];
}

- (void)saveData {
//	CGFloat sliderValue = [viewController.strobeSlider value];
	CGFloat sliderValue = viewController.filter.SelectedIndex;
	NSNumber *tempNumber = [NSNumber numberWithFloat:sliderValue];
	[NSKeyedArchiver archiveRootObject:tempNumber toFile:[self myFilePath:@"StrobeDuration.archive"]];
	
	tempNumber = [NSNumber numberWithBool:viewController.strobeActivated];
	[NSKeyedArchiver archiveRootObject:tempNumber toFile:[self myFilePath:@"StrobeOnOff.archive"]];
}

- (NSString *)myFilePath:(NSString *)fileName
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

#pragma mark iAdBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    //NSLog(@"iAd Loaded");
    isiAdLoaded = YES;
    [self.adView setFrame:CGRectMake(0, self.window.frame.size.height-50, self.window.frame.size.width, 50)];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddBannerViewDidLoaded" object:nil];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    //NSLog(@"iAd LoadingFailed %@",error);
    isiAdLoaded = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AddBannerViewDidFaliedToLoad" object:nil];
}


@end
