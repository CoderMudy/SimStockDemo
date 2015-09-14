//
//  MarketListView.m
//  SimuStock
//
//  Created by Mac on 13-9-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

@implementation MarketListView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[SimuUtil colorWithHexString:@"#F7F7F7"];
        ssv_listMode=USCC_Mode_Default;
        self.clipsToBounds=YES;
        spv_pagedata=nil;
        [self creatViews];

        //纪录日志
        [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_PV andCode:@"行情-沪深A股"];
    }
    return self;
}

-(void)creatViews
{
    ssv_tableRect=CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height);
    //ssv_bottomRect=CGRectMake(0, ssv_tableRect.size.height, self.bounds.size.height, 20);
    //创建表格数据源
    if(ssv_tableViewDataResouce==nil)
    {
        ssv_tableViewDataResouce=[[SimuTableDataResouce alloc] init];
        ssv_tableViewDataResouce.delegate=self;
        NSString * m_ItemSort=[[NSUserDefaults standardUserDefaults] objectForKey:@"Item_Sort"] ;
        NSString * m_SortType=[[NSUserDefaults standardUserDefaults] objectForKey:@"Item_Type"];
        int col=-1;int type=-1;
        if(m_ItemSort!=nil && [m_ItemSort length]>0)
        {
            col =[m_ItemSort integerValue];
        }
        if(m_SortType!=nil && [m_SortType length]>0)
        {
            type=[m_SortType integerValue];
        }

        if(col!=-1 && type!=-1)
        {
            [ssv_tableViewDataResouce setIniteItemCorOrState:col State:type];
        }
    }
    //加入表格控件
    if(ssv_tableView==nil)
    {
        ssv_tableView=[[SimuTableView alloc]initWithFrame:ssv_tableRect];
        [self addSubview:ssv_tableView];
        ssv_tableView.delegate=self;
    }
    if(ssv_newSortListPageData==nil)
    {
        ssv_newSortListPageData=[[CustomPageDada alloc] init];
        ssv_newSortListPageData.pagetype=DataPageType_Market_GetStockInfo;
    }
    if(ssv_pagedata==nil)
    {
        ssv_pagedata=[[CustomPageDada alloc] init];
        ssv_pagedata.pagetype=DataPageType_Market_GetStockInfo;
    }
    [self creatNoDataMeesageView];
    

}
-(void)creatNoDataMeesageView
{
    spv_messageView=[[SimuShowMessageDataView alloc] initWithFrame:self.bounds];
    [self addSubview:spv_messageView];
    [spv_messageView setMessageData:@"暂无行情数据"];
    spv_messageView.hidden=YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark
#pragma mark 对外接口
-(UIScrollView *)GetupdateScrollView
{
    if(ssv_tableView!=nil)
    {
        return  [ssv_tableView getUpdateScrollView];
    }
    return nil;
}
#pragma mark
#pragma mark 设定页面数据
//设置网络数据
-(void)setUserPageData:(CustomPageDada *) m_pagedata
{
    if(m_pagedata==nil)
        return;
    if(ssv_pagedata!=nil)
    {
        [ssv_pagedata.DataArray removeAllObjects];
        [ssv_pagedata.DataArray addObjectsFromArray:m_pagedata.DataArray];
    }
    if(ssv_tableViewDataResouce!=nil)
    {
        ssv_tableViewDataResouce=nil;
    }
    if(ssv_tableViewDataResouce==nil)
    {
        ssv_tableViewDataResouce=[[SimuTableDataResouce alloc] init];
        ssv_tableViewDataResouce.delegate=self;
        NSString * m_ItemSort=[[NSUserDefaults standardUserDefaults] objectForKey:@"Item_Sort"] ;
        NSString * m_SortType=[[NSUserDefaults standardUserDefaults] objectForKey:@"Item_Type"];
        int col=-1;int type=-1;
        if(m_ItemSort!=nil && [m_ItemSort length]>0)
        {
            col =[m_ItemSort integerValue];
        }
        if(m_SortType!=nil && [m_SortType length]>0)
        {
            type=[m_SortType integerValue];
        }
        
        if(col!=-1 && type!=-1)
        {
            [ssv_tableViewDataResouce setIniteItemCorOrState:col State:type];
        }

        
    }
    if(nil!=ssv_tableViewDataResouce)
    {
        [ssv_tableViewDataResouce setPagedata:ssv_pagedata];
    }
    else
        return;
    if(ssv_newSortListPageData!=nil)
    {
        [ssv_newSortListPageData.DataArray removeAllObjects];
        [ssv_newSortListPageData.DataArray addObjectsFromArray:ssv_pagedata.DataArray];
    }
    //重新设定表格数据
    if(nil!=ssv_tableView && nil!=ssv_tableViewDataResouce)
    {
        ssv_tableView.dataReSouce=ssv_tableViewDataResouce;
        [ssv_tableView resetTable];
    }
}

-(void)SetUserPageNotInit:(CustomPageDada *) m_pagedata
{
    if(m_pagedata==nil)
        return;
    if(ssv_pagedata!=nil)
    {
        [ssv_pagedata.DataArray removeAllObjects];
        [ssv_pagedata.DataArray addObjectsFromArray:m_pagedata.DataArray];
    }
    if(ssv_pagedata!=nil)
    {
        if(nil!=ssv_tableViewDataResouce)
        {
            [ssv_tableViewDataResouce setPagedata:ssv_pagedata];
        }
        else
            return;
        //重新设定表格数据
        if(nil!=ssv_tableView && nil!=ssv_tableViewDataResouce)
        {
            ssv_tableView.dataReSouce=ssv_tableViewDataResouce;
            [ssv_tableView resetTableForSelfStock];
        }
    }

}

-(void)resetSelfCount
{
    if(ssv_tableViewDataResouce!=nil)
    {
        ssv_tableViewDataResouce.isSelfStockReset=0;
    }
}

#pragma mark
#pragma mark 消息展示
-(void)showNotNetMessage
{
    if(_delegate)
    {
        [_delegate showMessage:REQUEST_FAILED_MESSAGE];
    }
}

#pragma mark
#pragma mark SimuTableViewDelegate

-(void)SimuTableItemDidSelected:(NSInteger)selected_index
{
    
    if(selected_index<0 || selected_index>=[ssv_pagedata.DataArray count])
        return;
    if(ssv_listMode==USCC_Mode_Default)
    {
        StockItemInfo  * ItemInfo1=(ssv_pagedata.DataArray)[selected_index];
        NSString * stockCode=[NSString stringWithString:ItemInfo1.eightstockCode];
        NSString * stockName=[NSString stringWithString:ItemInfo1.stockname];
        if(_delegate)
        {
            [_delegate creatPersonViewControlerAndActive:stockCode Name:stockName];
        }
        
                              
    }
    else
    {
        if(ssv_newSortListPageData==nil)
            return;
        StockItemInfo  * ItemInfo1=(ssv_newSortListPageData.DataArray)[selected_index];
        NSString * stockCode=[NSString stringWithString:ItemInfo1.eightstockCode];
        NSString * stockName=[NSString stringWithString:ItemInfo1.stockname];
        if(_delegate)
        {
            [_delegate creatPersonViewControlerAndActive:stockCode Name:stockName];
        }

    }
    //纪录日志
    [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"114"];

    
}

#pragma mark
#pragma mark SimuTableDataResouceDelegate
-(void)ResequenceTableList:(UISortListMode)Sequence Cor:(NSInteger)m_col
{
    //网络排序
    NSInteger Item_Cor=2;
    switch (m_col)
    {
        case 1:
        {
            //最新价
           Item_Cor=1;
            //纪录日志
            [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"115"];

        }
        break;
        case 2:
        {
            //涨幅
             Item_Cor=2;
            //纪录日志
            [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"116"];

        }
        break;
        case 3:
        {
            //涨跌
            Item_Cor=6;
            //纪录日志
            [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"117"];

        }
        break;
        case 4:
        {
            //总量
            Item_Cor=3;
            //纪录日志
            [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"118"];

        }
        break;
        case 5:
        {
            //总额
            Item_Cor=4;
            //纪录日志
            [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"119"];

        }
        break;
        case 10:
        {
            //振幅
            Item_Cor=5;
            //纪录日志
            [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button andCode:@"120"];

        }
        break;
        default:
            break;
    }
    //设定排序方式
    NSInteger sort=1;
    if(Sequence==USLM_Mode_HighToLower || Sequence==USCC_Mode_Default)
    {
        //从大到小
        sort=1;
    }
    else
    {
        //从小到大
        sort=0;
    }
    
    if(_delegate)
    {
       [_delegate resetSeqencing: Item_Cor orderRow:sort];
    }
    
}

//得到重新排序后的页面
-(CustomPageDada *)SeqencingItemData:(UISortListMode)Sequence Cor:(NSInteger)m_col
{
    ssv_listMode=Sequence;
    if(Sequence==USCC_Mode_Default)
    {
        //默认排序
        return ssv_pagedata;
    }
    else
    {
        NSMutableArray * list=ssv_newSortListPageData.DataArray;
        //排序
        for (int j = 1; j<= [list count]; j++)
        {
            
            for(int i = 0 ;i < j ; i++)
            {
                
                if(i == [list count]-1)
                    break;
                
                StockItemInfo  * ItemInfo1=list[i];
                
                StockItemInfo * ItemInfo2 = list[i+1];
                CGFloat f_value1=0;
                CGFloat f_value2=0;
                long l_volum1=0;
                long l_volum2=0;
                double d_autom1=0;
                double d_autom2=0;
                if(m_col==1 || m_col==2 || m_col==3 || m_col==10)
                {
                    if(m_col==1)
                    {
                        //按照最新价排序
                        f_value1=[ItemInfo1.cornewPrices floatValue];
                        f_value2=[ItemInfo2.cornewPrices floatValue];
                    }
                    else if(m_col==2)
                    {
                        //按照涨幅排序
                        f_value1=ItemInfo1.fgins;
                        f_value2=ItemInfo2.fgins;
                    }
                    else if(m_col==3)
                    {
                        //按照涨跌排序
                        f_value1=[ItemInfo1.updownValue floatValue] ;
                        f_value2=[ItemInfo2.updownValue floatValue];
                    }
                    else if(m_col==10)
                    {
                        //按照振幅排序
                        f_value1=ItemInfo1.famplitude;
                        f_value2=ItemInfo2.famplitude;
                    }
                    if(Sequence==USLM_Mode_HighToLower)
                    {
                        if(f_value1 > f_value2)
                        {
                            [list exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                    }
                    else if(Sequence==USCC_Mode_LowerToHigh)
                    {
                        if(f_value1 < f_value2)
                        {
                            [list exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                    }
                }
                else if(m_col==4)
                {
                    //按照总量排序
                    l_volum1=ItemInfo1.lallVolume;
                    l_volum2=ItemInfo2.lallVolume;
                    if(Sequence==USLM_Mode_HighToLower)
                    {
                        if(l_volum1 > l_volum2)
                        {
                            [list exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                    }
                    else if(Sequence==USCC_Mode_LowerToHigh)
                    {
                        if(l_volum1 < l_volum2)
                        {
                            [list exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                    }
                }
                else if(m_col==5)
                {
                    //按照总额排序
                    d_autom1=ItemInfo1.lallAutome;
                    d_autom2=ItemInfo2.lallAutome;
                    if(Sequence==USLM_Mode_HighToLower)
                    {
                        if(d_autom1 > d_autom2)
                        {
                            [list exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                    }
                    else if(Sequence==USCC_Mode_LowerToHigh)
                    {
                        if(d_autom1 < d_autom2)
                        {
                            [list exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                        }
                    }
                    
                }
                
                
            }
            
        }
        return  ssv_newSortListPageData;
    }
}

//获得手机上网方式
-(NSString *)checkNetWork
{
    Reachability * reachability=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable:
            return nil;
        case ReachableViaWWAN:
            return @"3G或GPRS";
        case ReachableViaWiFi:
            return @"wifi";
            
        default:
            break;
    }
    return nil;
}



@end
