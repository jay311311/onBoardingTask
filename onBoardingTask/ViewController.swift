import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let safetyArea =  UIView()
    let newTiTle =  UILabel()
    let newBooks =  UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        newBooks.dataSource = self
        newBooks.delegate = self
        newBooks.register(NewBookCell.self, forCellReuseIdentifier: "newBook")
        //loadData()
    }
    
    func setUpUI(){
        setSafeAreaZon()
        setAttribute()
        setView()
        setContraint()
    }
    
//    func loadData(){
//        let urlString = ""
//        if let url  =  URL(string:urlString) {
//            let urlRequest =  URLRequest(url: url)
//            let session =  URLSession(configuration: .default)
//            print("데이터 로드할 예정 / \(urlString)")
//            session.dataTask(with: urlRequest) { data, res, err in
//                if let err = err {
//                    print("error :\(err.localizedDescription)")
//                    return
//                }
//                if let data = data {
//                    do {
//                        print("aaa")
//                        let decodeData =  try JSONDecoder().decode(NewBook.self, from: data)
//                        print("이건 되겠지\(decodeData)")
//                    }catch{
//                       "\(error.localizedDescription)"
//                    }
//                }
//                print("허허허")
//            }
//        }
//        print("하하하")
//    }
    
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "newBook", for: indexPath) as! NewBookCell
        
        // 데이터 받아서 할당해줄 부분
        cell.mainTitle.text = "제목"
        cell.subTitle.text = "소제목"
        cell.price.text = "가격"
        cell.isbn13.text = "isbn13"
        
        cell.selectionStyle = .none
        cell.contentView.addSubview(cell.newBookList)

        cell.newBookList.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 300, height: 280))
            make.center.equalToSuperview()
        }
       
        cell.setUpCellUI()
        
        return cell
    }
}


class NewBookCell : UITableViewCell{
    let newBookList  =  UIView()
    let bookImg =  UIView()
    let bookInfo =  UIView()
    var mainTitle = UILabel()
    let subTitle = UILabel()
    let price = UILabel()
    let isbn13 = UILabel()
    
    func setUpCellUI() {
        setView()
        setContraint()
        setAttribute()
    }
    
    func setAttribute(){
        newBookList.layer.cornerRadius = 10
        newBookList.clipsToBounds = true
        bookImg.backgroundColor = .systemGray5
        bookInfo.backgroundColor = .systemGray3
        mainTitle.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        subTitle.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
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
        bookInfo.addSubview(mainTitle)
        bookInfo.addSubview(subTitle)
        bookInfo.addSubview(isbn13)
        bookInfo.addSubview(price)
    }
    
    
    func setContraint(){
        bookImg.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(2.0/3.0)
        }
        bookInfo.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(1.0/3.0)
            make.leading.bottom.trailing.equalToSuperview()
        }
        mainTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(5)

        }
        subTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        isbn13.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(50)

        }
        price.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(65)
            
        }
    }
}





