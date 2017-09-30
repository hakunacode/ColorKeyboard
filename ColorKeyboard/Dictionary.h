//
//  Dictionary.h
//  SwipeKey

//  Created by YCH, Kwang on 2011.11.02

#import <Foundation/Foundation.h>

#include <vector>
#include <map>
#include <string>

@interface RecordItem : NSObject
{
    NSString*   m_sKeyString;
    UInt32      m_uStartTime;
    //    NSMutableArray* aryPoint;
    
}
@property(nonatomic, retain)    NSString*   m_sKeyString;
@property(nonatomic)            UInt32      m_uStartTime;
//@property(nonatomic, retain)    NSMutableArray* aryPoint;

//-(id) initItem:(NSString*)sKeyString uStartTime:(UInt32)uStartTime point:(NSMutableArray*)aryPoint;
-(id) initItem:(NSString*)sKeyString uStartTime:(UInt32)uStartTime;
@end


#define MAX_WORD     15
#define TWICE_TIME   550 


@interface Dictionary : NSObject {
    
    std::map<std::string, char>    m_map;
    std::vector<std::string> v;
    
    NSMutableArray*     m_aryInputWord;
    NSMutableArray*     m_aryBestWord;
    
    NSMutableArray*     m_aryItem;
    
    UInt32              m_nLastTime;
    
    UInt32 m_nLogStart;
}

@property(nonatomic)       UInt32              m_nLastTime;

- (void) loadContents;
- (bool) exist:(const char*) word;
- (void) loadContents2;
- (bool) exist2:(const char*) word;
- (void) outputHeaderFile:(const char*) file_path;

-(void) searchWord;
-(void) addTwiceString;
-(void) addTwiceString_1;
-(void) makeInputWord;
-(void) findBestWord;
-(void) removeSmallItem;
-(void) removeSameString;
-(NSMutableArray*)getBestWord;

//item
-(void) setItem:(NSString*)sKey uStartTime:(UInt32)sTime;
-(void) removeItem;

@end
