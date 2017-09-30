//
//  Dictionary.m
//  SwipeKey

//  created by YCH - 2011.11.02

#import "Dictionary.h"
#import "Word.h"
#import "GameUtils.h"

#include "algorithm"

@implementation RecordItem
@synthesize m_sKeyString, m_uStartTime;
//@synthesize aryPoint;
-(id) initItem:(NSString*)sKeyString uStartTime:(UInt32)uStartTime
{
    if ((self = [super init]))
    {
		self.m_sKeyString = sKeyString;
		self.m_uStartTime = uStartTime;
        //        self.aryPoint = aryPoint;
	}
	return self;
    
}

-(void) dealloc{
    [super dealloc];
}

@end

@implementation Dictionary
@synthesize m_nLastTime;

- (id) init 
{
    m_aryInputWord = [[NSMutableArray alloc] init];    
    m_aryBestWord = [[NSMutableArray alloc] init];  
    
    m_aryItem = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) loadContents {
    int count = 233613;//sizeof(sWord) / sizeof(sWord[0]);
    for (int i = 0; i < count; i++) {
        std::string  s(sWord[i]);
        m_map.insert(std::make_pair(s, 0));
    }
}

- (void) loadContents2 {
    int count = 58112;//sizeof(sWord) / sizeof(sWord[0]);
    v.reserve(count);
    for (int i = 0; i < count; i++) {
        v.push_back(sWord[i]);
    }
}

- (bool) exist:(const char*) word {
    return m_map.find(word) != m_map.end();
}

- (bool) exist2:(const char*) word {
    std::string s(word);
    std::transform(s.begin(), s.end(), s.begin(), std::tolower);
    return std::binary_search(v.begin(), v.end(), s);
}

- (void) outputHeaderFile:(const char*) file_path {
    int count = 234936;//sizeof(sWord) / sizeof(sWord[0]);
    v.reserve(count);
    
    int i;
    for (i = 0; i < count; i++) {
        std::string s(sWord[i]);
        std::transform(s.begin(), s.end(), s.begin(), std::tolower);
        v.push_back(s);
    }
    std::sort(v.begin(), v.end());
    v.erase(std::unique(v.begin(), v.end()), v.end());
    
    FILE* fp = fopen(file_path, "wt");
    
    for (i = 0; i < (int)v.size(); i++) {
        fprintf(fp, "\"%s\",\n", v[i].c_str());
    }
    
    //    NSLog(@"count = %d", v.size());
    
    fclose(fp);
}

-(void) setItem:(NSString*)sKey uStartTime:(UInt32)sTime
{
    RecordItem* item;
    item = [[RecordItem alloc] initItem:sKey uStartTime:sTime];
    [m_aryItem addObject:item];
}

-(void)removeItem
{
    [m_aryItem removeAllObjects];
}

-(void)searchWord
{
    [m_aryInputWord removeAllObjects];
    [m_aryBestWord removeAllObjects];
    
    [self addTwiceString_1];
    //    [self addTwiceString];
    [self removeSmallItem];
    [self makeInputWord];
    [self findBestWord];
    [self removeSameString];
    
    //delete key item
    [m_aryItem removeAllObjects];
}

/*
 -(void)findTwiceString
 {
 int nCount = [m_aryItem count];
 RecordItem* item;
 int i,j, ptCount;
 
 for (i = 0; i < nCount; i ++)
 {
 item = [m_aryItem objectAtIndex:i];
 NSMutableArray* aryPoint = item.aryPoint;
 ptCount = [aryPoint count];
 
 CGPoint pt;
 for (j = 0; j < ptCount; j ++)
 {
 pt = [[aryPoint objectAtIndex:j] CGPointValue];
 }
 
 }
 
 }
 */

