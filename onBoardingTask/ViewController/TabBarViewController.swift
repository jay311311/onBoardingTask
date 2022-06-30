import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
       // self.tabBar.tintColor = .accent
        
        self.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let newTab =  NewBookViewController()
        let searchTab =  SearchViewController()
        
        newTab.title = "New"
        searchTab.title = "Search"
        
        let tabBarItem1 =  UITabBarItem(title: "New", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
        let tabBarItem2 =  UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))

        newTab.tabBarItem = tabBarItem1
        searchTab.tabBarItem = tabBarItem2
        
        
        self.viewControllers = [newTab , searchTab]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("\(viewController.title)")
    }
    

}
