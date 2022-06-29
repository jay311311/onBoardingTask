import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let safetyArea =  UIView()
    let newTiTle =  UILabel()
    let newBooks =  UITableView()
    var resultNewBook:[NewBook] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setUpUI()
        self.view.backgroundColor = .white
        newBooks.dataSource = self
        newBooks.delegate = self
    }
    
    func setUpUI(){
        setSafeAreaZon()
        setAttribute()
        setView()
        setContraint()
    }
    
    //urlSession
    func loadData(){
        let baseUrl  =  URL(string: "https://api.itbook.store/1.0/")
        let newComponent = URL(string: "new", relativeTo: baseUrl)!
        let config  =  URLSessionConfiguration.default
        let session  =  URLSession(configuration: config)
        
        let newUrl  = newComponent.absoluteURL
        let dataTask = session.dataTask(with: newUrl) { (data, res, err) in
            guard err == nil else { return }
            guard let statusCode = (res as? HTTPURLResponse)?.statusCode else {return}
            let statusRange = 200..<300
            if statusRange.contains(statusCode) {
                guard let data = data else { return }
                do {
                    let decoder  =  JSONDecoder()
                    let result = try decoder.decode(NewBook.self, from: data)
                    self.resultNewBook.append(result)
                    DispatchQueue.main.async {
                        self.newBooks.reloadData()
                    }
                }catch let error {
                    print("\(error.localizedDescription)")
                }
            }
        }
        dataTask.resume()
    }
    
    // 속성
    func setAttribute(){
        newTiTle.text  = "New Title"
        newTiTle.font =  UIFont.systemFont(ofSize: CGFloat(30), weight: .bold)
        newBooks.separatorStyle = .none
    }
    
    // 뷰의 구성
    func setView(){
        safetyArea.addSubview(newTiTle)
        safetyArea.addSubview(newBooks)
    }
    
    // 구성요소 제약
    func setContraint(){
        newTiTle.snp.makeConstraints { make in
            make.leading.equalTo(safetyArea).offset(20)
            make.top.equalTo(safetyArea).offset(40)
            make.trailing.equalToSuperview()
        }
        newBooks.snp.makeConstraints { make in
            make.top.equalTo(newTiTle.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // safeArea존 생성
    func setSafeAreaZon(){
        safetyArea.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safetyArea)
        
        let guide =  view.safeAreaLayoutGuide
        safetyArea.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        safetyArea.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        safetyArea.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        safetyArea.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
}


extension ViewController :  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultNewBook.first?.books.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        newBooks.register(NewBookCell.self, forCellReuseIdentifier: "newBook")
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "newBook", for: indexPath) as! NewBookCell
        
        if let result  =  resultNewBook.first?.books  {
            
            cell.selectionStyle = .none
            cell.contentView.addSubview(cell.newBookList)

            cell.setUpCellUI()
            cell.setUpValue(result[indexPath.item])
        }
        return cell
    }
}


class NewBookCell : UITableViewCell{
    let newBookList  =  UIView()
    let bookImg =  UIView()
    let bookInfo =  UIView()
    let thumbnail =  UIImageView()
    let mainTitle = UILabel()
    let subTitle = UILabel()
    let price = UILabel()
    let isbn13 = UILabel()
    
    func setUpCellUI() {
        setView()
        setContraint()
        setAttribute()
    }
    
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
    
    func setAttribute(){
        newBookList.layer.cornerRadius = 10
        newBookList.clipsToBounds = true
        bookImg.backgroundColor = .systemGray5
        bookInfo.backgroundColor = .systemGray3
        thumbnail.contentMode = .scaleAspectFit
        mainTitle.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        subTitle.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        isbn13.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        price.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        mainTitle.textAlignment = .center
        subTitle.textAlignment = .center
        isbn13.textAlignment = .center
        price.textAlignment = .center
    }
    
    func setView(){
        newBookList.addSubview(bookInfo)
        newBookList.addSubview(bookImg)
        bookImg.addSubview(thumbnail)
        bookInfo.addSubview(mainTitle)
        bookInfo.addSubview(subTitle)
        bookInfo.addSubview(isbn13)
        bookInfo.addSubview(price)
    }
    
    
    func setContraint(){
        newBookList.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 280))
            make.center.equalToSuperview()
        }
        thumbnail.snp.makeConstraints { make in
            make.height.equalTo(190)
            make.center.equalToSuperview()
        }
        bookImg.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(2.0/3.0)
        }
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
            make.top.equalTo(mainTitle.snp.bottom).offset(0)
        }
        isbn13.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainTitle.snp.bottom).offset(20)
        }
        price.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(isbn13.snp.bottom).offset(10)
        }
    }
}






