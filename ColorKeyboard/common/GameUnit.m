//
//  GameUnit.m
//  FishForecast
//
//  Created by  on 11/11/22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GameUnit.h"

GameUnit* g_GameUnit;

@implementation FontObj

@synthesize m_strName, m_strDisplayName, m_fSize, m_strFileName;

- (id) init {
    if ((self = [super init])) {
        
    }
    return self;
}

- (void) dealloc {
    [m_strName release];
    [m_strDisplayName release];
    [m_strFileName release];
    [super dealloc];
}

- (id) initWithString:(NSString *)str {
    [self init];
    NSArray* array = [str componentsSeparatedByString:@","];
    m_strName = [[NSString alloc] initWithString:[array objectAtIndex:0]];
    m_strDisplayName = [[NSString alloc] initWithString:[array objectAtIndex:1]];
    if ([array count] >= 4)
        m_strFileName = [[NSString alloc] initWithString:[array objectAtIndex:3]];
    else
        m_strFileName = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        m_fSize = 14.0f;
    else
        m_fSize = 28.0f;
    return self;
}
@end

@implementation GameUnit

@synthesize m_nBgType, m_nBgColorIndex, m_nBgTextureIndex;
@synthesize m_nTextColorIndex, m_nShadowColorIndex;

- (id) init {
    if ((self = [super init])) {
        [self loadData];
    }
    return self;
}
- (void) dealloc {
    [m_arrayBgColors release];
    [m_arrayTextColors release];
    [m_arrayFonts release];
    [super dealloc];
}
- (void) loadData {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ( [defaults boolForKey:@"firstBoot"] == NO ) 
    {
    } 
    else 
    {
    }
    [self loadColorData];
    [self loadFontData];
}
- (void) loadColorData {
    NSString* strBgColor = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BackgroundColors" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray* array = [strBgColor componentsSeparatedByString:@"\n"];
    m_arrayBgColors = [[NSMutableArray alloc] initWithArray:array];

    NSString* strTextColor = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TextColors" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    array = [strTextColor componentsSeparatedByString:@"\n"];
    m_arrayTextColors = [[NSMutableArray alloc] initWithArray:array];
}
- (void) loadFontData {
	NSString* strDataPath =  [[NSBundle mainBundle] pathForResource:@"FontNames" ofType:@"plist"];
//	NSString *strError;
    NSDictionary *rootDict = [NSDictionary dictionaryWithContentsOfFile:strDataPath];
	NSArray *amountData = [rootDict objectForKey:@"font names"];
	
    m_arrayFonts = [[NSMutableArray alloc] init];
    for (id obj in amountData) {
        NSString* strFont = (NSString*)obj;
        FontObj* font = [[FontObj alloc] initWithString:strFont];
        [m_arrayFonts addObject:font];
        [font release];
    }
}
- (void) saveData {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:@"firstBoot"];
//    [defaults setBool:m_bLocalWeather forKey:@"LocalWeather"];
//    [defaults setInteger:m_nSelCityIndex forKey:@"CityIndex"];
//    [defaults setDouble:[m_dateDownload timeIntervalSince1970] forKey:@"DownloadTime"];
	[defaults synchronize];
}
- (int) getTextColorCount {
    return [m_arrayTextColors count];
}
- (int) getBgColorCount {
    return [m_arrayBgColors count];
}
- (int) getFontCount {
    return [m_arrayFonts count];
}

- (UIColor*) getTextColor:(int)index {
    if (index >= [m_arrayTextColors count])
        return [UIColor whiteColor];
    NSString* str = [m_arrayTextColors objectAtIndex:index];
    NSArray* array = [str componentsSeparatedByString:@","];
    int red, green, blue;
    red = [[array objectAtIndex:0] intValue];
    green = [[array objectAtIndex:1] intValue];
    blue = [[array objectAtIndex:2] intValue];
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}
- (UIColor*) getBgColor:(int)index {
    if (index >= [m_arrayBgColors count])
        return [UIColor whiteColor];
    NSString* str = [m_arrayBgColors objectAtIndex:index];
    NSArray* array = [str componentsSeparatedByString:@","];
    int red, green, blue;
    red = [[array objectAtIndex:0] intValue];
    green = [[array objectAtIndex:1] intValue];
    blue = [[array objectAtIndex:2] intValue];
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}
- (NSString*) getTextColorWithHexString:(int)index {
    NSString* str = [m_arrayTextColors objectAtIndex:index];
    NSArray* array = [str componentsSeparatedByString:@","];
    int red, green, blue;
    red = [[array objectAtIndex:0] intValue];
    green = [[array objectAtIndex:1] intValue];
    blue = [[array objectAtIndex:2] intValue];
    return [NSString stringWithFormat:@"%02X%02X%02X", red, green, blue];
}
- (NSString*) getBgColorWithHexString:(int)index {
    NSString* str = [m_arrayBgColors objectAtIndex:index];
    NSArray* array = [str componentsSeparatedByString:@","];
    int red, green, blue;
    red = [[array objectAtIndex:0] intValue];
    green = [[array objectAtIndex:1] intValue];
    blue = [[array objectAtIndex:2] intValue];
    return [NSString stringWithFormat:@"%02X%02X%02X", red, green, blue];
}

- (FontObj*) getFontObj:(int)index {
    return [m_arrayFonts objectAtIndex:index];
}
- (NSString*) getFilePathWithFileName:(NSString*)strFileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:strFileName];
}
- (BOOL) isExistFile:(NSString*)strFilePath {
    return [[NSFileManager defaultManager] fileExistsAtPath:strFilePath];
}
- (BOOL) isExistFileWithName:(NSString*)strFileName {
    NSString* strPath = [self getFilePathWithFileName:strFileName];
    return [self isExistFile:strPath];
}
- (void) deleteFile:(NSString*)strPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager fileExistsAtPath:strPath] == YES) {
        [fileManager removeItemAtPath:strPath error:&error];
    }
}
- (void) copyFileFromMainbunble:(NSString*)strFileName ext:(NSString*)ext {
    NSString* fullName = [NSString stringWithFormat:@"%@.%@", strFileName, ext];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* strPath = [self getFilePathWithFileName:fullName];
    NSError *error;
    if ([fileManager fileExistsAtPath:strPath] == NO) {
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:strFileName ofType:ext];
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:strPath error:&error];
        if (!success) {
            NSCAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
}

@end
