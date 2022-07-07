import Foundation
import UIKit

class ViewModel{
    // String으로 된 이미지 파일 파싱
    func showThumbnail(_ imageUrl : String,  completion : @escaping (Data) -> Void ){
        let url =  URL(string: imageUrl)
        if let data = try? Data(contentsOf: url!){
            completion(data)
        }
    }
}


extension String{
     func calculateToDaller() -> String {
        let won : Double = 1300.00 // 1달러당 환율
        var dallor =  self
        
        let numFormatter =  NumberFormatter()
        numFormatter.numberStyle = .decimal // 천원 절삭단위
        
        dallor.remove(at: dallor.startIndex)
        let stringToDouble =  Double(dallor)!
        let result:Double = Double(stringToDouble) * won
//        print(result)
        return numFormatter.string(from: NSNumber(value: result))!
    }
}
