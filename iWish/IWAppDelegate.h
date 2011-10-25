//
//  IWAppDelegate.h
//  iWish
//
//  Created by John Paul Alcala on 10/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IWViewController;

@interface IWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IWViewController *viewController;

@end
