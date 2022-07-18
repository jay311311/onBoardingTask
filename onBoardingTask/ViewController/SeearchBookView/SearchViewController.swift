import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SearchViewController: UIViewController{
    lazy var page = 1
    lazy var netwroking = NetworkService.shared
    lazy var SearchRely =  PublishRelay<[Books]>()
    var disposeBag =  DisposeBag()
    lazy var viewModel = ViewModel()
    
    lazy var showingNewBookCell : Bool = false
    lazy var saftyArea  = UIView()
    lazy var searchController = UISearchController(searchResultsController: nil)
    //        .then {
    //        $0.searchResultsUpdater = self
    //    }
    lazy var searchBar =  UISearchBar().then {
        $0.placeholder = "검색어를 입력해보세요"
        //        $0.delegate = self
    }
    lazy var searchTable  = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchCell")
        $0.register(TableViewCell.self, forCellReuseIdentifier: "newBook")
        $0.delegate = self
        $0.separatorStyle = .none
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
        editSearchBar()
        pushToDetail()
    }
    
    func getHistoryData(){
        guard let historyText =  UserDefaults.standard.string(forKey: "history") else { return }
        getData(historyText)
        bgLabel.text = ""
    }
    
    //MARK: - Rx: text Event to searhbar
    func editSearchBar(){
        searchController.searchBar.rx.textDidBeginEditing.subscribe(onNext:{[weak self] in
            guard let self = self else { return }
            self.showingNewBookCell = false
             print("몇번찍히나")
        })
        
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext:{ [weak self] item in
                guard let self  =  self, let  historyText = UserDefaults.standard.string(forKey: "history") else { return  }
                if  item.count >= 2{
                    print("검색되야지 이제??\(item) & \(self.showingNewBookCell)")
                    self.getData(item)
                    UserDefaults.standard.setValue(item, forKey: "history")
                }else if item == ""{
                    self.SearchRely.accept([])
                    self.searchTable.backgroundView = self.bgLabel
                    self.bgLabel.text = "검색결과가 없습니다"
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Rx: tableView
    func bindTableView(){
        //MARK: binding to Tableview
        SearchRely.bind(to: searchTable.rx.items){ [weak self] (element, row, item) -> UITableViewCell  in
            guard let self = self  else  { return UITableViewCell() }
            if self.showingNewBookCell {
                var indexPath  =  IndexPath(item: row, section: 0)
                guard let cell  =  element.dequeueReusableCell(withIdentifier: "newBook", for: indexPath) as? TableViewCell else  {return TableViewCell()}
                cell.setUpValue(item)
                return cell

            }else{
                var indexPath  =  IndexPath(item: row, section: 0)
                guard let cell  =  element.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell else { return  SearchTableViewCell() }
                cell.setUpValue(item)
                
                return cell

            }
                    }
//        if showingNewBookCell == true {
//            print("showingNewBookCell true 가 어떻게 변했나?\(showingNewBookCell)")
//            SearchRely.bind(to: searchTable.rx.items(cellIdentifier: "newBook", cellType: TableViewCell.self)) { [weak self](index, element, cell) in
//                guard let self = self else  { return }
//                cell.mainTitle.text = element.title
//                cell.subTitle.text = element.subtitle
//                cell.isbn13.text = element.isbn13
//                cell.price.text = element.price
//                self.viewModel.showThumbnail(element.image) {
//                    cell.thumbnail.image = UIImage(data: $0)
//                }
//            }.disposed(by: disposeBag)
//        }else {
//            print("showingNewBookCell false 가 어떻게 변했나?\(showingNewBookCell)")
//            SearchRely.bind(to: searchTable.rx.items(cellIdentifier: "searchCell", cellType: SearchTableViewCell.self)){ [weak self](index, element, cell) in
//                guard let self = self else  { return }
//                cell.mainTitle.text = element.title
//                cell.subTitle.text = element.subtitle
//                cell.isbn13.text = element.isbn13
//                cell.price.text = element.price
//                self.viewModel.showThumbnail(element.image) {
//                    cell.thumbnail.image = UIImage(data: $0)
//                }
//            }.disposed(by: disposeBag)
//        }
    }
    
    //MARK: tap Evet to tableview
    func pushToDetail(){
        searchTable.rx.modelSelected(Books.self)
            .subscribe(onNext: {
                DetailBookViewController(sendingIsbn: $0.isbn13).then { [weak self ] in
                    guard let self  =  self else { return }
                    $0.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController($0, animated: true)
                }
//                self?.pushToDetail($0.isbn13)
            } ).disposed(by: disposeBag)
       
    }
    
    //MARK: - SetUp UIView
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
    
    //MARK: - NetworkService
    func getData(_ searchItem : String){
        netwroking.loadData(caseName: .search,query: searchItem, page:page,returnType: SearchBook.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ [weak self]  in
                guard let self  = self else  {  return }
                self.SearchRely.accept($0.books)
            }).disposed(by: disposeBag)
    }
}
//
//extension SearchViewController:   UISearchBarDelegate, UISearchResultsUpdating  {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let item =   searchController.searchBar.text, let  historyText = UserDefaults.standard.string(forKey: "history") else { return  }
//        if item.count  >= 2   {
//            showingNewBookCell = false
//            if historyText != item {
//                getData(item)
//                UserDefaults.standard.setValue(item, forKey: "history")
//            }
//        }else{
//            DispatchQueue.main.async {
//                self.searchTable.backgroundView = self.bgLabel
//                self.bgLabel.text = "검색결과가 없습니다"
//            }
//        }
//    }


extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showingNewBookCell{
            return 300
        }else{
            return 150
        }
    }
}


class SearchViewModel {
    
}
