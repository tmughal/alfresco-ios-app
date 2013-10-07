//
//  SettingsViewController.m
//  AlfrescoApp
//
//  Created by Tauseef Mughal on 25/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "SettingsViewController.h"
#import "PreferenceManager.h"
#import "SettingToggleCell.h"
#import "SettingTextFieldCell.h"
#import "SettingConstants.h"

@interface SettingsViewController () <SettingsCellProtocol>

@end

@implementation SettingsViewController

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // create and configure the table view
    self.tableView = [[UITableView alloc] initWithFrame:view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:self.tableView];
    
    view.autoresizesSubviews = YES;
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self disablePullToRefresh];
	
    NSString *pListPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:pListPath];
    self.tableViewData = [dictionary objectForKey:kSettingsTableViewData];
    
    self.title = NSLocalizedString([dictionary objectForKey:kSettingsLocalizedTitleKey], @"Settings Title") ;
}

#pragma mark - Private Functions

- (Class)determineTableViewCellClassFromCellInfo:(NSDictionary *)cellInfo
{
    NSString *cellPreferenceType = [cellInfo objectForKey:kSettingsCellType];
    
    Class returnClass;
    
    if ([cellPreferenceType isEqualToString:kSettingsToggleCell])
    {
        returnClass = [SettingToggleCell class];
    }
    else if ([cellPreferenceType isEqualToString:kSettingsTextFieldCell])
    {
        returnClass = [SettingTextFieldCell class];
    }
    
    return returnClass;
}

- (NSString *)determineCellReuseIdentifierFromCellInfo:(NSDictionary *)cellInfo
{
    NSString *cellPreferenceType = [cellInfo objectForKey:kSettingsCellType];
    
    NSString *reuseIdentifier = nil;
    
    if ([cellPreferenceType isEqualToString:kSettingsToggleCell])
    {
        reuseIdentifier = kSettingsToggleCellReuseIdentifier;
    }
    else if ([cellPreferenceType isEqualToString:kSettingsTextFieldCell])
    {
        reuseIdentifier = kSettingsTextFieldCellReuseIdentifier;
    }
    
    return reuseIdentifier;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableViewData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.tableViewData objectAtIndex:section] objectForKey:kSettingsGroupCells] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *groupInfoDictionary = [self.tableViewData objectAtIndex:section];
    NSString *groupHeaderTitle = [groupInfoDictionary objectForKey:kSettingsGroupHeaderLocalizedKey];
    return groupHeaderTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *groupInfoDictionary = [self.tableViewData objectAtIndex:indexPath.section];
    NSArray *groupCellsArray = [groupInfoDictionary objectForKey:kSettingsGroupCells];
    NSDictionary *currentCellInfo = [groupCellsArray objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [self determineCellReuseIdentifierFromCellInfo:currentCellInfo];
    Class CellClass = [self determineTableViewCellClassFromCellInfo:currentCellInfo];
    
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = (SettingCell *)[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(CellClass) owner:self options:nil] lastObject];
    }
    
    id preferenceValue = [[PreferenceManager sharedManager] preferenceForIdentifier:[currentCellInfo valueForKey:kSettingsCellPerferenceIdentifier]];
    
    [cell updateCellForCellInfo:currentCellInfo value:preferenceValue delegate:self];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SettingsCellProtocol Functions

- (void)valueDidChangeForCell:(SettingCell *)cell perferenceIdentifier:(NSString *)preferenceIdentifier value:(id)value
{
    [[PreferenceManager sharedManager] updatePreferenceToValue:value preferenceIdentifier:preferenceIdentifier];
}

@end