-(void)addTwiceString_1
{
    int nCount = [m_aryItem count];
    if (nCount < 2)
        return;
    
    int i;
    UInt32 delta;
    RecordItem* item;
    RecordItem* itemNext;
    
    int nTeNum = 0;
    int nID[2];
    
    nID[0] = 0; 
    nID[1] = 0;
    //select long time item and convert twice
    for (i = 0; i < (nCount-1); i ++)
    {
        item = [m_aryItem objectAtIndex:i];
        itemNext = [m_aryItem objectAtIndex:i + 1];
        
        delta = itemNext.m_uStartTime - item.m_uStartTime;
        item.m_uStartTime = delta;
        
        if (delta >= TWICE_TIME)
        {
            if (nTeNum < 2)
            {
                nID[nTeNum] = i;
                nTeNum ++;
            }
        }
    }
    
    //set last time
    item = [m_aryItem objectAtIndex:nCount-1];
    item.m_uStartTime = m_nLastTime - item.m_uStartTime;
    if (item.m_uStartTime >= TWICE_TIME)
    {
        if (nTeNum < 2)
        {
            nID[nTeNum] = nCount-1;
            nTeNum ++;
        }
    }
    
    for (int k = 0; k < nTeNum; k ++)
    {
        item = [m_aryItem objectAtIndex:(nID[k] + k)];
        
        UInt32 uTime = item.m_uStartTime;
        NSString* sWord = item.m_sKeyString;
        sWord = [NSString stringWithFormat: @"%@%@", sWord, sWord];
        
        RecordItem* itemNew = [[RecordItem alloc] init];
        itemNew.m_uStartTime = uTime;
        itemNew.m_sKeyString = sWord;
        
        [m_aryItem insertObject:itemNew atIndex:(nID[k]+1 + k)];
        [itemNew release];
        
    }
    
    //LOG OUT-------------------------------------------
    //    nCount = [m_aryItem count];
    //    NSLog(@"count = %d", nCount);
    //    for (i = 0; i < nCount; i ++ )
    //    {
    //        item = [m_aryItem objectAtIndex:i];
    //        NSLog(@"key - %@, time = %lu ms", item.m_sKeyString, item.m_uStartTime);
    //    }
    //    int nnn = 3;
    //----------------------------------------------
    
}

-(void)addTwiceString
{
    int nCount = [m_aryItem count];
    if (nCount < 2)
        return;
    
    int i;
    UInt32 delta;
    RecordItem* item;
    RecordItem* itemNext;
    
    int nTeNum = 0;
    //select long time item and convert twice
    for (i = 0; i < (nCount-1); i ++)
    {
        item = [m_aryItem objectAtIndex:i];
        itemNext = [m_aryItem objectAtIndex:i + 1];
        
        delta = itemNext.m_uStartTime - item.m_uStartTime;
        item.m_uStartTime = delta;
        
        if (delta >= TWICE_TIME)
        {
            if (nTeNum < 2)
            {
                NSString* sWord = item.m_sKeyString;
                sWord = [NSString stringWithFormat: @"%@%@", sWord, sWord];
                item.m_sKeyString = sWord;
                nTeNum ++;
            }
        }
    }
    
    //set last time
    item = [m_aryItem objectAtIndex:nCount-1];
    item.m_uStartTime = m_nLastTime - item.m_uStartTime;
    if (item.m_uStartTime >= TWICE_TIME)
    {
        if (nTeNum < 2)
        {
            NSString* sWord = item.m_sKeyString;
            sWord = [NSString stringWithFormat: @"%@%@", sWord, sWord];
            item.m_sKeyString = sWord;
            nTeNum ++;
        }
    }
    
    //LOG OUT-------------------------------------------
    //    NSLog(@"count = %d", nCount);
    //    for (i = 0; i < nCount; i ++ )
    //    {
    //        item = [m_aryItem objectAtIndex:i];
    //        NSLog(@"key - %@, time = %lu ms", item.m_sKeyString, item.m_uStartTime);
    //    }
    //    int nnn = 3;
    //----------------------------------------------
    
}

-(void)removeSmallItem
{
    int nLimit = (MAX_WORD + 2);
    int nCount = [m_aryItem count];
    //LOG OUT-------------------------------------------
    //    RecordItem* item1;
    //    NSLog(@"count = %d", nCount);
    //    for (int j = 0; j < nCount; j ++ )
    //    {
    //        item1 = [m_aryItem objectAtIndex:j];
    //        NSLog(@"key - %@, time = %lu ms", item1.m_sKeyString, item1.m_uStartTime);
    //    }
    //----------------------------------------------
    
    if (nCount <= nLimit)
        return;
    
    int i;
    RecordItem* item;
    
    //select small item and remove
    UInt32 smalltime;
    int nID;
    
    while (nCount > nLimit)
    {
        item = [m_aryItem objectAtIndex:1];
        smalltime = item.m_uStartTime;
        nID = 1;
        
        for (i = 1; i < (nCount-1); i ++)
        {
            item = [m_aryItem objectAtIndex:i];
            if (item.m_uStartTime < smalltime)
            {
                smalltime = item.m_uStartTime;
                nID = i;
            }
        }
        
        [m_aryItem removeObjectAtIndex:nID];
        nCount = [m_aryItem count];
    }
    
    //LOG OUT-------------------------------------------
    //    NSLog(@"count = %d", nCount);
    //    for (i = 0; i < nCount; i ++ )
    //    {
    //        item = [m_aryItem objectAtIndex:i];
    //        NSLog(@"key - %@, time = %lu ms", item.m_sKeyString, item.m_uStartTime);
    //    }
    //----------------------------------------------
}

