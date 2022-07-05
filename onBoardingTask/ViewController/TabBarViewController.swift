import UIKit
import Then
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
//    print("내가빨라2")
    let newTab =  NewBookViewController().then{
        $0.title = "New Books"
        
    }
  
    let searchTab =  SearchViewController().then{
        $0.title = "Search"
    }
        
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
       
        
        let newNavi = UINavigationController(rootViewController: newTab)
        let searchNavi = UINavigationController(rootViewController: searchTab)
        
        newNavi.navigationBar.prefersLargeTitles = true
        searchNavi.navigationBar.prefersLargeTitles = true
        
        let newTabItem =  UITabBarItem(title: "New", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
        let searchTabItem =  UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        self.newTab.tabBarItem = newTabItem
        self.searchTab.tabBarItem = searchTabItem
        
        setViewControllers([newNavi,searchNavi], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("\(viewController.title)")
    }
    
    
}
