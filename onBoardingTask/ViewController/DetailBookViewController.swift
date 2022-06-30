import UIKit
import SnapKit

class DetailBookViewController: UIViewController, sendDataDelegate {
    
    let bookImg =  UIView()
    let thumbnail =  UIImageView()
    let mainTitle = UILabel()
    let subTitle = UILabel()
    let price = UILabel()
    let isbn13 = UILabel()
    
    var sendingIsbn : String = ""
    
    override func viewDidLoad() {
        getData()
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpUI()
    }
    
    func sendData(response: String) {
        print("받았다 \(response)")
        sendingIsbn = response
    }
    func getData(){
        let query:String = "books/\(sendingIsbn)"
        ViewModel().loadData(query: "\(query)", returnType: DetailBook.self) { item in
            print("디테일 확인 : \(item)")
        }
    }
    
    
    func setUpUI(){
        setView()
        setContraint()
        setAttribute()
    }
    
    func setContraint(){
        
        
    }
    
    func setView(){
        
    }
    func setAttribute(){
        
    }
    
    


    
   
}
