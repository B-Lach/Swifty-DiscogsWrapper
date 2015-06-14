//
//  Helper.swift
//  DiscogsWrapper
//
//  Created by Benny Lach on 09.06.15.
//  Copyright (c) 2015 BL. All rights reserved.
//

import UIKit

enum ErrorMessagesIdentifier: String {
    
    case kUserNoId = "THe user has no Id"
    
    case kMasterNoId = "The master release has no Id"
    
    case kReleaseNoMasterId = "The release has no master Id"
    case kReleaseNoId = "The release has no Id"
    
    case kLabelNoId = "The label has no Id"
    
    case kUserNoUsername = "The user has no username"
}

enum ErrorCode: Int {
    case kMissingValue = -1
}

extension String {
    func toURL() -> NSURL? {
        return NSURL(string: self)
    }
    func toDate() -> NSDate? {
        if self.isEmpty {
            return nil
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        
        return formatter.dateFromString(self)
    }
}

class Helper {
    static let sharedInstance = Helper()
    
    private let errorDomain = "me.discollect.wrapper"
    
    private init() {}
    
    func getError(messageIdentifier: ErrorMessagesIdentifier, code: ErrorCode) -> NSError {
        return NSError(domain: errorDomain, code: code.rawValue, userInfo: [NSLocalizedFailureReasonErrorKey: messageIdentifier.rawValue])
    }
}
