//
//  MainViewController.m
//  ColorText
//
//  Created by  on 12/03/23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColorTextViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GameUnit.h"
#import "UIImage+Resizing.h"


enum TABLE_TYPE {
    TABLE_TEXT_COLOR = 0,
    TABLE_TEXT_GLOW,
    TABLE_TEXT_SHADOW,
    TABLE_BG_COLOR,
    TABLE_BG_TEXTURE,
    TABLE_FONT,
};

#define CELL_BTN_COUNT  6
#define CELL_BTN_W      42
#define CELL_BTN_H      42
#define BTN_OFFSET_Y    4

#define SUPPORT_IOS6

@implementation ColorTextViewController

#ifdef ADS_MOBCLIX
@synthesize adView;
#endif

#define HTML_HEAD           @"<html><head><style type='text/css'>p.p1 "
#define HTML_MARGIN_HEAD    @"{margin: 0.0px 0.0px 0.0px 0.0px; font: %fpx Helvitica; font-family: 'HelveticaNeue-Light', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, Arial, 'Lucida Grande', sans-serif;"
#define HTML_MARGIN_SHADOW  @"text-shadow: 0.09em 0.09em 0em #%@;"
#define HTML_MARGIN_GLOW    @"text-shadow: 0.0em 0.0em 0.2em #%@, 0.0em 0.0em 0.2em #%@, 0.0em 0.0em 0.2em #%@;"
#define HTML_MARGIN_GLOWSHADOW    @"text-shadow: 0.09em 0.09em 0em #%@, 0.0em 0.0em 0.2em #%@, 0.0em 0.0em 0.2em #%@, 0.0em 0.0em 0.2em #%@;"
#define HTML_MARGIN_TAIL    @"}</style></head>"
#define HTML_BG_COLOR       @"<body bgcolor='#%@'>"
#define HTML_BG_TEXTURE     @"} body {background-color: transparent;}</style></head><body allowtransparency='true'>"
#define HTML_BODY           @"<div style='word-wrap: break-word;'><p class='p1'>"
#define HTML_FONT           @"<style type='text/css'> @font-face { font-family: '%@'; font-style: normal; font-weight: 400; src: local('%@'), local('%@-Regular'), url('%@') format('truetype'); } </style> <font style=\"font-family: '%@'; font-size:%fpx;\" color = #%@>"
#define HTML_FONT_NORMAL    @"<font face='%@' color='#%@'>"
//#define HTML_FONT_COLOR     @"<body bgcolor='#%@'>"

#define HTML_BOLD           @"<b>"
#define HTML_ITALIC         @"<i>"
#define HTML_UNDERLINE      @"<u>"

#define HTML_TAIL           @"</p></font></div></body></html>"

#define HTML_STRING @"<html><head><style type='text/css'>p.p1 {margin: 0.0px 0.0px 0.0px 0.0px; font: 14.0px Helvitica; font-family: 'HelveticaNeue-Light', 'Helvetica Neue Light', 'Helvetica Neue', Helvetica, Arial, Courier, 'Lucida Grande', sans-serif; text-shadow: 0.0em 0.0em 0.2em %@, 0.0em 0.0em 0.2em %@, 0.0em 0.0em 0.2em %@;}</style></head><body bgcolor='#E6E6E6'><div style='word-wrap: break-word;'><p class='p1'><font face='helvetica' color='#000000'>%@</p></font></div></body></html>"

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    m_nTableType = TABLE_TEXT_COLOR;
    m_nSelectTab = TAB_TEXT;
    m_nTextColorIndex = [g_GameUnit getTextColorCount]-1;
    m_nTextShadowIndex = 0;
    m_nTextGlowIndex = 0;
    m_nBgType = BG_COLOR;
    m_nBgColorIndex = 0;
    m_nBgTextureIndex = 0;
    m_nFontIndex = 0;
    m_bBold = NO;
    m_bItalic = NO;
    m_bUnderline = NO;
    
//    [self changBgColor:m_nBgColorIndex];
    [self changeTabBg:m_nSelectTab];
    [self updateBtnState:m_nSelectTab];
    [self setFontAtTextView];
    m_viewSms.backgroundColor = [g_GameUnit getBgColor:m_nBgColorIndex];
    
