import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NewBookViewController: UIViewController {
    var disposeBag = DisposeBag()
    lazy var viewModel = NewBooksViewModel()
    //    lazy var newBookRely = PublishRelay<[Books]>()
    //MARK: View
    lazy var safetyArea  =  UIView()
    lazy var newBookTable = UITableView().then{
        $0.register(TableViewCell.self, forCellReuseIdentifier: "newBook")
        $0.separatorStyle = .none
        $0.delegate = self
    }
    
    deinit{ print("NewBook 풀렸습니다") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    //MARK:  Rx :Scroll Event
    func refreshTableView(){
        newBookTable.rx.didEndDragging
            .subscribe(onNext:{ [weak self] item in
                guard let self  =  self else { return }
                //MARK: pull to refresh 할때,  새로고침
                if self.newBookTable.contentOffset.y < 0.0 {
                    self.viewModel = .init()
                }
                else {
                    //MARK: 5개씩 보여주는 인피니트 스크롤 _ 미완성
                    if self.newBookTable.contentOffset.y >= self.newBookTable.contentSize.height - self.newBookTable.frame.height - 150{
                        self.viewModel.showFiveContent()
                    }
                }
            }).disposed(by: disposeBag)
    }
}

extension NewBookViewController :  UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}

//MARK: - ViewModel
class NewBooksViewModel {
    lazy var netwroking = NetworkService.shared
    
    var addNum : Int = 1
    lazy var  resultArray:[Books]  = []
    lazy var ouputRely = PublishRelay<[Books]>()
    var disposeBag  = DisposeBag()
    
    func showFiveContent(){
        if addNum < 5 {
            addNum += 1
            let array   = self.resultArray.prefix(5 * addNum)
            ouputRely.accept(Array(array))
        }
    }
    
    func showThumbnail(_ imageUrl : String,  completion : @escaping (Data) -> Void ){
        let url =  URL(string: imageUrl)
        if let data = try? Data(contentsOf: url!){
            completion(data)
        }
    }
    
    func getData(){
        netwroking.loadData(caseName: .new, returnType: NewBook.self)
            .subscribe(onNext:{ [weak self]  in
                guard let self  = self else { return }
                self.resultArray += $0.books
                let block  = self.resultArray.prefix(5)
                self.ouputRely.accept(Array(block))
                //                self.inputSubject.onNext($0.books)
            }).disposed(by: disposeBag)
    }
    
    init(){
        getData()
    }
}
