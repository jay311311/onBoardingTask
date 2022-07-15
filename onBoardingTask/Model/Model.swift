import Foundation

struct NewBook:Codable {
    var books : [Books]
}

struct SearchBook:Codable{
    var books : [Books]
}

struct Books:Codable, Hashable{
    var title : String
    var subtitle : String
    var isbn13 : String
    var price : String
    var image : String
    var url:String
}

struct DetailBook:Codable{
    var title : String
    var subtitle :String
    var isbn13: String
    var price : String
    var image : String
    var url:String
}




