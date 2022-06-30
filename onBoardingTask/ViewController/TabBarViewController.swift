import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let newTab =  NewBookViewController()
        let searchTab =  SearchViewController()
        
        newTab.title = "New Books"
        searchTab.title = "Search"
        
        newTab.navigationItem.largeTitleDisplayMode = .always
        searchTab.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: newTab)
        let nav2 = UINavigationController(rootViewController: searchTab)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        
        let tabBarItem1 =  UITabBarItem(title: "New", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
        let tabBarItem2 =  UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))

        newTab.tabBarItem = tabBarItem1
        searchTab.tabBarItem = tabBarItem2
        
        setViewControllers([nav1,nav2], animated: false)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("\(viewController.title)")
    }
    

}
