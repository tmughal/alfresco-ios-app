//
//  MainMenuViewController.h
//  AlfrescoApp
//
//  Created by Tauseef Mughal on 10/10/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "MainMenuItem.h"

@protocol MainMenuViewControllerDelegate <NSObject>

- (void)didSelectMenuItem:(MainMenuItem *)mainMenuItem;
- (UIViewController *)currentlyDisplayedController;

@end

@interface MainMenuViewController : UIViewController

@property (nonatomic, weak) id<MainMenuViewControllerDelegate> delegate;

- (instancetype)initWithAccountsSectionItems:(NSArray *)accountSectionItems;
- (void)displayViewControllerWithType:(MainMenuNavigationControllerType)controllerType;

@end
