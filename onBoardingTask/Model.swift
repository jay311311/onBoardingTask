import Foundation

struct NewBook:Codable {
    var books : [Books]
}

struct SearchBook:Codable{
    var books : [DetailBook]
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

enum Path :String{
    case new =  "https://api.itbook.store/1.0/new"
    case detail = "https://api.itbook.store/1.0/books/"
    case search =  "https://api.itbook.store/1.0/search/"
   
}
