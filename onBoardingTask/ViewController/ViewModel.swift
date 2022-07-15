import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ViewModel{
    // String으로 된 이미지 파일 파싱
    func showThumbnail(_ imageUrl : String,  completion : @escaping (Data) -> Void ){
        let url =  URL(string: imageUrl)
        if let data = try? Data(contentsOf: url!){
            completion(data)
        }
    }
//   
}
