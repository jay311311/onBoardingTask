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

protocol sendDataDelegate{
    func sendData(response: String) -> Void
}
protocol sendErrorDelegate{
    func sendError(error:String) -> Void
}

enum UrlPath :String{
    case new =  "https://api.itbook.store/1.0/new"
    case detail = "https://api.itbook.store/1.0/books/"
    case search =  "https://api.itbook.store/1.0/search/"
}

enum HTTPStatus : String {
    case continueStatus = "현재 처리중에 있습니다"
    case ok = "성공했습니다"
    case badRequest = "잘못된 요청은 처리할 수 없습니다"
    case serverError = "서버 에러로 해당 요청을 처리할수 없습니다"
    case error = "해당 요청을 처리할수 없습니다"

    init(statusCode: Int) {
        switch statusCode {
        case 100..<200 :
            self = .continueStatus
        case 200..<300:
            self = .ok
        case 400..<500:
            self = .badRequest
        case 500..<600:
            self = .serverError
        default:
            self = .error
        }
    }
}
