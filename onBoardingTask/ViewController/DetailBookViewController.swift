import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Alamofire

class DetailBookViewController: UIViewController {
    let sendingIsbn : String
    lazy var placeholderText:String = "메모를 입력해주세요"
    lazy var viewModel =  DetailBookViewModel(isbn: sendingIsbn)
//    lazy var detailRely  =  PublishRelay<DetailBook>()
    var disposeBag = DisposeBag()
    
    
    //MARK: View
    lazy var safetyArea = UIView()
    lazy var bookImg = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    lazy var bookInfo = UIView()
    lazy var thumbnail = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    lazy var mainTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    lazy var subTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    lazy var isbn13 = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
    lazy var price = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    lazy var url = UILabel().then {
        $0.textColor = .tintColor
    }
    lazy var line = UIView().then {
        $0.backgroundColor = .systemGray3
    }
    lazy var textView = UITextView().then{
        $0.backgroundColor = .white
        $0.text = placeholderText
        $0.textColor = .systemGray3
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 5.0
    }

     init(sendingIsbn: String){
         self.sendingIsbn = sendingIsbn
        super.init(nibName: nil, bundle: nil)
         view.backgroundColor = .white
         title = "Detail Book"
         bindDetailBook ()
         setView()
         editTextView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        print("DetailBook 풀렸습니다")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard  let inputbox  =  textView.text, let isbn13 = isbn13.text   else { return }
        if inputbox != placeholderText && inputbox !=  UserDefaults.standard.string(forKey: sendingIsbn)   {
            print("\(inputbox)를 저장했다")
            UserDefaults.standard.setValue(inputbox, forKey: isbn13)
        }
    }
    

    func bindDetailBook (){
        viewModel.outputRely.subscribe(onNext:{ [weak self] in
            guard let self  = self  else  { return }
            self.setUpValue($0)
        }).disposed(by: disposeBag)
    }
    
    func setUpValue(_ book :DetailBook){
        mainTitle.text = book.title
        subTitle.text = book.subtitle
        price.text = "\(book.price.calculateToDaller()) 원"
        isbn13.text = book.isbn13
        url.text = book.url
        viewModel.showThumbnail(book.image) { data in
            self.thumbnail.image = UIImage(data: data)
        } // Kingfisher 라이브러리 사용해보기
        saveInputText(book.isbn13)
    }
    
    //MARK: - Rx : textView Editing Event
    func editTextView(){
        textView.rx.didBeginEditing
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] item in
                guard let self  =  self  else  { return }
                self.textView.text = ""
                self.textView.textColor = .black
            print("editing start \(item)")
            }).disposed(by: disposeBag)
    }
    
    func saveInputText(_ key :String){
        guard let userDefault  = UserDefaults.standard.string(forKey: key)  else { return }
        textView.text = userDefault
        textView.textColor = .black
    }
    
    func setView(){
        view.addSubview(safetyArea)
        safetyArea.snp.makeConstraints {
            $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        safetyArea.addSubview(bookImg)
        bookImg.snp.makeConstraints {
            $0.directionalHorizontalEdges.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(1.25/3.0)
        }
        bookImg.addSubview(thumbnail)
        thumbnail.snp.makeConstraints {
            $0.center.height.equalToSuperview()
        }
        
        safetyArea.addSubview(bookInfo)
        bookInfo.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(bookImg.snp.bottom)
            $0.height.equalToSuperview().multipliedBy(1.75/3.0)
        }
        
        bookInfo.addSubview(mainTitle)
        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        bookInfo.addSubview(subTitle)
        subTitle.snp.makeConstraints {
            $0.top.equalTo(mainTitle.snp.bottom).offset(15)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        bookInfo.addSubview(isbn13)
        isbn13.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(5)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        bookInfo.addSubview(price)
        price.snp.makeConstraints {
            $0.top.equalTo(isbn13.snp.bottom).offset(5)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        bookInfo.addSubview(url)
        url.snp.makeConstraints {
            $0.top.equalTo(price.snp.bottom).offset(5)
            $0.directionalHorizontalEdges.equalToSuperview()
        }
        
        bookInfo.addSubview(line)
        line.snp.makeConstraints {
            $0.top.equalTo(url.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        bookInfo.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }
}



class DetailBookViewModel {
    let isbn : String
    
    var inputSubject =  PublishSubject<DetailBook>()
    var outputRely  =  PublishRelay<DetailBook>()
    var disposeBag = DisposeBag()
   
    lazy var netwroking = NetworkService.shared
    
//    func makeOutput(){
//        inputSubject.subscribe(onNext:{ [weak self] item in
//            guard let self  =  self else { return }
//            self.outputRely.accept(item)
//        }).disposed(by: disposeBag)
//    }
    func getData(_ isbn: String){
        netwroking.loadData(caseName: .detail, query: isbn, returnType: DetailBook.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext:{ [weak self] item in
                guard let self =  self else { return }
                self.outputRely.accept(item)
            }).disposed(by: disposeBag)
    }
    
    init(isbn:String){
        self.isbn = isbn
       getData(isbn)
//        makeOutput()
    }
    
    func showThumbnail(_ imageUrl : String,  completion : @escaping (Data) -> Void ){
        let url =  URL(string: imageUrl)
        if let data = try? Data(contentsOf: url!){
            completion(data)
        }
    }
}
