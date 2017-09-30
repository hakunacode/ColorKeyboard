//
//  MainViewController.m
//  ColorKeyboard
//
//  Created by admin on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "KeyboardView.h"
#import "GameUtils.h"
#import "LinesView.h"
#import "ColorTextViewController.h"

@implementation MainViewController

#ifdef ADS_MOBCLIX
@synthesize adView;
#endif

@synthesize linesView, m_txtView;
@synthesize m_toolBar;
@synthesize m_bFindDic;
@synthesize m_bCustom;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIDeviceOrientationPortrait);
    } else {
        return YES;
    }
}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAll;
//}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration  {
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{
    g_GameUtils.m_nOrient = toInterfaceOrientation;
    [g_GameUtils setScreenValue];
    
    if (!m_keyboardView.m_bKeyboardAppear)
        m_keyboardView.hidden = YES;
    
	switch (toInterfaceOrientation)
	{
		case UIInterfaceOrientationPortrait:
		case UIInterfaceOrientationPortraitUpsideDown:	
			[m_keyboardView setFrame: CGRectMake(0, 0, 768, 1024)];
			break;
		case UIInterfaceOrientationLandscapeLeft:
		case UIInterfaceOrientationLandscapeRight:
			[m_keyboardView setFrame: CGRectMake(0, 0, 1024, 768)];
			break;
	}
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
    if (!m_keyboardView.m_bKeyboardAppear)
        m_keyboardView.hidden = NO;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (m_keyboardView.m_bKeyboardAppear)
        {
            CGRect rcNew = m_txtView.frame;
            if ([g_GameUtils isPortraitMode])
                rcNew.size.height = g_GameUtils.m_fHeight - (44 + 44 + 20) - (PHONE_PORT_HEIGHT - 44);
            else
                rcNew.size.height = g_GameUtils.m_fHeight - (44 + 32 + 20) - (PHONE_LAND_HEIGHT - 44);
            
            m_txtView.frame = rcNew;     
        }
    }
    else
    {
        if (m_keyboardView.m_bKeyboardAppear)
        {
            CGRect rcNew = m_txtView.frame;
            if ([g_GameUtils isPortraitMode]) {
                rcNew.size.height = g_GameUtils.m_fHeight - (44 + 44 + 20) - (PAD_PORT_HEIGHT - 44);
            }
            else {
                rcNew.size.height = g_GameUtils.m_fHeight - (44 + 44 + 20) - (PAD_LAND_HEIGHT - 44);
            }
            
            m_txtView.frame = rcNew;     
        }
//        CGRect rcTool = m_toolBar.frame;
//        rcTool.size.width = g_GameUtils.m_fWidth;
//        rcTool.origin.y = g_GameUtils.m_fHeight - (44 + 44 + 20)-rcTool.size.height;
//        m_toolBar.frame = rcTool;
    }
    
    //change switch pos
    [self layoutSwitch];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    g_GameUtils.m_nOrient = self.interfaceOrientation;
    [g_GameUtils setScreenValue];

#ifdef ADS_MOBCLIX    
	m_bMobclixTop = TRUE;
	m_bMobclixShow = TRUE;
