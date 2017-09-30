//
//  KeyImage.h
//  SwipeKey
//
//  Created by YCH on 2011.11.02

#import <Foundation/Foundation.h>

#define RELEASED    0
#define PRESSED     1

#define LAND_MODE   0
#define PORT_MODE   1

#define STYLE_NORMAL    0
#define STYLE_CYBER     1
#define STYLE_DEFAULT   2

@interface KeyImage : NSObject {
    
    UIImage*    m_imgPort;
    UIImage*    m_imgPortSel;
    
    UIImage*    m_imgLand;
    UIImage*    m_imgLandSel;
    
    CGRect      m_rtPortKey;
    CGRect      m_rtLandKey;
    
    int         m_nKeyID;
    UInt16      m_nStatus;
    
}
-(id)      Initkey:(int)nType posPort:(CGPoint)ptPortPos posLand:(CGPoint)ptLandPos;

-(void)     SetChangeStatus:(UInt16)nStatus;
-(UInt16)   GetKeyStatus;
-(CGRect)   GetKeyRect:(UInt16)uMode;
-(UIImage*) GetKeyImage:(UInt16)uMode;
-(UIImage*) GetKeySelImage:(UInt16)uMode;

-(NSString*)GetKeyString;

@end
