import UIKit
import SnapKit
import Then

class NewBookViewController: UIViewController {
    lazy var netwroking = NetworkService.shared
    lazy var resultNewBook: [NewBook] =  []
    lazy var safetyArea  =  UIView()
    lazy var newBooks = UITableView().then{
        $0.register(TableViewCell.self, forCellReuseIdentifier: "newBook")
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.delegate = self
        $0.refreshControl = UIRefreshControl()
        $0.refreshControl?.addTarget(self, action: #selector(updateTable), for: .valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getData()
        setView()
    }
    
    func getData(){
        netwroking.loadData(caseName: .new, returnType: NewBook.self) { item in
            self.resultNewBook.append(item)
            self.newBooks.reloadData()
        }
    }
    
    // 뷰의 구성
    func setView(){
        view.addSubview(safetyArea)
        safetyArea.snp.makeConstraints {
            $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        safetyArea.addSubview(newBooks)
        newBooks.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
  
    @objc func updateTable(refresh : UIRefreshControl){
        let refreshControl =  self.newBooks.refreshControl
        getData()
        DispatchQueue.main.async {
            refreshControl?.endRefreshing()
           
        }
    }
}


extension NewBookViewController :  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultNewBook.first?.books.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "newBook", for: indexPath) as! TableViewCell
        guard let result =  resultNewBook.first?.books else { return   UITableViewCell() }
        cell.setUpValue(result[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailBookViewController().then {
            $0.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController($0, animated: true)
            $0.sendData(response: (resultNewBook.first?.books[indexPath.item].isbn13)!)
        }
    }
      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        print(indexPath)
        return nil
    }
}
