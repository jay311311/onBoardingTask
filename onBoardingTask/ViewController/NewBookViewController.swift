import UIKit
import SnapKit

class NewBookViewController: UIViewController {
    
    var resultNewBook: [NewBook] =  []
    let safetyArea : UIView = {
        let uiView = UIView()
        return uiView
    }()
    let newBooks: UITableView = {
        let tableView = UITableView()
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "newBook")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        getData()
        setView()
        newBooks.dataSource = self
        newBooks.delegate = self
    }
    
    func getData(){
        ViewModel().loadData(query: "new", returnType: NewBook.self) { item in
            self.resultNewBook.append(item)
            self.newBooks.reloadData()
        }
    }
    
    // 뷰의 구성
    func setView(){
        view.addSubview(safetyArea)
        safetyArea.addSubview(newBooks)
        safetyArea.snp.makeConstraints {
            $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        newBooks.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
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
        let detailVC = DetailBookViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
        detailVC.sendData(response: (resultNewBook.first?.books[indexPath.item].isbn13)!)
    }
}