#ifdef ADS_MOBCLIX
	float	adsW = 320.0f;
	float	adsH =  50.0f;
	
	CGRect	rect = CGRectMake(0.0f, 0.0f, adsW, adsH);
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) //SKY:121101
        self.adView = [[[MobclixAdViewiPhone_320x50 alloc] initWithFrame:rect] autorelease];
    else
        self.adView = [[[MobclixAdViewiPad_728x90 alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 728, 90)] autorelease];
    
	[self.view addSubview:self.adView];
    
    // shift down the buttons
    CGRect rt = m_btnEdit.frame;
    [m_btnEdit setFrame:CGRectMake(rt.origin.x, rt.origin.y+self.adView.frame.size.height, rt.size.width, rt.size.height)];
    rt = m_btnSend.frame;
    [m_btnSend setFrame:CGRectMake(rt.origin.x, rt.origin.y+self.adView.frame.size.height, rt.size.width, rt.size.height)];
#endif

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
    //font test
//    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    NSArray *fontNames;
//    NSInteger indFamily, indFont;
//    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
//    {
//        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
//        fontNames = [[NSArray alloc] initWithArray:
//                     [UIFont fontNamesForFamilyName:
//                      [familyNames objectAtIndex:indFamily]]];
//        for (indFont=0; indFont<[fontNames count]; ++indFont)
//        {
//            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
//        }
//        [fontNames release];
//    }
//    [familyNames release];
//    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
    m_textView.textColor = [UIColor clearColor];
//    NSString* htmlStr = [NSString stringWithFormat:HTML_STRING, @"orange", @"pink", @"pink", m_textView.text];
//    NSLog(@"%@", htmlStr);
//    [m_webView loadHTMLString:htmlStr baseURL:nil];
    m_textView.text = m_strText;
    [m_tableView reloadData];
    [self updateWebView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
#ifdef ADS_MOBCLIX
	[self.adView resumeAdAutoRefresh];
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
#ifdef ADS_MOBCLIX
	[self.adView pauseAdAutoRefresh];
#endif
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return ((interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown));
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
#ifdef SUPPORT_IOS6
    return UIInterfaceOrientationMaskPortrait;
#else
    return UIInterfaceOrientationPortrait;
#endif //SUPPORT_IOS6
}

- (void)dealloc
{
#ifdef ADS_MOBCLIX
	[self.adView cancelAd];
	self.adView.delegate = nil;
	self.adView = nil;
#endif

    [m_strText release];
    [super dealloc];
}

