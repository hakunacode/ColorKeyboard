//
//  KeyImage.m
//  SwipeKey
//
//  Created by YCH on 2011.11.02

#import "KeyImage.h"
#import "GameUtils.h"



@implementation KeyImage

-(id)Initkey:(int)nType posPort:(CGPoint)ptPortPos posLand:(CGPoint)ptLandPos
{
    if ((self = [self init]))
    {
        NSString* sFile;
        //portrait
        sFile = [g_GameUtils stringConvert:[NSString stringWithFormat:@"port_%02d", (int)nType]];
        m_imgPort = [[UIImage imageNamed:sFile] retain];

        sFile = [g_GameUtils stringConvert:[NSString stringWithFormat:@"port_sel_%02d", (int)nType]];
        m_imgPortSel = [[UIImage imageNamed:sFile] retain];
        
        //land
        sFile = [g_GameUtils stringConvert:[NSString stringWithFormat:@"land_%02d", (int)nType]];
        m_imgLand = [[UIImage imageNamed:sFile] retain];

        sFile = [g_GameUtils stringConvert:[NSString stringWithFormat:@"land_sel_%02d", (int)nType]];
        m_imgLandSel = [[UIImage imageNamed:sFile] retain];

        //get img size
        CGFloat w, h;
        w = m_imgPort.size.width;
        h = m_imgPort.size.height;
        m_rtPortKey = CGRectMake(ptPortPos.x - w/2, ptPortPos.y - h/2, w, h);

        w = m_imgLand.size.width;
        h = m_imgLand.size.height;
        m_rtLandKey = CGRectMake(ptLandPos.x - w/2, ptLandPos.y - h/2, w, h);

        m_nStatus = RELEASED;
        m_nKeyID = nType;

    }
    return self;
}

-(NSString*)GetKeyString
{
    NSString* str;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        switch (m_nKeyID)
        {
            case 0:
                str = @"q";
                break;
            case 1:
                str = @"w";
                break;
            case 2:
                str = @"e";
                break;
            case 3:
                str = @"r";
                break;
            case 4:
                str = @"t";
                break;
            case 5:
                str = @"y";
                break;
            case 6:
                str = @"u";
                break;
            case 7:
                str = @"i";
                break;
            case 8:
                str = @"o";
                break;
            case 9:
                str = @"p";
                break;
            case 10:
                str = @"a";
                break;
            case 11:
                str = @"s";
                break;
            case 12:
                str = @"d";
                break;
            case 13:
                str = @"f";
                break;
            case 14:
                str = @"g";
                break;
            case 15:
                str = @"h";
                break;
            case 16:
                str = @"j";
                break;
            case 17:
                str = @"k";
                break;
            case 18:
                str = @"l";
                break;
            case 19:
                str = @"";//caps key
                break;
            case 20:
                str = @"z";
                break;
            case 21:
                str = @"x";
                break;
            case 22:
                str = @"c";
                break;
            case 23:
                str = @"v";
                break;
            case 24:
                str = @"b";
                break;
            case 25:
                str = @"n";
                break;
            case 26:
                str = @"m";
                break;
            case 27:
                str = @"";//back
                break;
            case 28:
                str = @"";//num
                break;
            case 29:
                str = @"";//world
                break;
            case 30:
                str = @" ";//space
                break;
            case 31:
                str = @"";//return
                break;
        }
    }
    else
    {
        switch (m_nKeyID)
        {
            case 0:
                str = @"q";
                break;
            case 1:
                str = @"w";
                break;
            case 2:
                str = @"e";
                break;
            case 3:
                str = @"r";
                break;
            case 4:
                str = @"t";
                break;
            case 5:
                str = @"y";
                break;
            case 6:
                str = @"u";
                break;
            case 7:
                str = @"i";
                break;
            case 8:
                str = @"o";
                break;
            case 9:
                str = @"p";
                break;
            case 10:
                str = @"";//back
                break;
            case 11:
                str = @"a";
                break;
            case 12:
                str = @"s";
                break;
            case 13:
                str = @"d";
                break;
            case 14:
                str = @"f";
                break;
            case 15:
                str = @"g";
                break;
            case 16:
                str = @"h";
                break;
            case 17:
                str = @"j";
                break;
            case 18:
                str = @"k";
                break;
            case 19:
                str = @"l";
                break;
            case 20:
                str = @"";//return
                break;
            case 21:
                str = @"";//cpas
                break;
            case 22:
                str = @"z";
                break;
            case 23:
                str = @"x";
                break;
            case 24:
                str = @"c";
                break;
            case 25:
                str = @"v";
                break;
            case 26:
                str = @"b";
                break;
            case 27:
                str = @"n";
                break;
            case 28:
                str = @"m";
                break;
            case 29:
                str = @"!";
                break;
            case 30:
                str = @"?";
                break;
            case 31:
                str = @"";//caps
                break;
            case 32:
                str = @"";//num
                break;
            case 33:
                str = @"";//world
                break;
            case 34:
                str = @" ";//space
                break;
            case 35:
                str = @"";//num
                break;
            case 36:
                str = @"";//none
                break;
        }
    }
    
    return str;
}

-(void)SetChangeStatus:(UInt16)nStatus
{
    m_nStatus = nStatus;
}

-(CGRect)GetKeyRect:(UInt16)uMode
{
    if (uMode == LAND_MODE)
        return m_rtLandKey;
    else
        return m_rtPortKey;
        
}

-(UIImage*) GetKeyImage:(UInt16)uMode
{
    UIImage* img;
    if (uMode == LAND_MODE)
        img = m_imgLand;
    else
        img = m_imgPort;
    
    return img;
}

-(UIImage*) GetKeySelImage:(UInt16)uMode
{
    UIImage* img;
    if (uMode == LAND_MODE)
        img = m_imgLandSel;
    else
        img = m_imgPortSel;
    return img;
}

-(UInt16)GetKeyStatus
{
    return m_nStatus;
}

-(void)dealloc
{
    [m_imgPort release];
    [m_imgPortSel release];

    [m_imgLand release];
    [m_imgLandSel release];
    
    [super dealloc];
    
}

@end
