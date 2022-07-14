import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class NewBookViewController: UIViewController {
    var disposeBag = DisposeBag()
    lazy var viewModel = ViewModel()
    
    
    lazy var networking = NetworkService.shared
    lazy var addingCellNum  = 1
    lazy var resultNewBook: [NewBook] =  []
    
    //MARK: View
    
    lazy var safetyArea  =  UIView()
    lazy var newBookTable = UITableView().then{
        $0.register(TableViewCell.self, forCellReuseIdentifier: "newBook")
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.delegate = self
        $0.refreshControl = UIRefreshControl()
        $0.refreshControl?.addTarget(self, action: #selector(updateTable), for: .valueChanged)
    }
    
    deinit{
        print("NewBook 풀렸습니다")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setView()
        view.backgroundColor = .white
        getIsbn13()
    }
    
// - MARK: Rxswift
    func getIsbn13(){
        //MARK: cell 클릭시 이벤트
        newBookTable.rx.itemSelected
            .map{self.pickupIsbn($0.row)}
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                print("cell_ tap_subscribe : \(item)")
                self.presentToDetail(item)
            })
            .disposed(by: disposeBag)
    }
    // push to DetailView
    func presentToDetail(_ item : String){
        let detailVC = DetailBookViewController().then {
            $0.viewModel.isbnValue.onNext(item)
            $0.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController($0, animated: true)
        }
    }
    
    // pickup the Isbn13
    func pickupIsbn(_ index : Int ) -> String{
        guard let bookList = resultNewBook.first?.books else { return "" }
        return bookList[index].isbn13
    }
    
    
    func getData(){
        networking.loadData(caseName: .new, returnType: NewBook.self) { [weak self] item in
            guard let self  =  self else { return }
            self.resultNewBook.append(item)
            DispatchQueue.main.async {
                self.newBookTable.reloadData()
            }
        }
    }
    
    // 뷰의 구성
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
    
    @objc func updateTable(refresh : UIRefreshControl){
        let refreshControl =  self.newBookTable.refreshControl
        //        getData()
        DispatchQueue.main.async {
            refreshControl?.endRefreshing()
        }
    }
}
extension NewBookViewController : UIScrollViewDelegate{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("스크롤 y축 top : \(scrollView.contentOffset.y) && 전체 스크롤뷰 높이: \(scrollView.contentSize.height) && 보이는 프레임 노: \(scrollView.frame.height)" )
        if  (scrollView.contentOffset.y  >= scrollView.contentSize.height - scrollView.frame.height ) {
            if  addingCellNum < 5 {
                addingCellNum += 1
                newBookTable.reloadData()
            }
        }
    }
}

extension NewBookViewController :  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard  let cellNum  = resultNewBook.first?.books.count else  { return 0 }
        let cellCount  = (cellNum / 5) * addingCellNum
        return  cellCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "newBook", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        if let result =  resultNewBook.first?.books {
            cell.setUpValue(result[indexPath.row])
        }
        return cell
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let detailVC = DetailBookViewController().then {
    //            $0.hidesBottomBarWhenPushed = true
    //            self.navigationController?.pushViewController($0, animated: true)
    //            $0.sendData(response: (resultNewBook.first?.books[indexPath.item].isbn13)!)
    //        }
    //    }
    
    
}