- (IBAction) onEdit:(id)sender {
#if 0
    BOOL bEdited;
    if ([m_textView isFirstResponder] == NO) {
        [m_textView becomeFirstResponder];
        bEdited = YES;
    }
    else {
        [m_textView resignFirstResponder];
        bEdited = NO;
    }
    [self changeEditBtnImage:bEdited];
#else
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];//SKY:121029
#endif
}
- (IBAction) onSend:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Your edited text message has been copied to your clipboard, you must paste it into a text message to send it.\n\n *** DON'T worry how it looks on your screen, we promise it will appear normal on the iPhone/iDevice screen of the recipient ***\n\n(* If all of your text didn't fit in the window above only the first 6 lines of text will be displayed in the textmessage, this is due to the iMessage's image attaching size restraints). You can click 'Message' below to go to your text messages or you can click 'okay' below to dissmiss this message." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Message", nil];
    [alertView show];
    [alertView release];
}
- (IBAction) onClear:(id)sender {
    m_textView.text = @"";
    [self updateWebView];
}
- (IBAction) onTab:(id)sender {
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag-1;
    if (tag == m_nSelectTab)
        return;
    m_nSelectTab = tag;
    if (m_nSelectTab == TAB_TEXT)
        m_nTableType = TABLE_TEXT_COLOR;
    else if (m_nSelectTab == TAB_BG)
        m_nTableType = TABLE_BG_COLOR;
    else
        m_nTableType = TABLE_FONT;
    [m_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [m_tableView reloadData];
    [self changeTabBg:tag];
    [self updateBtnState:tag];
    [self updateFontStyleBtn];
    if (m_nSelectTab == TAB_FONT) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:m_nFontIndex inSection:0];
//        NSIndexPath* index= [NSIndexPath indexPathWithIndex:m_nFontIndex];
        [m_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (IBAction) onTextBtn:(id)sender {
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag-1;
    if (tag == 0) {
        m_nTableType = TABLE_TEXT_COLOR;
    }
    else if (tag == 1) {
        m_nTableType = TABLE_TEXT_GLOW;
    }
    else {
        m_nTableType = TABLE_TEXT_SHADOW;
    }
    [m_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [m_tableView reloadData];
}
- (IBAction) onBgBtn:(id)sender {
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag-1;
    if (tag == 0) {
        m_nTableType = TABLE_BG_COLOR;
        m_nBgType = BG_COLOR;
    }
    else {
        m_nTableType = TABLE_BG_TEXTURE;
        m_nBgType = BG_TEXTURE;
    }
    [m_tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [m_tableView reloadData];
    [self updateWebView];
}
- (IBAction) onFontBtn:(id)sender {
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag-1;
    if (tag == FONT_BOLD) {
        m_bBold = 1-m_bBold;
        [self changeBoldBtnImage:m_bBold];
        if (m_btnFontItalic.enabled == YES && [self isExistBoldItalicFont] == NO && m_bItalic) {
            m_bItalic = NO;
            [self changeItalicBtnImage:NO];
        }
    }
    else if (tag == FONT_ITALIC) {
        m_bItalic = 1-m_bItalic;
        [self changeItalicBtnImage:m_bItalic];
        if (m_btnFontBold.enabled == YES && [self isExistBoldItalicFont] == NO && m_bBold) {
            m_bBold = NO;
            [self changeBoldBtnImage:NO];
        }
    }
    else {
        m_bUnderline = 1-m_bUnderline;
        [self changeUnderlineBtnImage:m_bUnderline];
    }
    [self setFontAtTextView];
    [self updateWebView];
}
- (IBAction) onCellBtn:(id)sender {
    UIButton* btn = (UIButton*)sender;
    int tag = btn.tag;
    switch (m_nTableType) {
        case TABLE_TEXT_COLOR:
            m_nTextColorIndex = tag;
            break;
        case TABLE_TEXT_GLOW:
            m_nTextGlowIndex = tag;
            break;
        case TABLE_TEXT_SHADOW:
            m_nTextShadowIndex = tag;
            break;
        case TABLE_BG_COLOR:
            m_nBgColorIndex = tag;
            m_imgTexture.hidden = YES;
            m_viewSms.backgroundColor = [g_GameUnit getBgColor:m_nBgColorIndex];
            break;
        case TABLE_BG_TEXTURE:
            m_nBgTextureIndex = tag;
            [self changeBgTexture:tag];
            break;
        default:
            break;
    }
    [self updateWebView];
}
- (void) setText:(NSString*)str {
    if (m_strText != nil)
        [m_strText release];
    m_strText = [[NSString alloc] initWithString:str];
    
}
- (NSString*) convertHtmlString:(NSString*)strSrc {
    NSMutableString* strHtml = [NSMutableString stringWithString:strSrc];
    [strHtml replaceOccurrencesOfString:@"\n" withString:@"<br>" options:0 range:NSMakeRange(0, [strHtml length])];
    return strHtml;
}
- (void) updateWebView {
    NSMutableString* strHtml = [[NSMutableString alloc] init];
    [strHtml appendString:HTML_HEAD];
    CGFloat fontSize = 14.0f;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        fontSize = 28.0f;
    [strHtml appendString:[NSString stringWithFormat:HTML_MARGIN_HEAD, fontSize]];
    if (m_nTextGlowIndex != 0 && m_nTextShadowIndex != 0) {
        NSString* strShadow = [g_GameUnit getTextColorWithHexString:m_nTextShadowIndex];
        NSString* strGlow = [g_GameUnit getTextColorWithHexString:m_nTextGlowIndex];
        [strHtml appendString:[NSString stringWithFormat:HTML_MARGIN_GLOWSHADOW, strShadow,strGlow, strGlow, strGlow]];
    }
    else if (m_nTextGlowIndex != 0) {
        NSString* strGlow = [g_GameUnit getTextColorWithHexString:m_nTextGlowIndex];
        [strHtml appendString:[NSString stringWithFormat:HTML_MARGIN_GLOW, strGlow, strGlow, strGlow]];
    }
    else if (m_nTextShadowIndex != 0) {
        NSString* strColor = [g_GameUnit getTextColorWithHexString:m_nTextShadowIndex];
        [strHtml appendString:[NSString stringWithFormat:HTML_MARGIN_SHADOW, strColor]];
    }
    
    if (m_nBgType == BG_COLOR) {
        [strHtml appendString:HTML_MARGIN_TAIL];
        [strHtml appendString:[NSString stringWithFormat:HTML_BG_COLOR, [g_GameUnit getBgColorWithHexString:m_nBgColorIndex]]];
    }
    else {
        [strHtml appendString:HTML_BG_TEXTURE];
    }    
    [strHtml appendString:HTML_BODY];
    
    FontObj* font = [g_GameUnit getFontObj:m_nFontIndex];
    if (font.m_strFileName == nil) {
        [strHtml appendFormat:HTML_FONT_NORMAL, [self getFontName],[g_GameUnit getTextColorWithHexString:m_nTextColorIndex]];
    }
    else {
        [strHtml appendFormat:HTML_FONT, font.m_strName, font.m_strName, font.m_strName, font.m_strFileName, font.m_strName, fontSize,[g_GameUnit getTextColorWithHexString:m_nTextColorIndex]];
    }
    
//    if (m_bBold)
//        [strHtml appendString:HTML_BOLD];
//    if (m_bItalic)
//        [strHtml appendString:HTML_ITALIC];
    if (m_bUnderline)
        [strHtml appendString:HTML_UNDERLINE];
    
    [strHtml appendString:[self convertHtmlString:m_textView.text]];
    [strHtml appendString:HTML_TAIL];
    NSLog(@"%@", strHtml);
    [m_webView loadHTMLString:strHtml baseURL:nil];
    [strHtml release];
}
#define CONER_RADIUS    4.0f

- (IBAction)moreApps:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://zeeplox.playz.it"]];
}

- (UIButton*) createColorButton:(UIColor*)color {
    UIButton* btnColor = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnColor setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnColor.backgroundColor = color;
    btnColor.layer.borderColor = [UIColor blackColor].CGColor;
    btnColor.layer.borderWidth = 0.5f;
    btnColor.layer.cornerRadius = CONER_RADIUS;
    btnColor.layer.masksToBounds = YES;
    return btnColor;
}
- (UIButton*) createTextureButton:(int)index {
    UIButton* btnTexture = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString* str = [NSString stringWithFormat:@"texture_%02d.png", index];
    [btnTexture setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    btnTexture.backgroundColor = [UIColor clearColor];
    btnTexture.layer.borderColor = [UIColor blackColor].CGColor;
    btnTexture.layer.borderWidth = 0.5f;
    btnTexture.layer.cornerRadius = CONER_RADIUS;
    btnTexture.layer.masksToBounds = YES;
    return btnTexture;
}
- (UIButton*) createClearButton {
    UIButton* btnColor = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnColor setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnColor setTitle:@"Clear" forState:UIControlStateNormal];
    [btnColor setFont:[UIFont systemFontOfSize:14]];
    btnColor.backgroundColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    btnColor.layer.borderColor = [UIColor blackColor].CGColor;
    btnColor.layer.borderWidth = 0.5f;
    btnColor.layer.cornerRadius = CONER_RADIUS;
    btnColor.layer.masksToBounds = YES;
    return btnColor;
}

- (void) changeBgColor:(int)index {
    m_imgTexture.hidden = YES;
    m_viewSms.backgroundColor = [g_GameUnit getBgColor:index];
}
- (void) changeBgTexture:(int)index {
    m_imgTexture.hidden = NO;
    [m_imgTexture setImage:[UIImage imageNamed:[NSString stringWithFormat:@"texture_%02d.png", index]]];
}

- (void) changeEditBtnImage:(BOOL)edited {
    NSString* strN;
    NSString* strS;
    if (edited) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            strN = @"done_nor.png";
            strS = @"done_pre.png";
        }
        else {
            strN = @"done_nor@2x.png";
            strS = @"done_pre@2x.png";
        }
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            strN = @"edit_nor.png";
            strS = @"edit_sel.png";
        }
        else {
            strN = @"edit_nor@2x.png";
            strS = @"edit_sel@2x.png";
        }
    }
    [m_btnEdit setImage:[UIImage imageNamed:strN] forState:UIControlStateNormal];
    [m_btnEdit setImage:[UIImage imageNamed:strS] forState:UIControlStateHighlighted];
}
- (void) changeTabBg:(int)index {
    NSString* str;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) 
        str = [NSString stringWithFormat:@"tab_background_%d.png", index];
    else
        str = [NSString stringWithFormat:@"tab_background_%d-iPad.png", index];
    [m_imgTabBg setImage:[UIImage imageNamed:str]];
}

