import UIKit

class SearchTableViewCell: UITableViewCell {
    let viewModel = ViewModel()
    lazy var searchList :UIView  = {
        let view  =  UIView()
        return view
    }()
    lazy var bookInfo: UIView = {
        let view =  UIView()
        return view
    }()
    lazy var bookImg:UIView = {
        let view =  UIView()
        return view
    }()
    lazy var thumbnail: UIImageView = {
        let image =  UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
   lazy  var title : UILabel = {
        let label  =  UILabel()
         label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    lazy var subTitle : UILabel = {
        let label  =  UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        return label
    }()
    lazy var isbn13 : UILabel = {
        let label  =  UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        return label
    }()
    lazy var price : UILabel = {
        let label  =  UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)

        return label
    }()
    lazy var url : UILabel = {
        let label  =  UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .tintColor
        return label
    }()
    
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
        
        bookInfo.addSubview(title)
        title.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
            $0.top.equalToSuperview().inset(20)
        }
        
        bookInfo.addSubview(subTitle)
        subTitle.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
            $0.top.equalTo(title.snp.bottom).offset(5)
        }
        
        bookInfo.addSubview(isbn13)
        isbn13.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
            $0.top.equalTo(title.snp.bottom).offset(30)
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
    
    func setValue(_ item : DetailBook){
        title.text =  item.title
        subTitle.text =  item.subtitle
        isbn13.text = item.isbn13
        price.text = item.price
        url.text =  item.url
        viewModel.showThumbnail(item.image){ data in
            self.thumbnail.image =  UIImage(data: data)
        }
    }
}

