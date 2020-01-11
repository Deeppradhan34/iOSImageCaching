//
//  ErrorResponse.swift
//  GoogleSearch
//
//  Created by Deep on 23/11/19.
//  Copyright © 2019 Deep. All rights reserved.
//

import  Foundation

class ErrorResponse: NSObject {
    
   
    
    class ErrorResponse: Codable {
        var errorCode: String = ""
        var message: String = ""
        
        enum CodingKeys: String, CodingKey {
            case message
        }
        
        init(message: String) {
            self.message = message
        }
    }

}
