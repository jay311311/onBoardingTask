import UIKit
import Then

class SearchViewController: UIViewController{
    lazy var saftyArea  = UIView()
    lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.searchResultsUpdater = self
    }
    lazy var searchBar =  UISearchBar().then {
        $0.placeholder = "검색어를 입력해보세요"
        $0.delegate = self
    }
    lazy var searchTable  = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchCell")
        $0.delegate = self
        $0.dataSource = self
    }
    lazy var searchTableBg = UIView()
    lazy var bgLabel = UILabel().then {
        $0.text = "검색 결과가 없습니다"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        $0.textColor = .systemGray2
    }
    
    lazy var viewModel =  ViewModel()
    var searchData:[SearchBook] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.view.backgroundColor = .white
        setView()
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
            //            $0.top.equalTo(searchBar.snp.bottom)
        }
        searchTable.addSubview(searchTableBg)
        searchTableBg.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        searchTableBg.addSubview(bgLabel)
        bgLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(5)
        }
    }
    func getData(_ searchItem : String){
        viewModel.loadData(caseName : .search ,query: "\(searchItem)", returnType: SearchBook.self) { item in
            print("나오니 \(item)")
            self.searchData = []
            if item.books.count == 0 {
                print("0개 나오니 \(item)")
                self.searchTable.backgroundView = self.searchTableBg
                DispatchQueue.main.async {
                    self.searchTable.reloadData()
                }
                //                NotificationCenter.default.post(name: Notification.Name("errorMessage"), object: "검색결과가 없습니다.\n 다시 검색하세요")
                return
            }else{
                self.searchTable.backgroundView = nil
                print("갯수는 \(item.books.count)")
                self.searchData.append(item)
            }
            DispatchQueue.main.async {
                self.searchTable.reloadData()
            }
        }
    }
}

extension SearchViewController:   UISearchBarDelegate, UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        guard let item =   searchController.searchBar.text else { return  }
        if item == "" {
            print("비워야함")
            searchData = []
            DispatchQueue.main.async {
                self.searchTable.reloadData()
            }
        }else{
            
            getData(item)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchData = []
        searchTable.reloadData()
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
        DetailBookViewController().then {
            $0.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController($0, animated: true)
            $0.sendData(response: (searchData.first?.books[indexPath.item].isbn13)!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//class SearchTableBgView : uiTableview
