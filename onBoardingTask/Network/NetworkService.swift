import Foundation
import RxSwift
import RxCocoa
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    private init(){    }
    
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
    
    func loadData<T:Codable>(caseName : UrlPath, query:String = "",page:Int = 0, returnType :T.Type ) -> Observable<T> {
        return  Observable.create { [weak self] observer  in
            guard let self  = self else { return Disposables.create() }
            let  url =  self.makeURL(url: caseName.rawValue,query: query, page: page)
            let request  =  AF.request(url)
            request
                .responseDecodable(of: returnType) { data  in
                    switch data.result {
                    case .success:
                        observer.onNext(data.value!)
                    case .failure:
                        guard let httpStatusCode =  data.response?.statusCode else { return }
                        let statusCode =  HTTPStatus(statusCode: httpStatusCode)
                            switch(statusCode){
                            case .badRequest:
                                observer.onError(data.error as! Error)
                                NotificationCenter.default.post(name: Notification.Name("errorMessage") , object: "\(HTTPStatus.badRequest.rawValue)")
                            case .error:
                                observer.onError(data.error as! Error)
                                NotificationCenter.default.post(name: Notification.Name("errorMessage") , object: "\(HTTPStatus.error.rawValue)")
                            case .serverError:
                                observer.onError(data.error as! Error)
                                NotificationCenter.default.post(name: Notification.Name("errorMessage") , object: "\(HTTPStatus.serverError.rawValue)")
                            }
                    }
                }
//            URLSession.shared.dataTask(with: url) { (data, res, err) in
//                guard  let data = data, let res = res  else { return    }
//                let status = (res as? HTTPURLResponse)?.statusCode
//                let statusCode =  HTTPStatus(statusCode: status!)
//                if statusCode == .ok {
//                    do{
//                        let decoder = JSONDecoder()
//                        print("\(statusCode.rawValue) && \(data)")
//                        let result  =  try decoder.decode(returnType, from: data)
//                        observer.onNext(result)
//                    }catch let err {
//
//                    }
//                }else if statusCode == .badRequest, let err = err{
//                    print("\(statusCode.rawValue)")
//                    observer.onError(err)
//                }else if statusCode == .serverError, let err = err{
//                    print("\(statusCode.rawValue)")
//                    observer.onError(err)
//                }
//            }.resume()
            return Disposables.create()
        }
    }
    
}
