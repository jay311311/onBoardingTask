import Foundation



class ViewModel{
    //urlSession
 
    func makeURL(url:String , query:String) -> URL {
        // ** 가능하다면 , 추후 enum 으로 바꿔서 구현하기
        var components = URLComponents(string: "\(url)")!
        components.path += "\(query)"
        let url = components.url!
        return url

    }
    // 추후 예외 처리
    func loadData<T:Codable>  (caseName : Path, query:String, returnType :T.Type , completion :  @escaping (T) ->Void) {
        print("enum 값을 보자 \(caseName.rawValue)")
//        caseName.paths += "\(query)"
        let url =  makeURL(url: caseName.rawValue,query: query)
        print("링크를 봐야될것 같군 \(url)")
        
        
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
