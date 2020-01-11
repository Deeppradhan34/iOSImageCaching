//
//  Extensions.swift
//  GoogleSearch
//
//  Created by Deep on 10/01/20.
//  Copyright © 2020 Deep. All rights reserved.
//

import UIKit


extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
}
