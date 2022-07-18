import Foundation
import RxSwift

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
            let url =  self.makeURL(url: caseName.rawValue,query: query, page: page)
            URLSession.shared.dataTask(with: url) { (data, res, err) in
                guard  let data = data, let res = res  else { return    }
                let status = (res as? HTTPURLResponse)?.statusCode
                let statusCode =  HTTPStatus(statusCode: status!)
                if statusCode == .ok {
                    do{
                        let decoder = JSONDecoder()
                        print("\(statusCode.rawValue) && \(data)")
                        let result  =  try decoder.decode(returnType, from: data)
                        observer.onNext(result)
                    }catch let err {
                        observer.onError(err)
                        observer.onCompleted()
                    }
                }else if statusCode == .badRequest, let err = err{
                    print("\(statusCode.rawValue)")
                    observer.onError(err)
                }else if statusCode == .serverError, let err = err{
                    print("\(statusCode.rawValue)")
                    observer.onError(err)
                }
            }.resume()
            return Disposables.create()
        }
    }
    
}
