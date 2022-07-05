import UIKit

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
    
    lazy var newBookList: UIView  =  {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    lazy var bookImg:UIView =  {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    lazy var bookInfo:UIView =  {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    lazy var thumbnail: UIImageView =  {
        let imageView =  UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var mainTitle: UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    lazy var subTitle:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var isbn13 : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
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
