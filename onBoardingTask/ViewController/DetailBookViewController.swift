import UIKit
import SnapKit

class DetailBookViewController: UIViewController, sendDataDelegate {
    lazy var sendingIsbn : String = ""
    let viewModel =  ViewModel()
    lazy var safetyArea:UIView = {
        let view  =  UIView()
        return view
    }()
    lazy var bookImg : UIView =  {
        let view  =  UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    lazy var bookInfo :UIView = {
        let view  =  UIView()
        return view
    }()
    lazy var thumbnail:UIImageView =  {
        let imageView =  UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var mainTitle:UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    lazy var subTitle:UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    lazy var isbn13:UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    lazy var price:UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    lazy var url:UILabel = {
        let label =  UILabel()
        label.textColor = .tintColor
        return label
    }()
    lazy var line : UIView = {
        let view  =  UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    lazy var textView:UITextView = {
        let textView = UITextView()
        let borderColor:UIColor = .systemGray3
        textView.backgroundColor = .white
        textView.text = "메모를 입력해주세요"
        textView.textColor = .systemGray3
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 5.0
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        self.view.backgroundColor = .white
        self.title = "Detail Book"
        getData()
        setView()
    }
    // delegate 패턴 데이터 전달
    func sendData(response: String) {
        sendingIsbn = response
    }
    
    func getData(){
        lazy var query:String = "books/\(sendingIsbn)"
        ViewModel().loadData(query: "\(query)", returnType: DetailBook.self) { item in
            self.setUpValue(item)
        }
    }
    
    func setUpValue( _ book :DetailBook){
        mainTitle.text = book.title
        subTitle.text = book.subtitle
        price.text = book.price
        isbn13.text = book.isbn13
        url.text = book.url
        viewModel.showThumbnail(book.image) { data in
            self.thumbnail.image = UIImage(data: data)
        }
    }
    
    func setView(){
        view.addSubview(safetyArea)
        safetyArea.snp.makeConstraints {
            $0.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        safetyArea.addSubview(bookImg)
        bookImg.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(1.25/3.0)
        }
        bookImg.addSubview(thumbnail)
        thumbnail.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.center.equalToSuperview()
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
        }
        
        bookInfo.addSubview(isbn13)
        isbn13.snp.makeConstraints {
            $0.top.equalTo(subTitle.snp.bottom).offset(5)
        }
        
        bookInfo.addSubview(price)
        price.snp.makeConstraints {
            $0.top.equalTo(isbn13.snp.bottom).offset(5)
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
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension DetailBookViewController: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("placeholder 사라지는 시점")
        textView.text = ""
        return true
    }
}
