//
//  GameUnit.h
//  FishForecast
//
//  Created by  on 11/11/22.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TAB_TYPE {
    TAB_TEXT,
    TAB_BG,
    TAB_FONT,
    TAB_COUNT
};

enum BG_TYPE {
    BG_COLOR = 0,
    BG_TEXTURE
};

enum FONT_TYPE {
    FONT_BOLD = 0,
    FONT_ITALIC,
    FONT_UNDERLINE
};

@interface FontObj : NSObject {
    NSString* m_strName;
    NSString* m_strDisplayName;
    NSString* m_strFileName;
    CGFloat         m_fSize;
}

@property (nonatomic, assign) NSString* m_strName;
@property (nonatomic, assign) NSString* m_strDisplayName;
@property (nonatomic, assign) NSString* m_strFileName;
@property (nonatomic) CGFloat m_fSize;

- (id) initWithString:(NSString*)str;

@end

#define BG_TEXTURE_COUNT     30
@interface GameUnit : NSObject {
    NSMutableArray* m_arrayBgColors;
    NSMutableArray* m_arrayTextColors;
    NSMutableArray* m_arrayFonts;
    int m_nBgType;
    int m_nBgColorIndex;
    int m_nBgTextureIndex;
    int m_nTextColorIndex;
    int m_nShadowColorIndex;
}

@property(nonatomic) int m_nBgType;
@property(nonatomic) int m_nBgColorIndex;
@property(nonatomic) int m_nBgTextureIndex;
@property(nonatomic) int m_nTextColorIndex;
@property(nonatomic) int m_nShadowColorIndex;

- (void) loadData;
- (void) loadColorData;
- (void) loadFontData;
- (void) saveData;

- (int) getTextColorCount;
- (int) getBgColorCount;
- (int) getFontCount;

- (UIColor*) getTextColor:(int)index;
- (UIColor*) getBgColor:(int)index;
- (FontObj*) getFontObj:(int)index;

- (NSString*) getTextColorWithHexString:(int)index;
- (NSString*) getBgColorWithHexString:(int)index;

- (NSString*) getFilePathWithFileName:(NSString*)strFileName;
- (BOOL) isExistFile:(NSString*)strFilePath;
- (BOOL) isExistFileWithName:(NSString*)strFileName;
- (void) deleteFile:(NSString*)strPath;
- (void) copyFileFromMainbunble:(NSString*)strFileName ext:(NSString*)ext;
@end

extern GameUnit* g_GameUnit;