//
//  ViewController.swift
//  onBoardingTask1
//
//  Created by pineone on 2022/06/27.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let safetyArea =  UIView()
    let newTiTle =  UILabel()
    let newBooks =  UITableView()
    let newBookList =  UITableViewCell()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setSafeAreaZon()
        setValue()
        setView()
        setContraint()
        
        newBooks.dataSource = self
        newBooks.delegate = self
    }
    
    
    // 속성
    func setValue(){
        newTiTle.text  = "New Title"
        newTiTle.font =  UIFont.systemFont(ofSize: CGFloat(30), weight: .bold)
        
        newBookList.backgroundColor = .systemRed
        
    }
    
    
    // 뷰의 구성
    func setView(){
        safetyArea.addSubview(newTiTle)
        safetyArea.addSubview(newBooks)
     //   newBooks.addSubview(newBookList)
      //  newBooks.register(UITableViewCell.self, forCellReuseIdentifier: "newbook")
    }
    
    
    // 구성요소 제약
    func setContraint(){
        
        newTiTle.snp.makeConstraints { make in
            make.leading.equalTo(safetyArea).offset(20)
            make.top.equalTo(safetyArea).offset(40)
            make.trailing.equalToSuperview()
        }
        newBooks.snp.makeConstraints { make in
            make.top.equalTo(newTiTle.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    
    // safeArea존 생성
    func setSafeAreaZon(){
        safetyArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safetyArea)
        
        let guide =  view.safeAreaLayoutGuide
        safetyArea.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        safetyArea.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        safetyArea.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        safetyArea.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }


}

extension ViewController :  UITableViewDelegate, UITableViewDataSource{


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "newBook")
        let cell  =  tableView.dequeueReusableCell(withIdentifier: "newBook", for: indexPath) as! UITableViewCell

        

        return cell
    }


}