- (void) updateBtnState:(int)index {
    BOOL bHide;
    bHide = (index == TAB_TEXT) ? NO : YES;
    m_btnTextColor.hidden = bHide;
    m_btnTextGlow.hidden = bHide;
    m_btnTextShadow.hidden = bHide;
    
    bHide = (index == TAB_BG) ? NO : YES;
    m_btnBgColor.hidden = bHide;
    m_btnBgTexture.hidden = bHide;
    
    bHide = (index == TAB_FONT) ? NO : YES;
    m_btnFontBold.hidden = bHide;
    m_btnFontItalic.hidden = bHide;
    m_btnFontUnderline.hidden = bHide;
}
//font proc
- (NSString*) getFontNameWithFamilyName:(NSString*)familyName {
    NSArray* array = [UIFont fontNamesForFamilyName:familyName];
    if ([array count] == 1)
        return [array objectAtIndex:0];
    int index = 0;
    for (int i = 0; i < [array count]; i ++) {
        NSString* strFont = [array objectAtIndex:i];
        NSArray* sub = [strFont componentsSeparatedByString:@"-"];
        if ([sub count] == 1) {
            index = i;
            break;
        }
        NSString* strStyle = [sub objectAtIndex:1];
        //        NSLog(@"%@", strStyle);
        NSRange range = [strStyle rangeOfString:@"Regular" options:NSCaseInsensitiveSearch];
        if (range.length == 0)
            continue;
        index = i;
        NSLog(@"normal - %@", strStyle);
        break;
    }
    return [array objectAtIndex:index];
}
- (NSString*) getBoldFontNameWithFamilyName:(NSString*)familyName {
    NSArray* array = [UIFont fontNamesForFamilyName:familyName];
    if ([array count] == 1)
        return nil;
    int index = -1;
    for (int i = 0; i < [array count]; i ++) {
        NSString* strFont = [array objectAtIndex:i];
        NSArray* sub = [strFont componentsSeparatedByString:@"-"];
        if ([sub count] == 1)
            continue;
        NSString* strStyle = [sub objectAtIndex:1];
//        NSLog(@"%@", strStyle);
        NSRange rangeB = [strStyle rangeOfString:@"Bold" options:NSCaseInsensitiveSearch];
        if (rangeB.length == 0)
            continue;
        NSRange rangeI = [strStyle rangeOfString:@"It" options:NSCaseInsensitiveSearch]; 
        if (rangeI.length != 0)
            continue;
        rangeI = [strStyle rangeOfString:@"Oblique" options:NSCaseInsensitiveSearch]; 
        if (rangeI.length != 0)
            continue;
        index = i;
        NSLog(@"bold - %@", strStyle);
        break;
    }
    if (index == -1)
        return nil;
    else
        return [array objectAtIndex:index];
}
- (NSString*) getItalicFontNameWithFamilyName:(NSString*)familyName {
    NSArray* array = [UIFont fontNamesForFamilyName:familyName];
    if ([array count] == 1)
        return nil;
    int index = -1;
    for (int i = 0; i < [array count]; i ++) {
        NSString* strFont = [array objectAtIndex:i];
        NSArray* sub = [strFont componentsSeparatedByString:@"-"];
        if ([sub count] == 1)
            continue;
        NSString* strStyle = [sub objectAtIndex:1];
        NSRange rangeI = [strStyle rangeOfString:@"Italic" options:NSCaseInsensitiveSearch];
        if (rangeI.length == 0) {
            rangeI = [strStyle rangeOfString:@"Oblique" options:NSCaseInsensitiveSearch];
            if (rangeI.length == 0)
                continue;
        }
        if (rangeI.length != 0 && rangeI.location != 0)
            continue;
        
        index = i;
        NSLog(@"italic - %@", strStyle);
        break;
    }
    if (index == -1)
        return nil;
    else
        return [array objectAtIndex:index];
}
- (NSString*) getBoldItalicFontNameWithFamilyName:(NSString*)familyName {
    NSArray* array = [UIFont fontNamesForFamilyName:familyName];
    if ([array count] == 1)
        return nil;
    int index = -1;
    for (int i = 0; i < [array count]; i ++) {
        NSString* strFont = [array objectAtIndex:i];
        NSArray* sub = [strFont componentsSeparatedByString:@"-"];
        if ([sub count] == 1)
            continue;
        NSString* strStyle = [sub objectAtIndex:1];
        NSRange rangeI = [strStyle rangeOfString:@"BoldIt" options:NSCaseInsensitiveSearch];
        if (rangeI.length == 0) {
            rangeI = [strStyle rangeOfString:@"BoldOb" options:NSCaseInsensitiveSearch];
            if (rangeI.length == 0)
                continue;
        }
        if (rangeI.length != 0 && rangeI.location != 0)
            continue;
        
        index = i;
        NSLog(@"bolditalic - %@", strStyle);
        break;
    }
    if (index == -1)
        return nil;
    else
        return [array objectAtIndex:index];
}

