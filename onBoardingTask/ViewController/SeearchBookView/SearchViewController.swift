import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay

class SearchViewController: UIViewController{
    lazy var page = 1
    lazy var netwroking = NetworkService.shared
    lazy var SearchRely =  PublishRelay<[Books]>()
    var disposeBag =  DisposeBag()
    lazy var viewModel = ViewModel()
    lazy var showingNewBookCell : Bool = false
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
        $0.register(TableViewCell.self, forCellReuseIdentifier: "newBook")
        $0.delegate = self
//        $0.dataSource = self
        $0.backgroundView =  self.bgLabel
    }
    lazy var searchTableBg = UIView()
    lazy var bgLabel = UILabel().then {
        $0.text = ""
        $0.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        $0.textColor = .systemGray2
    }
    deinit{
        print("SearchBook 풀렸습니다")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        title = "Search"
        navigationItem.hidesSearchBarWhenScrolling = false
        view.backgroundColor = .white
        showingNewBookCell = true
        setView()
        getHistoryData()
        bindTableView()
    }
   
    func getHistoryData(){
        guard let historyText =  UserDefaults.standard.string(forKey: "history") else { return  bgLabel.text = "검색결과가 없습니다"}
            getData(historyText)
            bgLabel.text = ""
    }
    func bindTableView(){
        if showingNewBookCell {
            SearchRely.bind(to: searchTable.rx.items(cellIdentifier: "newBook", cellType: TableViewCell.self)) { [weak self](index, element, cell) in
                guard let self = self else  { return }
                cell.mainTitle.text = element.title
                cell.subTitle.text = element.subtitle
                cell.isbn13.text = element.isbn13
                cell.price.text = element.price
                self.viewModel.showThumbnail(element.image) {
                    cell.thumbnail.image = UIImage(data: $0)
                }
            }.disposed(by: disposeBag)
        }else {
            SearchRely.bind(to: searchTable.rx.items(cellIdentifier: "searchCell", cellType: SearchTableViewCell.self)){ [weak self](index, element, cell) in
                guard let self = self else  { return }
                cell.mainTitle.text = element.title
                cell.subTitle.text = element.subtitle
                cell.isbn13.text = element.isbn13
                cell.price.text = element.price
                self.viewModel.showThumbnail(element.image) {
                    cell.thumbnail.image = UIImage(data: $0)
                }
            }.disposed(by: disposeBag)
        }
        searchTable.rx.modelSelected(Books.self)
            .subscribe(onNext: {[weak self] in
                self?.pushToDetail($0.isbn13)
            } ).disposed(by: disposeBag)
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
        netwroking.loadData(caseName: .search,query: searchItem, page:page,returnType: SearchBook.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ [weak self]  in
                guard let self  = self else  {  return }
                self.SearchRely.accept($0.books)
                self.searchTable.reloadData()
            }).disposed(by: disposeBag)
    }


    func pushToDetail(_ isbn:String){
        DetailBookViewController(sendingIsbn: isbn).then { [weak self ] in
            guard let self  =  self else { return }
            $0.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController($0, animated: true)
        }
    }
}




extension SearchViewController:   UISearchBarDelegate, UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        guard let item =   searchController.searchBar.text, let  historyText = UserDefaults.standard.string(forKey: "history") else { return  }
        if item.count  >= 2   {
            showingNewBookCell = false
            if historyText != item {
                getData(item)
                UserDefaults.standard.setValue(item, forKey: "history")
            }
        }else{
//            resultData = []
            DispatchQueue.main.async {
                self.searchTable.backgroundView = self.bgLabel
                self.bgLabel.text = "검색결과가 없습니다"
                self.searchTable.reloadData()
            }
        }
    }
}

//extension SearchViewController: UITableViewDataSource, UITableViewDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return resultData.first?.books.count  ?? 0
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let item = resultData.first?.books , let searchText =   searchController.searchBar.text else { return UITableViewCell() }
//        if  showingNewBookCell == true {
//            tableView.separatorStyle = .none
//            if let  cell =  tableView.dequeueReusableCell(withIdentifier: "newBook", for: indexPath) as? TableViewCell{
//                cell.setUpValue(item[indexPath.item])
//                return cell
//            }
//        }else{
//            tableView.separatorStyle = .singleLine
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell{
//                cell.setUpValue(item[indexPath.item])
//                return cell
//            }
//        }
//        return UITableViewCell()
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let searchText  = searchController.searchBar.text else { return 0 }
//        if showingNewBookCell == true{
//            return 300
//        }else{
//            return 150
//        }
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        DetailBookViewController().then {
//            $0.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController($0, animated: true)
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
extension SearchViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showingNewBookCell{
            return 300
        }else{
            return 150
        }
    }
}