#endif //ADS_MOBCLIX
    
    m_strInit = [[NSString alloc] init];
    m_strFinal = [[NSString alloc] init];
    //keyboard
    m_keyboardView = [[KeyboardView alloc] initView:self];
    [self.view addSubview:m_keyboardView];
    
    //notification of default keyboard //testing....
    // add observer for the respective notifications (depending on the os version) 
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) 
    { 
        [[NSNotificationCenter defaultCenter] addObserver:self  
                                                 selector:@selector(keyboardDidShow:)  
                                                     name:UIKeyboardDidShowNotification  
                                                   object:nil];      
    } 
    else
    { 
        [[NSNotificationCenter defaultCenter] addObserver:self  
                                                 selector:@selector(keyboardWillShow:)  
                                                     name:UIKeyboardWillShowNotification  
                                                   object:nil]; 
    } 
    
    //first format textview contents
    m_txtView.delegate = self;
    [m_txtView setText:@""];
    
    m_txtView.backgroundColor = [UIColor colorWithRed:0.988f green:0.976f blue:0.611f alpha:0.9f];
    m_bIsSending = NO;
    m_bFindDic = YES;
    m_bCustom = YES;
    
    //lines view
    NSString *text = [[NSString alloc] initWithString:@"XXX"];
	CGSize size = [text sizeWithFont: m_txtView.font];
	[text release];
    
	linesView.lineHeight = size.height;
    linesView.backgroundColor = [UIColor clearColor];
    
	CGRect frame = CGRectMake(10.0, 25.0, 10, 10);
	m_switchEff = [[UISwitch alloc] initWithFrame:frame];
	[m_switchEff addTarget:self action:@selector(switchDictionary:) forControlEvents:UIControlEventValueChanged];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];    
    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.274f green:0.188f blue:0.164f alpha:0.9f];
    [self.navigationItem setTitle:@"Keyboard"];
    [self layoutSwitch];
	
	// in case the parent view draws with a custom color or gradient, use a transparent color
    //	m_switchEff.backgroundColor = [UIColor clearColor];
    //    [m_switchEff setAlternateColors:YES];
    m_switchEff.backgroundColor = [UIColor colorWithRed:0.274f green:0.188f blue:0.164f alpha:0.9f];
    m_switchEff.backgroundColor = [UIColor clearColor];
    m_switchEff.on = YES;
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:m_switchEff] autorelease];
//    [self.navigationController.view addSubview:m_switchEff];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
#ifdef ADS_MOBCLIX
	[self.adView cancelAd];
	self.adView.delegate = nil;
	self.adView = nil;
#endif
}

- (void)viewWillAppear:(BOOL)animated
{
    g_GameUtils.m_nOrient = self.interfaceOrientation;
    [g_GameUtils setScreenValue];
    [m_keyboardView layoutSubviews];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //erase button
    //    UIBarButtonItem* btnNew = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(onNew)];
    //    [self.navigationItem setLeftBarButtonItem:btnNew];
    //    [btnNew release];
    
    //search dictionary switch button
    
#ifdef ADS_MOBCLIX
	[self.adView resumeAdAutoRefresh];
    
    // SKY:121101:star
    CGRect rtAds = self.adView.frame;
    static BOOL bFirst = NO;
    
    float hHeight = m_txtView.frame.size.height;
    if (bFirst)
    {
        hHeight -= rtAds.size.height;
        bFirst = YES;
    }
    [m_txtView  setFrame:CGRectMake(0, rtAds.origin.y + rtAds.size.height, m_txtView.frame.size.width, hHeight)];
    // SKY:end
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
#ifdef ADS_MOBCLIX
	[self.adView pauseAdAutoRefresh];
#endif
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (void) switchDictionary: (id) sender 
{
    m_bCustom = !m_bCustom;
    
    if (m_bCustom)
        m_posKeyboard.alpha = 0;
    else
        m_posKeyboard.alpha = 1;
    
}

-(void)setSwipeSwitch:(BOOL)bOn
{
    if (bOn)
    {
        m_bCustom = YES;
        [m_switchEff setOn:YES animated:YES];
    }
    else
    {
        m_bCustom = NO;
        [m_switchEff setOn:NO animated:YES];
    }
    
    if (m_bCustom)
        m_posKeyboard.alpha = 0;
    else
        m_posKeyboard.alpha = 1;
    
}

-(void)layoutSwitch
{
    return;
	CGRect frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([g_GameUtils isPortraitMode])
            frame = CGRectMake(10.0, 30.0, 10, 10);
        else
            frame = CGRectMake(10.0, 22.0, 10, 10);
    }
    else
        frame = CGRectMake(10.0, 30.0, 10, 10);
	m_switchEff.frame = frame;
    
}
/////////////////// remove default keyboard /////////////////////////////////////////////////////////////////
- (void)removeDefaltKeyboard 
{ 
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1]; 
    UIView* keyboard; 
    
    for (int i=0; i<[tempWindow.subviews count]; i++) 
    { 
        keyboard = [tempWindow.subviews objectAtIndex:i]; 
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) 
        { 
            if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES) 
            { 
                m_posKeyboard = keyboard;
                
                if (m_bIsSending || !m_bCustom)
                    keyboard.alpha = 1;
                else
                    keyboard.alpha = 0;
                
                /*                
                 // animate the keyboard moving 
                 CGContextRef context = UIGraphicsGetCurrentContext(); 
                 [UIView beginAnimations:nil context:context]; 
                 [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut]; 
                 [UIView setAnimationDuration:0.4]; 
                 
                 // remove the keyboard 
                 CGRect frame = keyboard.frame; 
                 // if (keyboard.frame.origin.x >= 0) { 
                 if (keyboard.frame.origin.y < 480) { 
                 // slide the keyboard onscreen 
                 //frame.origin.x = (keyboard.frame.origin.x - 320); 
                 
                 // slide the keyboard onscreen 
                 frame.origin.y = (keyboard.frame.origin.y + 264); 
                 keyboard.frame = frame; 
                 } 
                 else { 
                 // slide the keyboard off to the side 
                 //frame.origin.x = (keyboard.frame.origin.x + 320); 
                 
                 // slide the keyboard off 
                 frame.origin.y = (keyboard.frame.origin.y - 264); 
                 keyboard.frame = frame; 
                 } 
                 
                 [UIView commitAnimations]; */
            }
            
        }
        else 
        { 
            if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) 
            {
                if (m_bIsSending)
                    keyboard.alpha = 1;
                else
                    keyboard.alpha = 0;
                
            }
        } 
    }
} 

