import Foundation
import UIKit


class ViewModel{
    //urlSession
    func makeURL(url:String , query:String) -> URL {
        var components = URLComponents(string: "\(url)")!
        components.path += "\(query)"
        let url = components.url!
        return url
    }
    
    func loadData<T:Codable>  (caseName : UrlPath, query:String = "", returnType :T.Type , completion :  @escaping (T) ->Void) {
        let url =  makeURL(url: caseName.rawValue,query: query)
        let dataTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard err == nil else {
                return  DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("errorMessage") , object: err!.localizedDescription)
                }
            }
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
                    print("일반 error : \(error.localizedDescription)")
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
    
    func makeAlert( message :String) -> UIAlertController{
        let alertBox = UIAlertController(title: "경고", message: "\(message)", preferredStyle: .actionSheet)
        let action  = UIAlertAction(title: "확인", style: .destructive, handler: nil)
        alertBox.addAction(action)
        //self.presentView
        return alertBox
    }
}
