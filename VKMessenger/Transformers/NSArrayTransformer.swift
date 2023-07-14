//
//  NSArrayTransformer.swift
//  WebViewApp
//
//  Created by Vsevolod Lashin on 15.07.2023.
//

import Foundation

final class NSArrayTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let messages = value as? [String] else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: messages, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let allowedClasses = [NSArray.self, NSString.self]
            let messages = try NSKeyedUnarchiver.unarchivedObject(ofClasses: allowedClasses, from: data)
            return messages
        } catch {
            return nil
        }
    }
}
