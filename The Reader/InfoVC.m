/**
 ClassName::		 InfoVC.h
 
 Superclass::		 UIViewController
 
 Class Description:: This is Info view for display information about clarion.
 
 Version::           1.0
 
 Author::            Ketan Parekh
 
 Created Date::      26/12/12
 
 Modified Date::     03/01/13
 
 Copy Right::        Clarion Technologies
 */
#import "InfoVC.h"

@interface InfoVC ()

@end

@implementation InfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    // Do any additional setup after loading the view from its nib.
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods

-(IBAction)btnHomeClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
