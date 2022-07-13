import UIKit
import SnapKit
import Then


class SearchViewController: UIViewController{
    lazy var page = 1
    lazy var netwroking = NetworkService.shared
    lazy var searchData:[SearchBook] = []
    
    lazy var saftyArea  = UIView()
    var historyText = UserDefaults.standard.string(forKey: "history")
    lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchResultsUpdater = self
    }
    lazy var searchBar =  UISearchBar().then {
        $0.placeholder = "검색어를 입력해보세요"
        $0.delegate = self
    }
    lazy var searchTable  = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchCell")
        $0.register(TableViewCell.self, forCellReuseIdentifier: "newBook")
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundView =  self.bgLabel
    }
    lazy var searchTableBg = UIView()
    lazy var bgLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        $0.textColor = .systemGray2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        title = "Search"
        //        navigationItem.title = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        view.backgroundColor = .white
        setView()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let historyText =  UserDefaults.standard.string(forKey: "history")  {
            getData(historyText)
            bgLabel.text = ""
        }
    }
    
    func setView(){
        view.addSubview(saftyArea)
        saftyArea.snp.makeConstraints {
            $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        saftyArea.addSubview(searchTable)
        searchTable.snp.makeConstraints {
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        bgLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(searchTable.snp.horizontalEdges).offset(20)
            $0.top.equalTo(searchTable.snp.top).inset(5)
        }
    }
    func getData(_ searchItem : String){
        netwroking.loadData(caseName : .search ,query: "\(searchItem)",page: page, returnType: SearchBook.self) {[weak self] item in
            print("나오니 \(item.books.count)")
            guard let self  = self else {return}
            self.searchData = []
            if item.books.count > 0{
                self.searchData.append(item)
                DispatchQueue.main.async {
                    self.bgLabel.text = nil
                    self.searchTable.reloadData()
                }
            }
        }
    }
}

extension SearchViewController:   UISearchBarDelegate, UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        guard let item =   searchController.searchBar.text else { return  }
        if item.count  >= 2  {
            getData(item)
            UserDefaults.standard.setValue(item, forKey: "history")
        }else{
            searchData = []
            DispatchQueue.main.async {
                self.searchTable.backgroundView = self.bgLabel
                self.bgLabel.text = "검색결과가 없습니다"
                self.searchTable.reloadData()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       print("취소버튼 눌렀다용")
     }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.first?.books.count  ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = searchData.first?.books , let searchText =   searchController.searchBar.text else { return UITableViewCell() }
        if searchText == "",  let historyText = historyText {
            tableView.separatorStyle = .none
            if let  cell =  tableView.dequeueReusableCell(withIdentifier: "newBook", for: indexPath) as? TableViewCell{
                cell.setUpValue(item[indexPath.item])
                return cell
            }
        }else{
            tableView.separatorStyle = .singleLine
            if let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell{
                cell.setUpValue(item[indexPath.item])
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let searchText  = searchController.searchBar.text else { return 0 }
        if searchText == "" && historyText != nil{
            return 300
        }else{
            return 150
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DetailBookViewController().then {
            $0.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController($0, animated: true)
            $0.sendData(response: (searchData.first?.books[indexPath.item].isbn13)!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
