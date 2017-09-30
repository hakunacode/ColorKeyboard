//
//  AppDelegate.h
//  ColorKeyboard
//
//  Created by admin on 9/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _DEVICE_TYPE
{
	DEVICE_IPHONE_NORMAL = 0,
	DEVICE_IPHONE_RETINA,
	DEVICE_IPAD_NORMAL,
	DEVICE_IPAD_RETINA,
    
	DEVICE_COUNT
} DEVICE_TYPE;

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController* m_navigationCtrl;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainViewController;

@end
