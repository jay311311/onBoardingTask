import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    init(){
        super.init(nibName: nil ,bundle: nil)
        let newTab =  NewBookViewController()
        let searchTab =  SearchViewController()
        
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
        
        setViewControllers([newNavi,searchNavi], animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("\(viewController.title)")
    }
    

}
