import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class SearchViewController: UIViewController{
    lazy var historyWord =  UserDefaults.standard.string(forKey: "history")
    lazy var viewModel = SearchViewModel(historyWord)
    var disposeBag =  DisposeBag()
    
    lazy var showingNewBookCell : Bool = false
    lazy var saftyArea  = UIView()
    lazy var searchController = UISearchController(searchResultsController: nil)
    lazy var searchBar =  UISearchBar().then {
        $0.placeholder = "검색어를 입력해보세요"
    }
    lazy var searchTable  = UITableView().then {
        $0.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchCell")
        $0.register(TableViewCell.self, forCellReuseIdentifier: "newBook")
        $0.delegate = self
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
        viewModel.getData(historyText)
        bgLabel.text = ""
    }
    
    //MARK: - Rx: text Event to searhbar
    func editSearchBar(){
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext:{ [weak self] item in
                guard let self  =  self else { return  }
                if  item.count >= 2{
                    self.showingNewBookCell = false
                    self.viewModel.getData(item)
                    UserDefaults.standard.setValue(item, forKey: "history")
                }else if item.count < 2{
                    self.viewModel.outputSubject.accept([])
                    self.searchTable.backgroundView = self.bgLabel
                    self.bgLabel.text = "검색결과가 없습니다"
                }
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Rx: tableView
    func bindTableView(){
        //MARK: binding to Tableview
        viewModel.outputSubject.bind(to: searchTable.rx.items){ [weak self] (element, row, item) -> UITableViewCell  in
            guard let self = self  else  { return UITableViewCell() }
            if self.showingNewBookCell {
                guard let cell  =  element.dequeueReusableCell(withIdentifier: "newBook") as? TableViewCell else  {return TableViewCell()}
                element.separatorStyle = .none
                cell.setUpValue(item)
                return cell
            }else{
                guard let cell  =  element.dequeueReusableCell(withIdentifier: "searchCell") as? SearchTableViewCell else { return  SearchTableViewCell() }
                element.separatorStyle = .singleLine
                cell.setUpValue(item)
                return cell
            }
        }
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
}

extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if showingNewBookCell{
            return 300
        }else{
            return 150
        }
    }
}

class SearchViewModel{
    let query: String?
    lazy var page = 1

    lazy var netwroking = NetworkService.shared
    var disposeBag =  DisposeBag()

    var inputSubject  = PublishSubject<[Books]>()
    var outputSubject = PublishRelay<[Books]>()
    
    func getData(_ query :String?){
        guard let query = query else { return }

        netwroking.loadData(caseName: .search,query: query, page:page,returnType: SearchBook.self)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext:{ [weak self]  in
                        guard let self  = self else  {  return }
                        self.inputSubject.onNext($0.books)
                    }).disposed(by: disposeBag)
    }
    
    func subscribeInputSubject(){
        inputSubject.subscribe(onNext:{ [weak self] in
            guard let self  =  self else { return }
            self.outputSubject.accept($0)
        }).disposed(by: disposeBag)
    }
    
    init(_ query : String? ){
        self.query = query
        subscribeInputSubject()
        getData(query)
    }
}
