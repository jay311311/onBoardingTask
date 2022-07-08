
import UIKit
import SnapKit

class TestSafeAreaViewController: UIViewController {

    let uiView1: UIView =  {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    let uiView2: UIView =  {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
        // Do any additional setup after loading the view.
    }
    
    
    func setView(){
        

        view.snp.makeConstraints {
            $0.directionalEdges.equalToSafeArea(view)
//            $0.directionalEdges.equalToSafeArea(view)
        }
        
        view.addSubview(uiView1)
        uiView1.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
//
        }
        
    }


}
