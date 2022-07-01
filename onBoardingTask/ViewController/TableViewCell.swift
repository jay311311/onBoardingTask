import UIKit

class TableViewCell: UITableViewCell {
    
    override init(style :UITableViewCell.CellStyle , reuseIdentifier : String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(newBookList)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let newBookList: UIView  =  {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    let bookImg:UIView =  {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    let bookInfo:UIView =  {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    let thumbnail: UIImageView =  {
        let imageView =  UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let mainTitle: UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    let subTitle:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let isbn13 : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    let price: UILabel = {
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
        showThumbnail(book.image)
    }
    
    func showThumbnail(_ imageUrl : String){
        let url =  URL(string: imageUrl)
        if let data = try? Data(contentsOf: url!){
            DispatchQueue.main.async {
                self.thumbnail.image = UIImage(data: data)
            }
        }
    }
    
    func setView(){
        newBookList.addSubview(bookImg)
        newBookList.addSubview(bookInfo)
        newBookList.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 280))
            make.center.equalToSuperview()
        }
        
        bookImg.addSubview(thumbnail)
        bookImg.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(2.0/3.0)
        }
        thumbnail.snp.makeConstraints { make in
            make.height.equalTo(190)
            make.center.equalToSuperview()
        }
        
        bookInfo.addSubview(mainTitle)
        bookInfo.addSubview(subTitle)
        bookInfo.addSubview(isbn13)
        bookInfo.addSubview(price)
        bookInfo.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(1.0/3.0)
            make.leading.bottom.trailing.equalToSuperview()
        }
        mainTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(5)
        }
        subTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainTitle.snp.bottom).offset(3)
        }
        isbn13.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainTitle.snp.bottom).offset(25)
        }
        price.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(isbn13.snp.bottom).offset(5)
        }
    }
    
    
}
