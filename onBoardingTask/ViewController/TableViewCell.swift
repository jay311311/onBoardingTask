import UIKit
import Then

class TableViewCell: UITableViewCell {
    let viewModel =  ViewModel()
    override init(style :UITableViewCell.CellStyle , reuseIdentifier : String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var newBookList = UIView().then {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    lazy var bookImg = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    lazy var bookInfo = UIView().then {
        $0.backgroundColor = .systemGray3
    }
    lazy var thumbnail = UIImageView().then  {
        $0.contentMode = .scaleAspectFit
    }
    lazy var mainTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        $0.textAlignment = .center
    }
    lazy var subTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.textAlignment = .center
    }
    lazy var isbn13 = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.textAlignment = .center
    }
    lazy var price = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textAlignment = .center
    }
    
    func setUpValue( _ book :Books){
        mainTitle.text = book.title
        subTitle.text = book.subtitle
        price.text = book.price
        isbn13.text = book.isbn13
        viewModel.showThumbnail(book.image) { data in
            self.thumbnail.image = UIImage(data: data)
        }
    }
    
    func setView(){
        contentView.addSubview(newBookList)
        newBookList.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.directionalVerticalEdges.equalToSuperview().inset(8)
            $0.center.equalToSuperview()
        }
        
        newBookList.addSubview(bookImg)
        bookImg.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(2.0/3.0)
        }
        
        newBookList.addSubview(bookInfo)
        bookInfo.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(1.0/3.0)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        
        bookImg.addSubview(thumbnail)
        thumbnail.snp.makeConstraints {
            $0.height.equalTo(190)
            $0.center.equalToSuperview()
        }
        
        bookInfo.addSubview(mainTitle)
        mainTitle.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
            $0.top.equalToSuperview().offset(5)
        }
        
        bookInfo.addSubview(subTitle)
        subTitle.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalTo(mainTitle.snp.bottom).offset(3)
        }
        
        bookInfo.addSubview(isbn13)
        isbn13.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalTo(mainTitle.snp.bottom).offset(25)
        }
        
        bookInfo.addSubview(price)
        price.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.top.equalTo(isbn13.snp.bottom).offset(5)
        }
    }
}
