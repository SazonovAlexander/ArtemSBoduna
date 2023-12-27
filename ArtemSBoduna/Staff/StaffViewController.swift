import UIKit

final class StaffViewController: UIViewController {
    //MARK: - Private Properties
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 20
        textField.layer.masksToBounds = true
        textField.placeholder = "ФИО"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clipsToBounds = true
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Поиск", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.separatorColor = .black
        return tableView
    }()
    
    var cellDataSource: [StaffResponse] = []
    private let staffService = StaffService()
    private var currentPage = 0
    private let itemsPerPage = 20
    private var inLoad = false
    private var isEnd = false {
        didSet {
            if isEnd == false {
                currentPage = 0
                cellDataSource = []
                getStaff()
            }
        }
    }
    //MARK: - Override methods
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
}


//MARK: - Private Methods
private extension StaffViewController {
    
    func setupView() {
        view.backgroundColor = .darkGray
        setupTableView()
        addSubviews()
        activateConstraints()
        getStaff()
        addAction()
    }
    
    func addAction() {
        addButton.addTarget(self, action: #selector(Self.didTapAddButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(Self.searchWithFilter), for: .touchUpInside)
    }
    
    @objc
    func searchWithFilter() {
        isEnd = false
    }
    
    
    @objc
    func didTapAddButton() {
        let alert = UIAlertController(title: "Работник", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "ФИО"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Номер телефона"
        }
            let save = UIAlertAction(title: "Сохранить", style: .default) { [weak alert, weak self] _ in
                if let self,
                   let name = alert?.textFields?[0].text,
                   let phone = alert?.textFields?[1].text
                {
                    let staff = StaffRequest(fullName: name, phoneNumber: phone)
                    self.staffService.addStaff(Staff: staff, completion: { [weak self] result in
                        guard let self else { return }
                        switch result {
                        case .success( _):
                            isEnd = false
                        case .failure(let error):
                            print(error.localizedDescription)
                            let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default)
                            alert.addAction(alertAction)
                            self.present(alert, animated: true)
                        }
                    })
                }
            }
            alert.addAction(save)
            let cancel = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
    
    func getStaff() {
        inLoad.toggle()
        staffService.fetchAllStaff(page: currentPage, count: itemsPerPage, param: nameTextField.text ?? "", completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let staff):
                print(staff)
                if !staff.isEmpty {
                    currentPage += 1
                }
                else {
                    isEnd = true
                }
                self.cellDataSource.append(contentsOf: staff)
                inLoad.toggle()
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                inLoad.toggle()
                let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(alertAction)
                self.present(alert, animated: true)
            }
        })
    }
    
    func updateStaff(staff: StaffResponse){
        let alert = UIAlertController(title: "Работник", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "ФИО"
            textField.text = staff.fullName
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Номер телефона"
            textField.text = staff.phoneNumber
        }
        
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak alert, weak self] _ in
            if let self,
               let name = alert?.textFields?[0].text,
               let phone = alert?.textFields?[1].text
            {
                let newStaff = StaffRequest(fullName: name, phoneNumber: phone)
                self.staffService.updateStaff(StaffId: staff.id, Staff: newStaff, completion: { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success( _):
                        isEnd = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true)
                    }
                })
            }
        }
        alert.addAction(save)
        let delete = UIAlertAction(title: "Удалить", style: .default) { [weak self] _ in
            if let self
            {
                self.staffService.deleteStaff(StaffId: staff.id,  completion: { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success( _):
                        isEnd = false
                    case .failure(let error):
                        print(error.localizedDescription)
                        let alert = UIAlertController(title: "Что-то пошло не так(", message: error.localizedDescription, preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(alertAction)
                        self.present(alert, animated: true)
                    }
                })
            }
        }
        alert.addAction(delete)
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    
    func addSubviews(){
        view.addSubview(tableView)
        view.addSubview(addButton)
        view.addSubview(searchButton)
        view.addSubview(nameTextField)
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            addButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -20),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 44),
            searchButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            searchButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalTo: searchButton.widthAnchor, multiplier: 1),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            tableView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
    }
    
    func registerCell() {
        tableView.register(StaffViewCell.self, forCellReuseIdentifier: StaffViewCell.reuseIdentifier)
    }
    
}


//MARK: - UITableViewDelegate
extension StaffViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateStaff(staff: cellDataSource[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height && !inLoad && !isEnd{
            
            getStaff()
        }
    }
    
}

//MARK: - UITableViewDataSource
extension StaffViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StaffViewCell.reuseIdentifier, for: indexPath) as? StaffViewCell else { return UITableViewCell() }
            let staff = cellDataSource[indexPath.row]
        cell.setupCell(staff: staff)
        return cell
    }
    
}

