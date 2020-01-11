
import Foundation

struct Items: Codable {
    
    var items: [Information]?
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
    
}

struct Information: Codable {
    var title: String?
    let pagemap : TestPagemap?
    var link: String?
}


struct TestPagemap : Codable {
    
    let cseImage : [TestCseImage]?
    enum CodingKeys: String, CodingKey {
        case cseImage = "cse_image"
    }
}

struct TestCseImage : Codable {
    let src : String?
}
