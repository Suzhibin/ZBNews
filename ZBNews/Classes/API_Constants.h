//
//  API_Constants.h
//  ZBNews
//
//  Created by NQ UEC on 16/11/18.
//  Copyright © 2016年 Suzhibin. All rights reserved.
//

#ifndef API_Constants_h
#define API_Constants_h

// 0 -- 不加载html,  1 -- 加载
#define SERVERTYPE 0

#if(SERVERTYPE == 0)

#define APIKEY @"f9a63da22c1a152f1355a2c00ba18f4c"

#define MENU_URL @"https://apis.baidu.com/showapi_open_bus/channel_news/channel_news"

#define NEWS_URL @"https://apis.baidu.com/showapi_open_bus/channel_news/search_news"

#define NEWS_ARG @"channelId=%@&page=%ld&needContent=0&needHtml=0"
#define search_ARG @"title=%@&page=%ld&needContent=0&needHtml=0"

#elif(SERVERTYPE == 1)

#define APIKEY @"f9a63da22c1a152f1355a2c00ba18f4c"

#define MENU_URL @"https://apis.baidu.com/showapi_open_bus/channel_news/channel_news"

#define NEWS_URL @"https://apis.baidu.com/showapi_open_bus/channel_news/search_news"

#define NEWS_ARG @"channelId=%@&page=%ld&needContent=1&needHtml=1"
#define search_ARG @"title=%@&page=%ld&needContent=1&needHtml=1"
#endif



#endif /* API_Constants_h */
