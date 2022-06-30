import Foundation

class ViewModel{
    //var resultNewBook:[NewBook] = []
    
    //urlSession
    func makeURL(query:String) -> URL {
        let baseUrl  =  URL(string: "https://api.itbook.store/1.0/")
        // ** 가능하다면 , 추후 enum 으로 바꿔서 구현하기
        
        if  query.contains("search") {
            // 검색 할 때 사용할 것
           
        }else if query.contains("books") {
            // 책 상세 로드 될 때
            print("인자가 들어오기는 했으나 \(query)")
            let detailComponent = URL(string: "\(query)", relativeTo: baseUrl)!
            let detailUrl  = detailComponent.absoluteURL
            return detailUrl
       
        }else if query.contains("new"){
            let newComponent = URL(string: "new", relativeTo: baseUrl)!
            let newUrl  = newComponent.absoluteURL
            return newUrl
        }
        return baseUrl!
       
    }
    
    func loadData<T:Codable>  (query:String, returnType :T.Type , completion :  @escaping (T) ->Void) {
        let url  =  makeURL(query: query)
        let dataTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard err == nil else { return }
            guard let statusCode = (res as? HTTPURLResponse)?.statusCode else {return}
            let statusRange = 200..<300
            if statusRange.contains(statusCode) {
                guard let data = data else { return }
                do {
                    let decoder  =  JSONDecoder()
                    let result = try decoder.decode(returnType, from: data)
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }catch let error {
                    print("\(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
}
