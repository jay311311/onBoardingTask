import Foundation

class ViewModel{    
    //urlSession
    func makeURL(query:String) -> URL {
        let baseUrl  =  URL(string: "https://api.itbook.store/1.0/")
        // ** 가능하다면 , 추후 enum 으로 바꿔서 구현하기
        
        if  query.contains("search") {
            // 검색 할 때 사용할 것
            print("검색할것이 왔느냐?? \(query)")
            let SearchCompomnent =  URL(string: "\(query)", relativeTo: baseUrl)!
            let searchUrl  = SearchCompomnent.absoluteURL
            return searchUrl
           
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
    // 추후 예외 처리
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
    
    // String으로 된 이미지 파일 파싱
    func showThumbnail(_ imageUrl : String,  completion : @escaping (Data) -> Void  ){
        let url =  URL(string: imageUrl)
        if let data = try? Data(contentsOf: url!){
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
}
