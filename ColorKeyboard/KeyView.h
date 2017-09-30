//
//  KeyView.h
//  ColorKeyboard
//
//  Created by admin on 10/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyView : UIView {
    int     m_nKey;
    int     m_nKeyboardKind;
    UIImageView*    m_imgReleased;
    UIImageView*    m_imgPressed;
    int     m_nKeyState;
}

- (id) initWithKey:(int)key keyboardkind:(int)kind position:(CGPoint)position;

- (void) SetChangeStatus:(int)nStatus;
- (int) GetKeyStatus;
- (void) setKeyImage:(int)kind;
- (void) changePosition:(CGPoint)position;

@end
