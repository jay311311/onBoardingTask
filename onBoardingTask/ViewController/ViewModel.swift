import Foundation
import UIKit
import SnapKit

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
        
        dallor.remove(at: dallor.startIndex) //
        let stringToDouble =  Double(dallor)!
        let result:Double = Double(stringToDouble) * won
        return numFormatter.string(from: NSNumber(value: result))!
    }
}


extension ConstraintMakerRelatable  {
    
    func makeSafeArea(_ other: ConstraintRelatableTarget){
        print("나오니 아더야? \(other)")

    }
    
    func equalToSafeArea(_ other : UIView,  _ file: String = #file, _ line: UInt = #line) -> Void {
        
//        var safeAreas =  other.top.bottom.leading.trailing.equalTo(other.safeAreaLayoutGuide)
//        return safeAreas
    }

}
