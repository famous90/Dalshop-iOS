//
//  DalogField.h
//  Dalshop
//
//  Created by Hwang Gyuyoung on 2014. 7. 8..
//
//

#import <Foundation/Foundation.h>

// VIEW
long const VIEW_LOADING = 100;

long const VIEW_LOGIN =               200;
long const VIEW_JOIN =                210;
long const VIEW_PHONE_INPUT =         220;
long const VIEW_CERTIFICATION_INPUT = 230;
long const VIEW_FIRST_TUTORIAL =      240;
long const VIEW_EDIT_PROFILE =        250;

long const VIEW_TABBAR   =           300;
long const VIEW_TABBAR_ITEM_LIST =   301;
long const VIEW_TABBAR_SHOP_LIST =   302;
long const VIEW_TABBAR_LEFT_SLIDE =  303;
long const VIEW_TABBAR_RIGHT_SLIDE = 304;

long const VIEW_ITEM_LIST    =       320;
long const VIEW_ITEM_LIST_MY_LIKES = 321;
long const VIEW_ITEM_LIST_REWARD =   322;
long const VIEW_ITEM_LIST_DETAIL =   330;

long const VIEW_MAP  =       340;
long const VIEW_MAP_SHOP =   341;
long const VIEW_MAP_ITEM =   342;
long const VIEW_MAP_REWARD = 343;
long const VIEW_FLAG_LIST =  350;

long const VIEW_MY_PAGE  =       400;
long const VIEW_REWARD_HISTORY = 420;
long const VIEW_SETTINGS =       430;
long const VIEW_NOTICE   =       440;


// CATEGORY
long const CATEGORY_FIRST_USER = 100;

long const CATEGORY_VIEW_APPEAR  =   200;
long const CATEGORY_VIEW_DISAPPEAR = 201;

long const CATEGORY_SHOP_VIEW =  300;
long const CATEGORY_SHOP_SHARE = 301;
long const CATEGORY_SHOP_LIKE =  302;
long const CATEGORY_SHOP_MAP =   303;

long const CATEGORY_ITEM_VIEW =  400;
long const CATEGORY_ITEM_SHARE = 401;
long const CATEGORY_ITEM_LIKE =  402;
long const CATEGORY_ITEM_MAP =   403;

long const CATEGORY_CHECK_IN =   500;
long const CATEGORY_ITEM_SCAN =  501;
long const CATEGORY_ITEM_BUY =   502;

long const CATEGORY_LOCAL_PUSH = 600;
long const CATEGORY_EVENT_PUSH = 601;

long const CATEGORY_APP_SHARE =  700;


@protocol DalogField <NSObject>

@end
