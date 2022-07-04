

import UIKit

class SearchViewController: UIViewController {
    lazy var saftyArea  = UIView()
    lazy var searchBar: UISearchBar = {
        let searchBar  =  UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "검색어를 입력해보세요"
        return searchBar
    }()
    lazy var searchTable : UITableView = {
        let tableView  =  UITableView()
//        tableView.separatorStyle = .none
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchCell")
        return tableView
    }()
    
    lazy var viewModel =  ViewModel()
    lazy var searchData:[SearchBook] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Search"
        searchTable.delegate = self
        searchTable.dataSource = self
        searchBar.delegate = self
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
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
    func getData(_ searchItem : String){
        viewModel.loadData(query: "search/\(searchItem)", returnType: SearchBook.self) { item in
           
                self.searchData.append(item)
                print(self.searchData)
            
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
        print("취소를 눌렀다유 : \(searchBar.text)")
        searchBar.text = ""
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("검색을 눌렀다유 : \(searchBar.text)")
        guard let item = searchBar.text else { return }
        self.getData(item)
    }
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.first?.books.count  ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        guard let item = searchData.first?.books else { return UITableViewCell() }
        print("여기까지는 들어오니??\(item[indexPath.item])")
        cell.setValue(item[indexPath.item])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

