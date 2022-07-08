import UIKit
import Then
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
//    lazy var newTab =  TestSafeAreaViewController().then{
//        $0.title = "test"
//        $0.tabBarItem = newTabItem
//    }
//
    
    lazy var newTab =  NewBookViewController().then{
        $0.title = "New Books"
        $0.tabBarItem = newTabItem
    }
    lazy var searchTab =  SearchViewController().then{
        $0.title = "Search"
        $0.tabBarItem = searchTabItem
    }
    lazy var newNavi = UINavigationController(rootViewController: newTab).then {
        $0.navigationBar.prefersLargeTitles = true
    }
    lazy var searchNavi = UINavigationController(rootViewController: searchTab).then {
        $0.navigationBar.prefersLargeTitles = true
    }
    lazy var newTabItem =  UITabBarItem(title: "New", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
    lazy var searchTabItem =  UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveErrorMessage), name: Notification.Name("errorMessage"), object: nil)
        super.viewDidLoad()
        self.delegate = self
    }
    
    @objc func receiveErrorMessage(_ notification:Notification){
        guard let message = notification.object  else { return }
        let alert = AlertViewController().addAlertAction("\(message)")
        present(alert, animated: false, completion: nil)
    }

    init(){
        super.init(nibName: nil ,bundle: nil)
        setViewControllers([newNavi,searchNavi], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("\(viewController.title)")
    }
    
    
}