- (BOOL) isExistBoldFont {
    FontObj* fontObj = [g_GameUnit getFontObj:m_nFontIndex];
    NSString* strBold = [self getBoldFontNameWithFamilyName:fontObj.m_strName];
    return (strBold != nil);
}
- (BOOL) isExistItalicFont {
    FontObj* fontObj = [g_GameUnit getFontObj:m_nFontIndex];
    NSString* strItalic = [self getItalicFontNameWithFamilyName:fontObj.m_strName];
    return (strItalic != nil);
}
- (BOOL) isExistBoldItalicFont {
    FontObj* fontObj = [g_GameUnit getFontObj:m_nFontIndex];
    NSString* strBI = [self getBoldItalicFontNameWithFamilyName:fontObj.m_strName];
    return (strBI != nil);
}
- (void) updateFontStyleBtn {
    if ([self isExistBoldFont] == NO) {
        m_bBold = NO;
        m_btnFontBold.enabled = NO;
        [self changeBoldBtnImage:NO];
    }
    else {
        m_btnFontBold.enabled = YES;
    }
    if ([self isExistItalicFont] == NO) {
        m_bItalic = NO;
        m_btnFontItalic.enabled = NO;
        [self changeItalicBtnImage:NO];
    }
    else {
        m_btnFontItalic.enabled = YES;
    }
}

