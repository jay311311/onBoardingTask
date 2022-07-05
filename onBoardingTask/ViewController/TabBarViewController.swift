import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
//    print("내가빨라2")

    let newTab =  NewBookViewController()
    let searchTab =  SearchViewController()
    
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

        print("내가빨라1")

        newTab.title = "New Books"
        searchTab.title = "Search"
        
        let newNavi = UINavigationController(rootViewController: newTab)
        let searchNavi = UINavigationController(rootViewController: searchTab)
        
        newNavi.navigationBar.prefersLargeTitles = true
        searchNavi.navigationBar.prefersLargeTitles = true
        
        let newTabItem =  UITabBarItem(title: "New", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
        let searchTabItem =  UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        newTab.tabBarItem = newTabItem
        searchTab.tabBarItem = searchTabItem
        
        setViewControllers([newNavi,searchNavi], animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("\(viewController.title)")
    }
    
    
}