-(void)makeInputWord
{
    int nLen = [m_aryItem count];
    if (nLen < 2)
        return;
#ifdef LOGVIEW
    m_nLogStart = [g_GameUtils GetTickCount];
#endif
    
    RecordItem* item;
    
//LOG OUT -----------------------------------------------
//    for (int kkk = 0; kkk < nLen; kkk ++ )
//    {
//        item = [m_aryItem objectAtIndex:kkk];
//        NSLog(@"key - %@, time = %lu ms", item.m_sKeyString, item.m_uStartTime);
//    }
//--------------------------------------------------------------
    
    NSString *sFirst, *sEnd;
    
    item = [m_aryItem objectAtIndex:0];
    sFirst = item.m_sKeyString;
    
    item = [m_aryItem objectAtIndex:nLen-1];
    sEnd = item.m_sKeyString;
    
    //make word
    int nLenWord = nLen -2;
    NSString* sWord[MAX_WORD];
    BOOL  bWord[MAX_WORD];
    int i;
    for (i = 0; i < MAX_WORD; i ++)
    {
        sWord[i] = @"";
        bWord[i] = NO;
    }
    
    int k = 0;
    for (i = 1; i < (nLen-1); i ++)
    {
        item = [m_aryItem objectAtIndex:i];
        sWord[k] = item.m_sKeyString;
        k ++;
    }
    
    //make sequence word
    NSString* sNew = @"";
    NSMutableString* sMake = [[NSMutableString alloc] init];
    int nn = pow(2, nLenWord);
    for (i = (nn-1); i >= 0; i --) //make mode
        //    for (i = 0; i < nn; i ++)
    {
        [sMake setString:@""];
        sNew = @"";
        
        if (nLenWord >= 15)
        {
            if (i & 16384)
                bWord[14] = YES;
            else
                bWord[14] = NO;
        }
        
        if (nLenWord >= 14)
        {
            if (i & 8192)
                bWord[13] = YES;
            else
                bWord[13] = NO;
        }
        
        if (nLenWord >= 13)
        {
            if (i & 4096)
                bWord[12] = YES;
            else
                bWord[12] = NO;
        }
        
        if (nLenWord >= 12)
        {
            if (i & 2048)
                bWord[11] = YES;
            else
                bWord[11] = NO;
        }
        
        if (nLenWord >= 11)
        {
            if (i & 1024)
                bWord[10] = YES;
            else
                bWord[10] = NO;
        }
        
        if (nLenWord >= 10)
        {
            if (i & 512)
                bWord[9] = YES;
            else
                bWord[9] = NO;
        }
        
        if (nLenWord >= 9)
        {
            if (i & 256)
                bWord[8] = YES;
            else
                bWord[8] = NO;
        }
        
        if (nLenWord >= 8)
        {
            if (i & 128)
                bWord[7] = YES;
            else
                bWord[7] = NO;
        }
        
        if (nLenWord >= 7)
        {
            if (i & 64)
                bWord[6] = YES;
            else
                bWord[6] = NO;
        }
        
        if (nLenWord >= 6)
        {
            if (i & 32)
                bWord[5] = YES;
            else
                bWord[5] = NO;
        }
        
        if (nLenWord >= 5)
        {
            if (i & 16)
                bWord[4] = YES;
            else
                bWord[4] = NO;
        }
        
        if (nLenWord >= 4)
        {
            if (i & 8)
                bWord[3] = YES;
            else
                bWord[3] = NO;
        }
        
        if (nLenWord >= 3)
        {
            if (i & 4)
                bWord[2] = YES;
            else
                bWord[2] = NO;
        }
        
        if (nLenWord >= 2)
        {
            if (i & 2)
                bWord[1] = YES;
            else
                bWord[1] = NO;
        }
        
        if (nLenWord >= 1)
        {
            if (i & 1)
                bWord[0] = YES;
            else
                bWord[0] = NO;
        }
        
        for (int k = 0; k < nLenWord; k ++)
        {
            if (bWord[k])
                [sMake appendString:sWord[k]];
        }
        
        sNew = [NSString stringWithFormat: @"%@%@%@", sFirst, sMake, sEnd];
        [m_aryInputWord addObject:sNew];
    }
    
    [sMake release];
    
#ifdef LOGVIEW
    NSLog(@"makeInputWord = %ld mms", [g_GameUtils GetTickCount] - m_nLogStart);
#endif
    
}