- (void) changeBoldBtnImage:(BOOL)bSelect {
    NSString* str;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (bSelect)
            str = @"bold_sel.png";
        else
            str = @"bold_nor.png";
    }
    else {
        if (bSelect)
            str = @"bold_sel@2x.png";
        else
            str = @"bold_nor@2x.png";
    }
    [m_btnFontBold setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
}
- (void) changeItalicBtnImage:(BOOL)bSelect {
    NSString* str;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (bSelect)
            str = @"italic_sel.png";
        else
            str = @"italic_nor.png";
    }
    else {
        if (bSelect)
            str = @"italic_sel@2x.png";
        else
            str = @"italic_nor@2x.png";
    }
    [m_btnFontItalic setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
}
- (void) changeUnderlineBtnImage:(BOOL)bSelect {
    NSString* str;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (bSelect)
            str = @"underline_sel.png";
        else
            str = @"underline_nor.png";
    }
    else {
        if (bSelect)
            str = @"underline_sel@2x.png";
        else
            str = @"underline_nor@2x.png";
    }
    [m_btnFontUnderline setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
}
- (NSString*) getFontName {
    FontObj* fontObj = [g_GameUnit getFontObj:m_nFontIndex];
    NSString* strFont;
    if (m_bBold && m_bItalic)
        strFont = [self getBoldItalicFontNameWithFamilyName:fontObj.m_strName];
    else if (m_bBold)
        strFont = [self getBoldFontNameWithFamilyName:fontObj.m_strName];
    else if (m_bItalic)
        strFont = [self getItalicFontNameWithFamilyName:fontObj.m_strName];
    else
        strFont = [self getFontNameWithFamilyName:fontObj.m_strName];
    return strFont;
}
- (void) setFontAtTextView {
    CGFloat fontSize = 14;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        fontSize *= 2;
    UIFont* font = [UIFont fontWithName:[self getFontName] size:fontSize];
    [m_textView setFont:font];
}
- (CGSize) getStringSize:(NSString*)strM {
    CGFloat fontSize = 14;
    CGFloat scale = 1.0f, offsetX, offsetY;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        fontSize *= 2;
        scale = 2;
        offsetX = 54;
        offsetY = 20;
    }
    else {
        offsetX = 28;
        offsetY = 20;
    }
    CGSize sizeWindow = m_textView.bounds.size;
    CGSize maxSize = CGSizeMake(sizeWindow.width-28*scale, 9999);
