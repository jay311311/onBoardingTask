import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NewBookViewController: UIViewController {
    var disposeBag = DisposeBag()
    lazy var viewModel = NewBooksViewModel()
//    lazy var addingCellNum  = 5
    lazy var newBookRely = PublishRelay<[Books]>()
    
    //MARK: View
    lazy var safetyArea  =  UIView()
    lazy var newBookTable = UITableView().then{
        $0.register(TableViewCell.self, forCellReuseIdentifier: "newBook")
        $0.separatorStyle = .none
        $0.delegate = self
//        $0.refreshControl = UIRefreshControl()
        //        $0.refreshControl?.addTarget(self, action: #selector(updateTable), for: .valueChanged)
    }
    
    deinit{
        print("NewBook 풀렸습니다")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setView()
        view.backgroundColor = .white
        bindTableView()
        refreshTableView()
    }
    //MARK: SetUpView
    func setView(){
        view.addSubview(safetyArea)
        safetyArea.snp.makeConstraints {
            $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        safetyArea.addSubview(newBookTable)
        newBookTable.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }
    
    //MARK: - Rx : tablview
    func bindTableView(){
        //MARK: dataBinding
        viewModel.ouputRely
            .observe(on: MainScheduler.instance)
            .bind(to: newBookTable.rx.items(cellIdentifier: "newBook",cellType: TableViewCell.self)){ [weak self] index,element, cell in
                guard let self  = self else { return }
               
                cell.mainTitle.text = element.title
                cell.subTitle.text = element.subtitle
                cell.isbn13.text = element.isbn13
                cell.price.text = element.price
                self.viewModel.showThumbnail(element.image) {
                    cell.thumbnail.image =  UIImage(data: $0)
                
                }
            }.disposed(by: disposeBag)

        newBookTable.rx.modelSelected(Books.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                print("cell_ tap_subscribe : \(item.isbn13)")
                self.pushToDetail(item.isbn13)
            })
            .disposed(by: disposeBag)
    }
    //MARK: tap Event
    func pushToDetail(_ item : String){
        DetailBookViewController(sendingIsbn: item).then {
            $0.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController($0, animated: true)
        }
    }
    
    
    //MARK: - Rx :Scroll Event
    func refreshTableView(){

//        guard let refreshControl =  self.newBookTable.refreshControl else { return }
        newBookTable.rx.didEndDragging
            .subscribe(onNext:{ [weak self] item in
                guard let self  =  self else { return }
                //MARK: pull to refresh 할때,  새로고침
                if self.newBookTable.contentOffset.y < 0.0 {
                    print("읽힌는가?")
                    self.viewModel = .init()
                }
                else {
                    //MARK: 5개씩 보여주는 인피니트 스크롤 _ 미완성
                    if self.newBookTable.contentOffset.y >= self.newBookTable.contentSize.height - self.newBookTable.frame.height - 100{
                        print("큽니다")
                        self.viewModel.showFiveContent()
//                        if self.addingCellNum < 5 {
//                            self.addingCellNum += 1
//                            self.newBookTable.reloadData()
//                        }
                    }
                }
            }).disposed(by: disposeBag)
    }
   
    
    //MARK: - NetworkService
    func getData(){
//        networking.loadData(caseName: .new, returnType: NewBook.self)
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext :{ [weak self] in
//                guard let self  =  self else {return}
//                self.newBookRely.subscribe(onNext : {print($0)})
//                self.newBookRely.accept($0.books)
//            }).disposed(by: disposeBag)
    }
    
    
    
    //    @objc func updateTable(refresh : UIRefreshControl){
    //        let refreshControl =  self.newBookTable.refreshControl
    //        getData()
    //        DispatchQueue.main.async {
    //            refreshControl?.endRefreshing()
    //        }
    //    }
}

extension NewBookViewController :  UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}



class NewBooksViewModel {
    var disposeBag  = DisposeBag()
    var addNum : Int = 0
    lazy var  resultArray:[Books]  = []
    lazy var inputSubject = PublishSubject<[Books]>()
    lazy var ouputRely = PublishRelay<[Books]>()

    
    func showFiveContent(){
        print("불러짐?")
        addNum += 1
        inputSubject
                .subscribe(onNext:{ [weak self] in
                    guard let self  = self else  { return }
                    let block  = $0.prefix(5)
                    self.ouputRely.accept(Array(block))
            }).disposed(by: disposeBag)
    
    
    let array   = self.resultArray.prefix(5 * addNum)
        ouputRely.accept(Array(array))
    }
    
    func showThumbnail(_ imageUrl : String,  completion : @escaping (Data) -> Void ){
        let url =  URL(string: imageUrl)
        if let data = try? Data(contentsOf: url!){
            completion(data)
        }
    }
    
    init(){
        lazy var netwroking = NetworkService.shared
        netwroking.loadData(caseName: .new, returnType: NewBook.self)
            .subscribe(onNext:{ [weak self] array in
                guard let self  = self else { return }
                self.resultArray += array.books
                self.inputSubject.onNext(array.books)
            }).disposed(by: disposeBag)
      showFiveContent()
        
        
    }
}
