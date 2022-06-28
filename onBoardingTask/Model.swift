import Foundation

struct NewBook:Codable {
    var newBooks : [books]
    
    struct books:Codable{
        var title : String
        var subtitle : String
        var isbn13 : String
        var price : String
        var image : String
    }
}