- (void)keyboardWillShow:(NSNotification *)note 
{ 
    [self removeDefaltKeyboard];
} 

- (void)keyboardDidShow:(NSNotification *)note
{ 
    [self removeDefaltKeyboard];
} 

/////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Handle Line Drawing

- (CGFloat)lineHeight {
	return linesView.lineHeight;
}

- (void) scrollViewDidScroll:(UIScrollView *) scrollView {
    //	DebugLog(D_TRACE, @"%s", __FUNCTION__);
	linesView.offset = scrollView.contentOffset.y;	
	[linesView setNeedsDisplay];
    
}
////////////////////////////////////////////////////////////////////////////////////////
-(void)onNew
{
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //keyboard
    [m_keyboardView animationView:YES];
    
    //set textview frame to scrolling
    [self animateTextView:YES];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDone)];
    [self.navigationItem setRightBarButtonItem:doneButton];
    [doneButton release];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [m_txtView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    
    [self animateTextView:NO];
    [m_keyboardView animationView:NO];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
}

- (void) onDone
{
    //    [m_keyboardView spyButton];
    //    [m_keyboardView delWordPopView];
    //
    //    [self animateTextView:NO];
    //    [m_keyboardView animationView:NO];
    
    [m_txtView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
    
}

-(void)animateTextView:(BOOL)up 
{
	int movementDistance;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if ([g_GameUtils isPortraitMode])
            movementDistance = PHONE_PORT_HEIGHT - 44; //toolbar H (44)
        else
            movementDistance = PHONE_LAND_HEIGHT - 44; //toolbar H (44) //dif 14 ??
    }
    else
    {
        if ([g_GameUtils isPortraitMode])
            movementDistance = PAD_PORT_HEIGHT - 44; //toolbar H (44)
        else
            movementDistance = PAD_LAND_HEIGHT - 44; //toolbar H (44) //dif 14 ??
    }
    
	float movementDuration;      
    
	int movement = (up ? -movementDistance : movementDistance);  
    movementDuration = (up? 0.5:0.1);
    
	[UIView beginAnimations: @"anim" context: nil];     
	[UIView setAnimationBeginsFromCurrentState: YES];     
	[UIView setAnimationDuration: movementDuration];     
    
    CGRect rcNew = m_txtView.frame;
    rcNew.size.height += movement;
	m_txtView.frame = rcNew;     
	[UIView commitAnimations]; 
}

-(IBAction) swtDic:(id)sender
{
    m_bFindDic = !m_bFindDic;
}

-(IBAction) btnErase:(id)sender
{
    [m_txtView setText:@""];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
    
    m_bIsSending = NO;
    
}

-(IBAction) btnSafari:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://zeeplox.playz.it"];
    [[UIApplication sharedApplication] openURL:url];
}

