import UIKit
import SnapKit
import Then

class SearchTableViewCell: UITableViewCell {
    lazy var bookInfo = UIView()
    lazy var bookImg = UIView()
    lazy var thumbnail = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    lazy  var mainTitle = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    lazy var subTitle = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    lazy var isbn13  = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    lazy var price = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    lazy var url = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .tintColor
    }
    deinit{
        print("SearchBook Cell 풀렸습니다")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(){
        contentView.addSubview(bookImg)
        contentView.addSubview(bookInfo)
        bookImg.snp.makeConstraints {
            $0.directionalVerticalEdges.leading.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.95 / 3.0)
            $0.trailing.equalTo(bookInfo.snp.leading)
        }
        bookImg.addSubview(thumbnail)
        thumbnail.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
        
        bookInfo.snp.makeConstraints {
            $0.directionalVerticalEdges.trailing.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(2.05 / 3.0)
            $0.leading.equalTo(bookImg.snp.trailing)
        }
        
        bookInfo.addSubview(mainTitle)
        mainTitle.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(20)
        }
        
        bookInfo.addSubview(subTitle)
        subTitle.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
            $0.top.equalTo(mainTitle.snp.bottom).offset(5)
        }
        
        bookInfo.addSubview(isbn13)
        isbn13.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
            $0.top.equalTo(mainTitle.snp.bottom).offset(30)
        }
        
        bookInfo.addSubview(price)
        price.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
            $0.top.equalTo(isbn13.snp.bottom).offset(5)
        }
        
        bookInfo.addSubview(url)
        url.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
            $0.top.equalTo(price.snp.bottom).offset(5)
        }
    }
    
    func setUpValue(_ item : Books){
        mainTitle.text =  item.title
        subTitle.text =  item.subtitle
        isbn13.text = item.isbn13
        price.text = "\(item.price.calculateToDaller()) 원"
        url.text =  item.url
        ViewModel().showThumbnail(item.image){ [weak self] item in
            guard let self  =  self else { return }
            self.thumbnail.image =  UIImage(data: item)
        }
    }
}

