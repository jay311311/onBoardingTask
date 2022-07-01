import Foundation

struct NewBook:Codable {
    var books : [Books]
}

struct Books:Codable, Hashable{
    var title : String
    var subtitle : String
    var isbn13 : String
    var price : String
    var image : String
}

struct DetailBook:Codable{
    var title : String
    var subtitle :String
    var isbn13: String
    var price : String
    var image : String
    var url:String
}

protocol sendDataDelegate{
    func sendData(response: String) -> Void
}
