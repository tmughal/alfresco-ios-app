/*******************************************************************************
 * Copyright (C) 2005-2015 Alfresco Software Limited.
 * 
 * This file is part of the Alfresco Mobile iOS App.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *  
 *  http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/
 
#import "NodePickerScopeViewController.h"
#import "MainMenuItem.h"
#import "NodePickerFileFolderListViewController.h"
#import "NodePickerSitesViewController.h"
#import "NodePickerFavoritesViewController.h"
#import "SyncViewController.h"
#import "SyncManager.h"
#import "NodePickerScopeCell.h"


static CGFloat const kCellHeight = 64.0f;

NSString * const kNodePickerScopeCellIdentifier = @"NodePickerScopeCellIdentifier";

@interface NodePickerScopeViewController ()

@property (nonatomic, strong) NSMutableArray *tableViewData;
@property (nonatomic, strong) id<AlfrescoSession> session;
@property (nonatomic, weak) NodePicker *nodePicker;

@end

@implementation NodePickerScopeViewController

- (id)initWithSession:(id<AlfrescoSession>)session nodePickerController:(NodePicker *)nodePicker;
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        _session = session;
        _nodePicker = nodePicker;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"nodes.picker.list.title", @"Attachments");
    [self configureScopeView];
    
    UINib *cellNib = [UINib nibWithNibName:@"NodePickerScopeCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kNodePickerScopeCellIdentifier];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancelButtonPressed:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.nodePicker hideMultiSelectToolBar];
    self.navigationItem.hidesBackButton = YES;
}

- (void)cancelButtonPressed:(id)sender
{
    [self.nodePicker cancel];
}

- (void)configureScopeView
{
    // App configuration code has been removed as it is not required as part of the document node picking workflow
    // To be confirmed with Marc
    self.tableViewData = [NSMutableArray array];
    
    NodePickerFileFolderListViewController *companyHomeViewController = [[NodePickerFileFolderListViewController alloc] initWithFolder:nil folderDisplayName:@"companyHome.title" session:self.session nodePickerController:self.nodePicker];
    MainMenuItem *companyHomeItem = [[MainMenuItem alloc] initWithIdentifier:kAlfrescoMainMenuItemCompanyHomeIdentifier
                                                                       title:NSLocalizedString(@"companyHome.title", @"Company Home")
                                                                       image:[UIImage imageNamed:@"mainmenu-repository.png"]
                                                                 description:nil
                                                                 displayType:MainMenuDisplayTypeDetail
                                                            associatedObject:companyHomeViewController];
    [self.tableViewData addObject:companyHomeItem];
    
    NodePickerSitesViewController *sitesListViewController = [[NodePickerSitesViewController alloc] initWithSession:self.session nodePickerController:self.nodePicker];
    MainMenuItem *sitesItem = [[MainMenuItem alloc] initWithIdentifier:kAlfrescoMainMenuItemSitesIdentifier
                                                                       title:NSLocalizedString(@"sites.title", @"Sites")
                                                                       image:[UIImage imageNamed:@"mainmenu-sites.png"]
                                                                 description:nil
                                                                 displayType:MainMenuDisplayTypeDetail
                                                            associatedObject:sitesListViewController];
    [self.tableViewData addObject:sitesItem];
    
    BOOL isSyncOn = [[SyncManager sharedManager] isSyncPreferenceOn];
    NodePickerFavoritesViewController *syncViewController = [[NodePickerFavoritesViewController alloc] initWithParentNode:nil session:self.session nodePickerController:self.nodePicker];
    MainMenuItem *syncItem = [[MainMenuItem alloc] initWithIdentifier:kAlfrescoMainMenuItemSyncIdentifier
                                                                title:NSLocalizedString(isSyncOn ? @"sync.title" : @"favourites.title", @"Sites")
                                                                 image:[UIImage imageNamed:isSyncOn ? @"mainmenu-sync.png" : @"mainmenu-favourites.png"]
                                                           description:nil
                                                           displayType:MainMenuDisplayTypeDetail
                                                      associatedObject:syncViewController];
    [self.tableViewData addObject:syncItem];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NodePickerScopeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kNodePickerScopeCellIdentifier];
    
    MainMenuItem *currentItem = self.tableViewData[indexPath.row];
    cell.label.text = currentItem.itemTitle;
    cell.thumbnail.tintColor = [UIColor appTintColor];
    [cell.thumbnail setImage:[currentItem.itemImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] withFade:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainMenuItem *selectedMenuItem = self.tableViewData[indexPath.row];
    UIViewController *viewController = selectedMenuItem.associatedObject;
    
    if (viewController)
    {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end
