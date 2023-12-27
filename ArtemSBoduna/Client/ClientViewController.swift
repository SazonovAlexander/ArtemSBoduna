import UIKit


final class ClientViewController: UIViewController {
    //MARK: - Private Properties
    private let addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить", for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.masksToBounds = true
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
        tableView.layer.borderColor = UIColor.black.cgColor
        tableView.layer.borderWidth = 3
        return tableView
    }()
    
    var cellDataSource: [ClientResponse] = []
    private let clientService = ClientService()
    private var selectedLivingRoom: LivingRoomResponse?
    private var currentPage = 0
    private let itemsPerPage = 20
    private var currentAlert: UIAlertController?
    private var inLoad = false
    private var isEnd = false {
        didSet {
            if isEnd == false {
                currentPage = 0
                cellDataSource = []
                getClient()
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
private extension ClientViewController {
    
    func setupView() {
        view.backgroundColor = .darkGray
        setupTableView()
        addSubviews()
        activateConstraints()
        getRoom()
        addAction()
    }
    
    func addAction() {
        addButton.addTarget(self, action: #selector(Self.didTapAddButton), for: .touchUpInside)
    }
    
    @objc
    func openSelect() {
        let vc = SelectLivingRoomViewController()
        vc.delegate = self
        
    }
    
    
    @objc
    func didTapAddButton() {
        let alert = UIAlertController(title: "Клиент", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "ФИО"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Номер телефона"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Адрес"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Комната"
        }
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak alert, weak self] _ in
            if let self,
               let price = Int(alert?.textFields?.last?.text ?? ""),
               let number = Int(alert?.textFields?.first?.text ?? "")
            {
                let room = LivingRoomRequest(number: number, price: price, status: false)
                self.roomService.addLivingRoom(livingRoom: room, completion: { [weak self] result in
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
        self.present(alert, animated: true)
    }
    
    func getRoom() {
        inLoad.toggle()
        let filter = selectedFilterType > 0 ? (selectedFilterType == 1 ? "true" : "false") : ""
        print(filter)
        roomService.fetchAllLivingRoom(page: currentPage, count: itemsPerPage, param: filter, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let rooms):
                if !rooms.isEmpty {
                    currentPage += 1
                }
                else {
                    isEnd = true
                }
                self.cellDataSource.append(contentsOf: rooms)
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
    
    func updateRoom(room: LivingRoomResponse) {
        let alert = UIAlertController(title: "Жилая комната", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Номер"
            textField.text = "\(room.number)"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Цена"
            textField.text = "\(room.price)"
        }
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak alert, weak self] _ in
            if let self,
               let price = Int(alert?.textFields?.last?.text ?? ""),
               let number = Int(alert?.textFields?.first?.text ?? "")
            {
                let newRoom = LivingRoomRequest(number: number, price: price, status: false)
                self.roomService.updateLivingRoom(livingRoomId: room.id ,livingRoom: newRoom, completion: { [weak self] result in
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
                self.roomService.deleteLivingRoom(livingRoomId: room.id, completion: { [weak self] result in
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
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addButton.heightAnchor.constraint(equalToConstant: 44),
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
        tableView.register(ClientViewCell.self, forCellReuseIdentifier: ClientViewCell.reuseIdentifier)
    }
    
}


//MARK: - UITableViewDelegate
extension ClientViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateRoom(room: cellDataSource[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height && !inLoad && !isEnd{
            getRoom()
        }
    }
    
}

//MARK: - UITableViewDataSource
extension ClientViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClientViewCell.reuseIdentifier, for: indexPath) as? ClientViewCell else { return UITableViewCell() }
            let client = cellDataSource[indexPath.row]
        cell.setupCell(client: client)
        return cell
    }
    
}


extension ClientViewController: SelectLivingRoomDelegate {
    
    func setLivingRoom(_ room: LivingRoomResponse) {
        selectedLivingRoom = room
        currentAlert?.textFields?.last?.text = "Номер: \(room.number)"
    }
    
}