-(IBAction) btnEmail:(id)sender
{
    if (![MFMailComposeViewController canSendMail])
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Mail Accounts" message:@"Please set up a Mail account in order to send email."
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
		return;
	}
    
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	NSString* strSubect = [NSString stringWithFormat:@""];
	[picker setSubject:strSubect];
	
	[picker setMessageBody:m_txtView.text isHTML:NO]; 
	picker.navigationBar.barStyle = UIBarStyleDefault; 
	
	[self presentModalViewController:picker animated:YES];
	[picker release];
    
    m_bIsSending = YES;
    
}

// SMS
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else 
        NSLog(@"Message failed");
    
    m_bIsSending = NO;
}

-(IBAction) btnSMS:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Please select the SMS app." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"Normal SMS app", @"Color SMS", nil];
    [alert show];
    [alert release];
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
//        [[UIPasteboard generalPasteboard] setString:m_txtView.text];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
        MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
        
        if([MFMessageComposeViewController canSendText])
        {
            controller.body = m_txtView.text;
            controller.messageComposeDelegate = self;
            [self presentModalViewController:controller animated:YES];
            
            m_bIsSending = YES;
        }
    }
    else {
        NSString* strNib;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //SKY:121023:start
            if ([[UIScreen mainScreen] bounds].size.height == 568) // if iphone5
                strNib = @"ColorTextViewController_iPhone_5x";
            else
                strNib = @"ColorTextViewController_iPhone";
            // SKY:end
        }
        else
            strNib = @"ColorTextViewController_iPad";
        ColorTextViewController* ctrl = [[ColorTextViewController alloc] initWithNibName:strNib bundle:[NSBundle mainBundle]];
        [ctrl setText:m_txtView.text];
//        [self.navigationController pushViewController:ctrl animated:YES]; // SKY:121029
        [self presentModalViewController:ctrl animated:YES];
        [ctrl release];
    }
}
- (void)dealloc
{
#ifdef ADS_MOBCLIX
	[self.adView cancelAd];
	self.adView.delegate = nil;
	self.adView = nil;
#endif
    
    [m_keyboardView release];
    [m_txtView release];
    [m_switchEff release];
    [linesView release];
    
    [super dealloc];
}

- (CGRect) getHideRect {
	CGRect	rect;
	
	float	scnW = 320.0f;
	float	scnH = 480.0f;
	float	adsW = 320.0f;
	float	adsH =  50.0f;
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		scnW = 320.0f;
		scnH = 480.0f;
	} else {
		scnW =  768.0f;
		scnH = 1024.0f;
	}
	
	rect = CGRectMake((scnW-adsW)/2, scnH, adsW, adsH);
	
	return rect;
}

- (CGRect) getRect:(BOOL)bTop {
	CGRect	rect;
	
	float	scnW = 320.0f;
	float	scnH = 480.0f;
	float	adsW = 320.0f;
	float	adsH =  50.0f;
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
		scnW = 320.0f;
		scnH = 480.0f;
	} else {
		scnW =  768.0f;
		scnH = 1024.0f;

		adsW = 728.0f;
        adsH =  90.0f;
    }
	
	if (bTop)
		rect = CGRectMake((scnW-adsW)/2, 0.0f, adsW, adsH);
	else
		rect = CGRectMake((scnW-adsW)/2, scnH-adsH, adsW, adsH);
	
	return rect;
}

- (void) addAdsView
{
#ifdef ADS_MOBCLIX
	m_bMobclixTop = YES;
	m_bMobclixShow = YES;
	
	float	adsW = 320.0f;
	float	adsH =  50.0f;
	
	CGRect	rect = CGRectMake(0.0f, 0.0f, adsW, adsH);

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) //SKY:121101
        self.adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:rect] autorelease];
    else
        self.adView = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 728, 90)] autorelease];

    
	[self.view addSubview:self.adView];
#endif
	
	[self updateAdsView];
}

- (void) showMobclixAdsView {
#ifdef ADS_MOBCLIX
	CGRect	rect = [self getRect:m_bMobclixTop];
	
	[adView setFrame:rect];
	[adView setHidden:NO];
#endif
}

- (void) hideMobclixAdsView {
#ifdef ADS_MOBCLIX
	[adView setHidden:YES];
#endif
}

- (void) updateAdsView {
#ifdef ADS_MOBCLIX
	if  (m_bMobclixShow)
		[self showMobclixAdsView];
	else
		[self hideMobclixAdsView];
#endif
}

@end
