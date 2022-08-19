//
//  AppFlow.swift
//  onBoardingTask
//
//  Created by pineone on 2022/08/17.
//

import Foundation
import RxFlow
import UIKit
//Flow : 각 Flowsms 애플리케이션의 네비게이션 영역을 정의.네비게이션 action을 선언하는 곳(뷰컨이나 또 다른 Flow를 제시).
class AppFlow : Flow{
    var root: Presentable{
        return self.rootViewController
    }
    
    let rootViewController = TabBarViewController.shared
    
    let newFlow =  NewBookFlow()
    let searchFlow = SearchBookFlow()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step  = step as? MainStep else { return .none}
        
        switch step {
        case .initStep:
            return setUpTabBar()
        case .Detail:
            print("test1234")
            return .none
        default :
            return .none
        }
    }
    
   private func setUpTabBar() -> FlowContributors{
        print("여긴찍히니?")
       Flows.use(newFlow, searchFlow, when: .created) { [weak self](root1:UINavigationController , root2:UINavigationController)  in
           guard let self  = self else { return }
//           root1.navigationBar.prefersLargeTitles = true
//           root2.navigationBar.prefersLargeTitles = true

           lazy var newTabItem =  UITabBarItem(title: "New", image: UIImage(systemName: "book"), selectedImage: UIImage(systemName: "book"))
               lazy var searchTabItem =  UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))

           root1.tabBarItem = newTabItem
           root2.tabBarItem = searchTabItem
           
           self.rootViewController.setViewControllers([root1,root2], animated: false)
       }
       
       return .multiple(flowContributors: [.contribute(withNextPresentable: newFlow, withNextStepper: CompositeStepper(steppers: [OneStepper(withSingleStep: MainStep.NewBook)])),
                                           .contribute(withNextPresentable: searchFlow, withNextStepper: CompositeStepper(steppers: [OneStepper.init(withSingleStep: MainStep.Search)]))] )
    }
    
    
}