//    FontObj* fontObj = [g_GameUnit getFontObj:m_nFontIndex];
    UIFont* font = [UIFont fontWithName:[self getFontName] size:fontSize];
    if (font == nil)
        font = [UIFont systemFontOfSize:fontSize];
    CGSize expectedSize = [strM sizeWithFont:font
                           constrainedToSize:maxSize
                               lineBreakMode:UILineBreakModeWordWrap];
    if (expectedSize.width >= sizeWindow.width-30*scale)
        expectedSize.width = sizeWindow.width;
    else
        expectedSize.width += offsetX;
    if (expectedSize.height > sizeWindow.height)
        expectedSize.height = sizeWindow.height;
    else {
        expectedSize.height += offsetY;
    }
    return expectedSize;
}
- (CGContextRef) createBitmapContextSuitableForView
{
	int pixelsWide = m_viewSms.bounds.size.width;
	int pixelsHigh = m_viewSms.bounds.size.height;
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    bitmapBytesPerRow   = (pixelsWide * 4);// 1
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();  // modification from sample
    bitmapData = malloc( bitmapByteCount );
    
	memset(bitmapData, 255, bitmapByteCount);  // wipe with 100% white
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace ); // SKY:121103
        fprintf (stderr, "Memory not allocated!");
        return NULL;
    }
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    if (context== NULL)
    {
        CGColorSpaceRelease( colorSpace ); // SKY:121103
        free (bitmapData);
        fprintf (stderr, "Context not created!");
        return NULL;
    }
    free (bitmapData); // SKY:121103

    CGColorSpaceRelease( colorSpace );
    
    return context;
}
- (void)drawClockInRect:(CGRect)rect context:(CGContextRef)context flipped:(BOOL)isFlipped
{
	UIGraphicsPushContext(context);
    
	if (isFlipped)
	{
		CGContextGetCTM(context);
		CGContextScaleCTM(context, 1, -1);
		CGContextTranslateCTM(context, 0,
                              -m_viewSms.bounds.size.height);
	}
    
	// amazing drawing technique omitted for brevity ;-)
    
	UIGraphicsPopContext();
}
- (UIImage *) imageWithView:(UIView *)view
{
    CGSize size = view.bounds.size;
    size = [self getStringSize:m_textView.text];
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
- (UIImage *) imageFromView
{
	CGContextRef bitmapContext = [self createBitmapContextSuitableForView];
	[self drawClockInRect:CGRectMake(0, 0, m_viewSms.bounds.size.width,
                                     m_viewSms.bounds.size.height) context:bitmapContext flipped:YES];
	CGImageRef image = CGBitmapContextCreateImage(bitmapContext);
	UIImage *newImage = [UIImage imageWithCGImage:image];
	CGContextRelease(bitmapContext);
	CGImageRelease(image);
    
	return newImage;
}
- (UIImage*) getImage {
    CGSize size = [self getStringSize:m_textView.text];
    //    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, m_webView.opaque, [[UIScreen mainScreen] scale]); 
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor* color;
    if (m_nBgType == BG_COLOR)
        color = [g_GameUnit getBgColor:m_nBgColorIndex];
    else
        color = [UIColor clearColor];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    if (m_nBgType == BG_TEXTURE)
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), m_imgTexture.image.CGImage);

    [[m_webView layer] renderInContext:context];
    UIImage * save_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); 
    return save_image;
    return [UIImage imageOfSize:CGSizeMake(size.width*0.9, size.height*0.9) fromImage:save_image];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    UIImage* img = [self getImage];
    UIImage* img = [self imageWithView:m_viewSms];
    UIImage*imgSend;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        imgSend = [UIImage imageOfSize:CGSizeMake(img.size.width*0.7, img.size.height*0.7) fromImage:img];
    else
        imgSend = img;
    
    //SKY:121023:start
//    [[UIPasteboard generalPasteboard] setImage:imgSend];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.persistent = YES;
    NSData *imgData = UIImagePNGRepresentation(imgSend);
    [pasteboard setData:imgData forPasteboardType:[UIPasteboardTypeListImage objectAtIndex:0]];
    // SKY:end
    
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://"]];
    }
}
#pragma mark - UITextViewDelegate method
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self changeEditBtnImage:YES];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self changeEditBtnImage:NO];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([text compare:@"\n"] == NSOrderedSame) {
//        [textView resignFirstResponder];
//        return NO;
//    }
    int len = [text length] + [textView.text length] - range.length;
    if (len > 30) {
        NSString* str = [textView.text stringByReplacingCharactersInRange:range withString:text];
        CGSize size = [self getStringSize:str];
        CGFloat maxH = 140;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            maxH = 264;
        if (size.height > maxH)
            return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
//    [m_textView setNeedsDisplay];
//    NSString* htmlStr = [NSString stringWithFormat:HTML_STRING, @"orange", @"pink", @"pink", m_textView.text];
    //    NSLog(@"%@", htmlStr);
    //    [m_textView setContentHtmlString:htmlStr];
//    [m_webView loadHTMLString:htmlStr baseURL:nil];
    [self updateWebView];
}

#pragma mark Table dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
}

- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
    int count = 5;
    switch (m_nTableType) {
        case TABLE_TEXT_COLOR:
        case TABLE_TEXT_GLOW:
        case TABLE_TEXT_SHADOW:
            count = [g_GameUnit getTextColorCount]/CELL_BTN_COUNT;
            break;
        case TABLE_BG_COLOR:
            count = [g_GameUnit getBgColorCount]/CELL_BTN_COUNT;
            break;
        case TABLE_BG_TEXTURE:
            count = BG_TEXTURE_COUNT/CELL_BTN_COUNT;
            break;
        case TABLE_FONT:
            count = [g_GameUnit getFontCount];
            break;
        default:
            break;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (m_nTableType != TABLE_FONT)
            return 49;
        else
            return 38;
    }
    else {
        if (m_nTableType != TABLE_FONT)
            return 49*2;
        else
            return 38*2;
    }
}

