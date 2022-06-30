import Foundation

class ViewModel{
    //var resultNewBook:[NewBook] = []
    
    //urlSession
    func makeURL() -> URL{
        let baseUrl  =  URL(string: "https://api.itbook.store/1.0/")
        let newComponent = URL(string: "new", relativeTo: baseUrl)!
        
        let newUrl  = newComponent.absoluteURL
        return newUrl
    }
    
    func loadData(completion :  @escaping (NewBook)->Void) {
//        let config  =  URLSessionConfiguration.default
//        let session  =  URLSession(configuration: config)
        let url  =  makeURL()
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, res, err) in
            guard err == nil else { return }
            guard let statusCode = (res as? HTTPURLResponse)?.statusCode else {return}
            let statusRange = 200..<300
            if statusRange.contains(statusCode) {
                guard let data = data else { return }
                do {
                    let decoder  =  JSONDecoder()
                    let result = try decoder.decode(NewBook.self, from: data)
//                    print("되니? \(result)")
                    DispatchQueue.main.async {
                        completion(result)
                       // print("\(self?.resultNewBook)")
                    }
                }catch let error {
                    print("\(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
}
