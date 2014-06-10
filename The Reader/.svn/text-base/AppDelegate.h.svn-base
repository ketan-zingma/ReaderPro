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

#import <UIKit/UIKit.h>
#import "iAd/ADBannerView.h"
@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,ADBannerViewDelegate>
{
    UIWindow *window;
    ViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;

- (void)saveData;
- (void)loadData;
- (NSString *)myFilePath:(NSString *)fileName;
@property (nonatomic,retain)ADBannerView *adView;
@property (nonatomic)BOOL isiAdLoaded;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;
@end
