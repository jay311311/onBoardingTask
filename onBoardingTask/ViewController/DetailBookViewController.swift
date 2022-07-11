import UIKit
import SnapKit
import Then

class DetailBookViewController: UIViewController, sendDataDelegate {
    var sendingIsbn : String = ""
    lazy var viewModel =  ViewModel()
    lazy var netwroking = NetworkService.shared
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
        $0.text = "메모를 입력해주세요"
        $0.textColor = .systemGray3
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 5.0
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Detail Book"
        getData()
        setView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        guard  let inputbox  =  textView.text, let isbn13 = isbn13.text   else { return }
        print("\(inputbox)를 저장했다")
        if inputbox != "메모를 입력해주세요"{
            UserDefaults.standard.setValue(inputbox, forKey: isbn13)
        }
    }
    // delegate 패턴 데이터 전달
    func sendData(response: String) {
        sendingIsbn = response
    }
    
    func getData(){
        lazy var query:String = "\(sendingIsbn)"
        netwroking.loadData(caseName : .detail ,query: "\(query)", returnType: DetailBook.self) { [weak self] item in
            self?.setUpValue(item)
        }
    }
    
    func setUpValue( _ book :DetailBook){
        mainTitle.text = book.title
        subTitle.text = book.subtitle
        price.text = "\(book.price.calculateToDaller()) 원"
        isbn13.text = book.isbn13
        url.text = book.url
        viewModel.showThumbnail(book.image) { data in
            self.thumbnail.image = UIImage(data: data)
        }
        saveInputText(book.isbn13)
        
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

extension DetailBookViewController: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        textView.textColor = .black
        return true
    }
}


//extension DetailBookViewController: UINavigationControllerDelegate{
//    func navigationController(_ navigationController: UINavigationController, willshow viewController: UIViewController, animated: Bool) {
//        print("\(navigationController)  && \(viewController)")
//    }
//}