-(void)findBestWord
{
    int nCount = [m_aryInputWord count];
    if (nCount < 1)
        return;
    
    NSString* sWord;
    const char* cWord;
    
    //    NSLog(@"input count %d", nCount);
#ifdef LOGVIEW
    m_nLogStart = [g_GameUtils GetTickCount];
#endif
    
    for (int i = 0; i < nCount; i++)
    {
        sWord = [m_aryInputWord objectAtIndex:i];
        cWord = [sWord cStringUsingEncoding:NSASCIIStringEncoding];//NSString to const char*
        
        if ([self exist2:cWord])
        {
            [m_aryBestWord addObject:sWord];
            
        }
    }
#ifdef LOGVIEW
    NSLog(@"findBestWord = %ld mms", [g_GameUtils GetTickCount] - m_nLogStart);
#endif
    
}

-(void)removeSameString
{
    int nCount = [m_aryBestWord count];
    if (nCount <= 1)
        return;
    
    NSString* sWord;
    NSString* sNext;
    int nID = 1;
    BOOL bFind = NO;
    
    while (YES)
    {
        bFind = NO;
        
        if (nID == nCount)
            break;
        
        sWord = [m_aryBestWord objectAtIndex:nID-1];
        for (int i = nID; i < nCount; i ++)
        {
            sNext = [m_aryBestWord objectAtIndex:i];
            if ([sWord isEqualToString:sNext])
            {
                [m_aryBestWord removeObjectAtIndex:i];
                nCount = [m_aryBestWord count];
                bFind = YES;
                break;
            }
        }
        
        if (!bFind)
            nID ++;
        
    }
    
    //LOG OUT-------------------------------------------
    //    NSString* str1;
    //    NSLog(@"count = %d", nCount);
    //    for (int j = 0; j < nCount; j ++ )
    //    {
    //        str1 = [m_aryBestWord objectAtIndex:j];
    //        NSLog(@"%@", str1);
    //    }
    //----------------------------------------------
    
}

-(NSMutableArray*)getBestWord
{
    return m_aryBestWord;
}

-(void)test
{
    /*
     const char* ppp[16] = {
     "Leucosticte",
     "leucosyenite",
     "leucotactic",
     "Leucothea",
     "Leucothoe",
     "leucotic",
     "leukocidin",
     "leukosis",
     "Leucosticte2342",
     "leucghosyenite",
     "leucocxvtactic",
     "Leucothadsea",
     "Leucotasdhoe",
     "leucotic",
     "leukocidzvin",
     "leukoafdfdsis",
     };
     
     //test english word match engine
     NSLog(@"Loading dictionary...");
     Dictionary* dic = [[Dictionary alloc] init];
     UInt32 start = GetTickCount();
     //[dic outputHeaderFile:"/volumes/system/111.cpp"];
     [dic loadContents2];
     NSLog(@"load time  = %lums", GetTickCount() - start);
     
     start = GetTickCount();
     for (int i = 0; i < 20000; i++) {
     bool ret = [dic exist2:ppp[i%16]];
     //        if (ret)
     //            NSLog(@"ok - %s", ppp[i%16]);
     //        else
     //            NSLog(@"no - %s", ppp[i%16]);
     }
     NSLog(@"total find time  = %lums", GetTickCount() - start);
     
     [dic release];
     //////////////////////
     */
    
}

- (void)dealloc 
{
    [m_aryInputWord removeAllObjects];
    [m_aryInputWord release];
    
    [m_aryBestWord removeAllObjects];
    [m_aryBestWord release];
    
    [m_aryItem removeAllObjects];
    [m_aryItem release];
    
    [super dealloc];
}

@end
