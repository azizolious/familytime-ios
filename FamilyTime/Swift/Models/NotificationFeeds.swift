//
//  NotificationFeeds.swift
//  FamilyTime
//
//  Created by Rao Mudassar Khalil on 21/09/2021.
//  Copyright © 2021 YumyApps. All rights reserved.
//

import UIKit

class NotificationFeeds: NSObject {
    var feed_id:String?
    var action_text:String?
    var billing_status:String?
    var card_color:String?
    var customer_criteria:String?
    var end_date:String?
    var feed_data:String?
    var feed_snippet:String?
    var feed_snippet_color:String?
    var image_url:String?
    var is_active:String?
    var lang:String?
    var limit:String?
    var notification_type:String?
    var platform_id:String?
    var read_more_color:String?
    var sort_order:String?
    var start_date:String?
    var time_color:String?
    var title:String?
    var title_color:String?
    var trigger_point:String?
    var google_in_app_sub_id:String?
    var apple_in_app_sub_id:String?
    var fs_sub_url:String?
    var paddle_sub_url:String?
    var dashboard_sub_url:String?
    var web_cta:String?
    
    init(feed_id:String?,action_text:String?,billing_status:String?,card_color:String?,customer_criteria:String?,end_date:String?,feed_data:String?,feed_snippet:String?,feed_snippet_color:String?,image_url:String?,is_active:String?,lang:String?,limit:String?,notification_type:String?,platform_id:String?,read_more_color:String?,sort_order:String?,start_date:String?,time_color:String?,title:String?,title_color:String?,trigger_point:String?,google_in_app_sub_id:String?,apple_in_app_sub_id:String?,fs_sub_url:String?,paddle_sub_url:String?,dashboard_sub_url:String?,web_cta:String?) {
        self.feed_id =  feed_id
        self.action_text = action_text
        self.billing_status =  billing_status
        self.card_color = card_color
        self.customer_criteria =  customer_criteria
        self.end_date = end_date
        self.feed_data = feed_data
        self.feed_snippet =  feed_snippet
        self.feed_snippet_color =  feed_snippet_color
        self.image_url =  image_url
        self.is_active = is_active
        self.lang =  lang
        self.limit = limit
        self.notification_type = notification_type
        self.platform_id =  platform_id
        self.read_more_color =  read_more_color
        self.sort_order =  sort_order
        self.start_date = start_date
        self.time_color =  time_color
        self.title = title
        self.title_color = title_color
        self.trigger_point =  trigger_point
        self.apple_in_app_sub_id = apple_in_app_sub_id
        self.google_in_app_sub_id = google_in_app_sub_id
        self.fs_sub_url = fs_sub_url
        self.paddle_sub_url = paddle_sub_url
        self.dashboard_sub_url = dashboard_sub_url
        self.web_cta = web_cta
    }
}

