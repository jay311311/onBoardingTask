import UIKit
import Then

class SearchViewController: UIViewController {
    lazy var saftyArea  = UIView()
    lazy var searchBar =  UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.placeholder = "검색어를 입력해보세요"
    }
    lazy var searchTable  = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchCell")
    }
    
    lazy var viewModel =  ViewModel()
    lazy var searchData:[SearchBook] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Search"
        searchTable.delegate = self
        searchTable.dataSource = self
        searchBar.delegate = self
//        hidesBottomBarWhenPushed = false
        setView()
    }
    
    func setView(){
        view.addSubview(saftyArea)
        saftyArea.snp.makeConstraints {
            $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        saftyArea.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
        }
        saftyArea.addSubview(searchTable)
        searchTable.snp.makeConstraints {
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
        }
    }
    func getData(_ searchItem : String){
        viewModel.loadData(caseName : .search ,query: "\(searchItem)", returnType: SearchBook.self) { item in
            if item.books.count == 0 {
                NotificationCenter.default.post(name: Notification.Name("errorMessage"), object: "검색결과가 없습니다.\n 다시 검색하세요")
            }
            print("갯수는 \(item.books.count)")
            self.searchData.append(item)
            self.searchTable.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchData = []
        searchTable.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let item = searchBar.text else { return }
        self.getData(item)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            searchData = []
            searchTable.reloadData()
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.first?.books.count  ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        guard let item = searchData.first?.books else { return UITableViewCell() }
        cell.setValue(item[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailBookViewController().then {
            $0.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController($0, animated: true)
            $0.sendData(response: (searchData.first?.books[indexPath.item].isbn13)!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

