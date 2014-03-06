//
//  KKSecondViewController.m
//  KKDemo
//
//  Created by Manan Patel on 2/13/14.
//  Copyright (c) 2014 Manan Patel. All rights reserved.
//

#import "KKSecondViewController.h"
#import "KKSpread.h"
#import "KKOhlc.h"
#import "KKTicker.h"

@interface KKSecondViewController ()

@property (nonatomic, assign) KKTicker *ticker;
@property (nonatomic, assign) NSArray *ohlcs;
@property (nonatomic, assign) UIView IBOutlet *chartContainer;
@property (nonatomic, assign) UILabel IBOutlet *time;
@property (nonatomic, assign) UILabel IBOutlet *currentPrice;
@property (nonatomic, assign) UILabel IBOutlet *highlow;
@property (nonatomic, assign) UILabel IBOutlet *openclose;
@property (nonatomic, assign) UILabel IBOutlet *askbid;
@property (nonatomic, assign) UILabel IBOutlet *volume;

@property (nonatomic, assign) UILabel IBOutlet *_24hrVolume;
@property (nonatomic, assign) UILabel IBOutlet *_24hrWap;
@property (nonatomic, assign) UILabel IBOutlet *_24hrHighLow;

@end

@implementation KKSecondViewController

- (void)fetchData
{
    [KKOhlc fetchCurrentDayOhlcs:^(NSArray *ohlcs, NSError *error) {
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        else
        {
            self.ohlcs = ohlcs;
            [self drawChart];
        }
        
        
    }];
    
    [KKTicker fetchData:^(KKTicker *ticker, NSError *error) {
        if (error)
        {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        else
        {
            self.ticker = ticker;
            [self refreshTickerData];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self fetchData];
}

- (void)viewDidLoad {
    //[self fetchData];
}


- (IGChartThemeDefinition *)getCustomTheme
{
    IGChartThemeDefinition* def = [[IGChartThemeDefinition alloc]init];
    def.font = [UIFont fontWithName:@"Helvetica" size:12];
    def.fontColor = [[IGBrush alloc] initWithR:0.2 andG:0.2 andB:0.2 andA:0.8];
    
    def.legendFont = [UIFont fontWithName:@"Helvetica" size:12];
    def.legendFontColor = [[IGBrush alloc] initWithR:0 andG:0 andB:0 andA:1];
    def.legendBorderThickness = 1;
    def.legendPalette = [[IGChartPaletteItem alloc]init];
    def.legendPalette.color = [[IGBrush alloc] initWithR:0.9 andG:0.9 andB:0.9 andA:1];
    def.legendPalette.outlineColor = [[IGBrush alloc] initWithR:0.7 andG:0.7 andB:0.7 andA:1];
    
    IGChartPaletteItem* item1 = [[IGChartPaletteItem alloc] init];
    item1.color = [[IGBrush alloc] initWithR:1 andG:.63 andB:0 andA:1];
    item1.outlineColor = [[IGBrush alloc] initWithR:0 andG:0 andB:0 andA:1];
    [def.seriesPalettes addObject:item1];
    
    IGChartPaletteItem* item2 = [[IGChartPaletteItem alloc] init];
    item2.color = [[IGBrush alloc] initWithR:.54 andG:.6 andB:.05 andA:1];
    item2.outlineColor = [[IGBrush alloc] initWithR:1 andG:1 andB:0 andA:0];
    [def.seriesPalettes addObject:item2];
    
    IGChartPaletteItem* item3 = [[IGChartPaletteItem alloc] init];
    item3.color = [[IGBrush alloc] initWithR:.94 andG:.3 andB:.05 andA:1];
    item3.outlineColor = [[IGBrush alloc] initWithR:0 andG:0 andB:0 andA:0];
    [def.seriesPalettes addObject:item3];
    
    IGChartPaletteItem* item4 = [[IGChartPaletteItem alloc] init];
    item4.color = [[IGBrush alloc] initWithR:.5 andG:.06 andB:.42 andA:1];
    item4.outlineColor = [[IGBrush alloc] initWithR:0 andG:0 andB:0 andA:0];
    [def.seriesPalettes addObject:item4];
    
    IGChartPaletteItem* item5 = [[IGChartPaletteItem alloc] init];
    item5.color = [[IGBrush alloc] initWithR:.98 andG:.66 andB:.06 andA:1];
    item5.outlineColor = [[IGBrush alloc] initWithR:0 andG:0 andB:0 andA:0];
    [def.seriesPalettes addObject:item5];
    
    
    IGChartPaletteItem* axis = [[IGChartPaletteItem alloc] init];
    axis.outlineColor = [[IGBrush alloc] initWithR:.72 andG:.72 andB:.72 andA:.3];
    def.axisPalette = axis;
    return def;
}

- (void)animateTransition:(IGChartView *)chartView
{
    if([self.chartContainer.subviews count] == 0) {
        [self.chartContainer addSubview:chartView];
        [chartView setAlpha:0];
        [UIView animateWithDuration:0.5
                         animations:^{chartView.alpha=1;}
                         completion:^(BOOL finished){  }];
        return;
    }
    
    for (UIView *subView in self.chartContainer.subviews)
    {
        [UIView animateWithDuration:0.5
                         animations:^{subView.alpha=0.0;}
                         completion:^(BOOL finished){
                             [subView removeFromSuperview];
                             [self.chartContainer addSubview:chartView];
                             [chartView setAlpha:0];
                             [UIView animateWithDuration:0.5
                                              animations:^{chartView.alpha=1;}
                                              completion:^(BOOL finished){  }];
                         }];
    }
}

- (IGChartView *)prepareChart
{
    NSMutableArray* low = [[NSMutableArray alloc] init];
    NSMutableArray* high = [[NSMutableArray alloc] init];
    NSMutableArray* open = [[NSMutableArray alloc] init];
    NSMutableArray* close = [[NSMutableArray alloc] init];
    NSMutableArray* volume = [[NSMutableArray alloc] init];
    NSMutableArray* time = [[NSMutableArray alloc] init];
    
    float lowestPrice = MAXFLOAT, lowestVolume = MAXFLOAT;
    float highestPrice = -MAXFLOAT, highestVolume = -MAXFLOAT;
    for(KKOhlc* ohlc in self.ohlcs) {
        if (lowestPrice>[ohlc.low floatValue]) {
            lowestPrice = [ohlc.low floatValue];
        }
        if (highestPrice<[ohlc.high floatValue]) {
            highestPrice = [ohlc.high floatValue];
        }
        float vol = [ohlc.volume floatValue];
        if (lowestVolume>vol) {
            lowestVolume = vol;
        }
        if (highestVolume<vol) {
            highestVolume = vol;
        }
        
        [low addObject:ohlc.low];
        [high addObject:ohlc.high];
        [open addObject:ohlc.open];
        [close addObject:ohlc.close];
        [volume addObject:ohlc.volume];
        [time addObject:ohlc.time];
    }
    
    IGOHLCSeriesDataSourceHelper *source = [[IGOHLCSeriesDataSourceHelper alloc] init];
    source.openValues = open;
    source.highValues = high;
    source.lowValues = low;
    source.closeValues = close;
    source.volumeValues = volume;
    
    IGCategoryDateSeriesDataSourceHelper *timeSource = [[IGCategoryDateSeriesDataSourceHelper alloc] init];
    timeSource.dates = time;
    timeSource.values = volume;
    
    IGCategoryDateTimeXAxis *xAxis = [[IGCategoryDateTimeXAxis alloc] initWithKey:@"xAxis"];
    xAxis.minimum = ((KKOhlc*)[self.ohlcs objectAtIndex:0]).time;
    xAxis.maximum = ((KKOhlc*)[self.ohlcs objectAtIndex:[self.ohlcs count]-1]).time;
    xAxis.interval = 8640;
    xAxis.displayType = IGTimeAxisDisplayTypeContinuous;
    
    IGNumericYAxis *yAxis = [[IGNumericYAxis alloc] initWithKey:@"yAxis"];
    IGNumericYAxis *yAxisVolume = [[IGNumericYAxis alloc] initWithKey:@"yAxisVolume"];
    yAxisVolume.labelsLocation = IGAxisLabelsLocationOutsideRight;
    
    // Adjust max, min on yAxis
    yAxis.minimum = lowestPrice*0.99;
    yAxis.maximum = highestPrice*1.01;
    
    // Adjust max, min on yAxisVolume
    yAxisVolume.minimum = lowestVolume;
    yAxisVolume.maximum = highestVolume*4;
    
    IGFinancialPriceSeries *financialPriceSeries = [[IGFinancialPriceSeries alloc] initWithKey:@"financialPriceSeries"];
    financialPriceSeries.xAxis = xAxis;
    financialPriceSeries.yAxis = yAxis;
    financialPriceSeries.dataSource = source;
    financialPriceSeries.displayType = IGPriceDisplayTypeCandlestick;
    
    IGColumnSeries *columnSeries = [[IGColumnSeries alloc] initWithKey:@"columnSeries"];
    columnSeries.xAxis = xAxis;
    columnSeries.yAxis = yAxisVolume;
    columnSeries.dataSource = timeSource;
    
    IGChartView *chartView = [[IGChartView alloc] initWithFrame:CGRectMake(0, 0, self.chartContainer.frame.size.width, self.chartContainer.frame.size.height)];
    [chartView addAxis:xAxis];
    [chartView addAxis:yAxis];
    [chartView addAxis:yAxisVolume];
    
    [chartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [chartView addSeries:financialPriceSeries];
    [chartView addSeries:columnSeries];
    chartView.theme = [self getCustomTheme];
    

    [self animateTransition:chartView];
    return chartView;
}


-(void) refreshOhlcData
{
    KKOhlc* mostRecentOhlc = [self.ohlcs objectAtIndex:[self.ohlcs count]-1];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss"];
    
    [self.time setText:[formatter stringFromDate:mostRecentOhlc.time]];
    [self.currentPrice setText:[NSString stringWithFormat:@"%@ €",mostRecentOhlc.vwap]];
    [self.openclose setText:[NSString stringWithFormat:@"%@ / %@ €",mostRecentOhlc.open, mostRecentOhlc.close]];
    [self.highlow setText:[NSString stringWithFormat:@"%@ / %@ €",mostRecentOhlc.high, mostRecentOhlc.low]];
    [self.volume setText:[NSString stringWithFormat:@"%@",mostRecentOhlc.volume]];
}

- (void) refreshTickerData
{
    [self.askbid setText:[NSString stringWithFormat:@"%@ / %@ €",self.ticker.askPrice, self.ticker.bidPrice]];
    [self._24hrVolume setText:[NSString stringWithFormat:@"%@", self.ticker.f24hrVolume]];
    [self._24hrWap setText:[NSString stringWithFormat:@"%@ €", self.ticker.f24hrWap]];
    [self._24hrHighLow setText:[NSString stringWithFormat:@"%@ / %@ €", self.ticker.f24hrHigh, self.ticker.f24hrLow]];
}

- (void) drawChart
{
    [self prepareChart];
    [self refreshOhlcData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
