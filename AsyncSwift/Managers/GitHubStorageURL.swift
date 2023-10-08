//
//  GitHubStorageURL.swift
//  AsyncSwift
//
//  Created by 김인섭 on 10/8/23.
//

import Foundation

enum GitHubStorageURL {
    
    static let baseUrl = "https://async-swift.github.io/jsonstorage"
    static let customDomain = "https://asyncswift.info/"
    
    static let widgetLargeImage = customDomain + "/Images/widget-large.svg"
    static let eventData = GitHubStorageURL.baseUrl + "/asyncswift.json"
    static var stampImage: (String) -> String {{ event in
        GitHubStorageURL.baseUrl + "/Images/Stamp/" + event + "/stamp.png"
    }}
    static let ticketingData = GitHubStorageURL.baseUrl + "/ticketing.json"
}
