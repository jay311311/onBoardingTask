import Foundation

class NetworkService {
    static let shared = NetworkService()
    var url: URL?
    //urlSession
    func makeURL(url:String , query:String, page :Int) -> URL {
        var components = URLComponents(string: "\(url)")!
        if page != 0 {
            components.path += "\(query)/\(page)"
        }else{
        components.path += "\(query)"
        }
        let url = components.url!
        return url
    }
    
    func loadData<T:Codable>  (caseName : UrlPath, query:String = "",page:Int = 0, returnType :T.Type , completion :  @escaping (T) ->Void) {
        let url =  makeURL(url: caseName.rawValue,query: query, page: page)
        let dataTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard err == nil else {
                return  DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("errorMessage") , object: err!.localizedDescription)
                }
            }
            guard let status = (res as? HTTPURLResponse)?.statusCode else { return }
            guard let data = data else { return }
            let errorCode = HTTPStatus(statusCode :status)
            if  errorCode == .ok  {
                print("url 좀 보자: \(url)")
                do {
                    let decoder  =  JSONDecoder()
                    let result = try decoder.decode(returnType, from: data)
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }catch let error { return }
            }else if errorCode ==  .badRequest{
                return DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("errorMessage") , object: "\(errorCode.rawValue) (\(status))")
                }
            }else if errorCode ==  .serverError{
                return DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("errorMessage") , object: "\(errorCode.rawValue) (\(status))")
                }
            }
        }
        dataTask.resume()
    }
}
