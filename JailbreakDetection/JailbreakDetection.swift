//
//  JailbreakDetection.swift
//  JailbreakDetection
//
//  Created by Tran Hoang Canh on 11/1/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import UIKit

/* You can detect if a device is JailBroken or not by checking for the following:
 - Cydia is installed
 - Verify some of the system paths
 - Perform a sandbox integrity check
 - Perform symlink verification
 - Verify whether you create and write files outside your Sandbox
 */
class JaibreakDetection {
    
    public static func jailbroken(application: UIApplication) -> Bool {
        guard let cydiaUrlScheme = NSURL(string: "cydia://package/com.example.package") else { return isJailbroken() }
        return application.canOpenURL(cydiaUrlScheme as URL) || isJailbroken()
    }
    
    
    static func isJailbroken() -> Bool {
        
        if TARGET_IPHONE_SIMULATOR != 0 {
            return false
        }
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath:"/usr/sbin/sshd") ||
            fileManager.fileExists(atPath:"/etc/apt") ||
            fileManager.fileExists(atPath:"/usr/bin/ssh") {
            return true
        }
        
        if canOpen(path: "/Applications/Cydia.app") ||
            canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            canOpen(path: "/bin/bash") ||
            canOpen(path: "/usr/sbin/sshd") ||
            canOpen(path: "/etc/apt") ||
            canOpen(path: "/usr/bin/ssh") {
            return true
        }
        
        let path = "/private/" + NSUUID().uuidString
        do {
            try "Jailbreak".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    static func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
}