- (UITableViewCell*)tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
	UITableViewCell *cell = nil;
	
	NSString *kSourceCellID;
    switch (m_nTableType) {
        case TABLE_TEXT_COLOR:
            kSourceCellID = [NSString stringWithFormat:@"TextColorCell%d", indexPath.row];
            break;
        case TABLE_TEXT_GLOW:
            kSourceCellID = [NSString stringWithFormat:@"TextGlowCell%d", indexPath.row];
            break;
        case TABLE_TEXT_SHADOW:
            kSourceCellID = [NSString stringWithFormat:@"TextShadowCell%d", indexPath.row];
            break;
        case TABLE_BG_COLOR:
            kSourceCellID = [NSString stringWithFormat:@"BgColorCell%d", indexPath.row];
            break;
        case TABLE_BG_TEXTURE:
            kSourceCellID = [NSString stringWithFormat:@"BgTextureCell%d", indexPath.row];
            break;
        case TABLE_FONT:
            kSourceCellID = [NSString stringWithFormat:@"FontCell%d", indexPath.row];
            break;
        default:
            break;
    }
    
	cell = [tableView dequeueReusableCellWithIdentifier:kSourceCellID];
    if (cell == nil)
    {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kSourceCellID] autorelease];
        if (m_nTableType == TABLE_FONT) {
//            m_tableView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;//UITableViewCellSelectionStyleNone;
            cell.textLabel.opaque = NO;
            cell.textLabel.textAlignment = UITextAlignmentLeft;
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.highlightedTextColor = [UIColor blackColor];
//            cell.textLabel.font = [UIFont systemFontOfSize:18];	
            FontObj* fontObj = [g_GameUnit getFontObj:indexPath.row];
            [cell.textLabel setFont:[UIFont fontWithName:fontObj.m_strName size:fontObj.m_fSize]];
            [cell.textLabel setText:fontObj.m_strDisplayName];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            [cell setSelected:(indexPath.row == m_nFontIndex)];
//            if ((indexPath.row%2) == 1)
//                cell.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//            else
//                cell.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
//            cell.text = @"text";
        }
        else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [UIColor clearColor];
            int nBaseTag = indexPath.row*CELL_BTN_COUNT;
//            NSLog(@"base tag - %d", nBaseTag);
            int tag;
            UIColor* color;
            CGFloat x, y=BTN_OFFSET_Y, w=CELL_BTN_W,h=CELL_BTN_H;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                y *= 2;
                w *= 2;
                h *= 2;
            }
            CGRect rt = m_tableView.bounds;
            CGFloat offsetX = (rt.size.width-w*6)/7;
            x = offsetX;
            for (int i = 0; i < CELL_BTN_COUNT; i ++) {
                UIButton* btn;
                tag = i+nBaseTag;
                if (m_nTableType == TABLE_BG_TEXTURE) {
                    btn = [self createTextureButton:tag];
                }
                else {
                    if ((m_nTableType == TABLE_TEXT_SHADOW || m_nTableType == TABLE_TEXT_GLOW) && tag == 0) {
                        btn = [self createClearButton];
                    }
                    else {
                        if (m_nTableType == TABLE_TEXT_COLOR || m_nTableType == TABLE_TEXT_SHADOW || m_nTableType == TABLE_TEXT_GLOW)
                            color = [g_GameUnit getTextColor:tag];
                        else
                            color = [g_GameUnit getBgColor:tag];
                        btn = [self createColorButton:color];
                    }
                }
                btn.tag = tag;
                [btn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
                [btn setFrame:CGRectMake(x, y, w, h)];
                x += w+offsetX;
                [cell.contentView addSubview:btn];
            }
        }
        
	}
	
    
	return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_nTableType != TABLE_FONT) {
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setAccessibilityTraits:0];
        return;
    }
        
    bool isSelected = cell.isSelected;// enter your own code here
    if (isSelected)
    {
//        [cell setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:0.75 alpha:1]];
        [cell setAccessibilityTraits:UIAccessibilityTraitSelected];
    }
    else
    {
        if ((indexPath.row%2) == 0) 
            [cell setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2f]];
        else
            [cell setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f]];
        [cell setAccessibilityTraits:0];
    }
}
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark Table View delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (m_nTableType == TABLE_FONT) {
        m_nFontIndex = indexPath.row;
        [self updateFontStyleBtn];
        [self setFontAtTextView];
        [self updateWebView];
    }
	// deselect the current row (don't keep the table selection persistent)
//	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
//    [g_GameUnit.m_arrayLocationCity addObject:[m_arrayCity objectAtIndex:indexPath.row]];
//    [self.navigationController popViewControllerAnimated:YES];
}

@end
