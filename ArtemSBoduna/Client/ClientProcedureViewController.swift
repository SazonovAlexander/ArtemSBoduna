import UIKit


final class ClientProcedureViewController: UIViewController {
    //MARK: - Private Properties
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
    
    var cellDataSource: [ClientProcedureResponse] = []
    private let service = ClientProcedureService()
    private var selectedProcedure: ProcedureResponse?
    var client: ClientResponse?
    private var currentAlert: UIAlertController?
    private var inLoad = false
    private var isEnd = false {
        didSet {
            if isEnd == false {
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
private extension ClientProcedureViewController {
    
    func setupView() {
        view.backgroundColor = .darkGray
        setupTableView()
        addSubviews()
        activateConstraints()
        getClient()
        addAction()
    }
    
    func addAction() {
        addButton.addTarget(self, action: #selector(Self.didTapAddButton), for: .touchUpInside)
    }
    
   
    
    @objc
    func openSelect() {
        let vc = SelectProcedureViewController()
        vc.delegate = self
        currentAlert?.present(vc, animated: true)
    }
    
    
    @objc
    func didTapAddButton() {
        let alert = UIAlertController(title: "Клиент", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Количество"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Процедура"
            textField.addTarget(self, action: #selector(Self.openSelect), for: .editingDidBegin)
        }
        
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak alert, weak self] _ in
            if let self,
               let count = Int(alert?.textFields?.first?.text ?? "0"),
                let procedure = selectedProcedure
            {
                let cp = ClientProcedureRequest(clientId: client!.id, procedureId: procedure.id, count: count)
                self.service.addClientProcedure(client: cp, completion: { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success( _):
                        selectedProcedure = nil
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
        currentAlert = alert
        self.present(alert, animated: true)
    }
    
    func getClient() {
        inLoad.toggle()
        service.fetchProcedure(clientId: client!.id, completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let clients):
                self.cellDataSource = clients
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
    
    func updateCLient(cp: ClientProcedureResponse) {
        let alert = UIAlertController(title: "Клиент", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Количество"
            textField.text = "\(cp.count)"
        }
        let save = UIAlertAction(title: "Сохранить", style: .default) { [weak alert, weak self] _ in
            if let self,
               let count = Int(alert?.textFields?.first?.text ?? "0")
            {
                let newCp = ClientProcedureRequest(clientId: client!.id, procedureId: cp.procedure.id, count: count)
                self.service.updateClientProcedure(clientId: client!.id,procId: cp.procedure.id, client: newCp, completion: { [weak self] result in
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
                self.service.deleteClientProcedure(clientId: cp.client.id, procId: cp.procedure.id, completion: { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case .success( _):
                        selectedProcedure = nil
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
        currentAlert = alert
        self.present(alert, animated: true)
    }
    
    
    func addSubviews(){
        view.addSubview(tableView)
        view.addSubview(addButton)
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        tableView.register(ClientProcedureViewCell.self, forCellReuseIdentifier: ClientProcedureViewCell.reuseIdentifier)
    }
    
}


//MARK: - UITableViewDelegate
extension ClientProcedureViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateCLient(cp: cellDataSource[indexPath.row])
    }
    
}

//MARK: - UITableViewDataSource
extension ClientProcedureViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClientProcedureViewCell.reuseIdentifier, for: indexPath) as? ClientProcedureViewCell else { return UITableViewCell() }
            let cp = cellDataSource[indexPath.row]
        cell.setupCell(cp: cp)
        return cell
    }
    
}


extension ClientProcedureViewController: SelectProcedureDelegate {
    
    func selectProcedure(_ proc: ProcedureResponse) {
        selectedProcedure = proc
        currentAlert?.textFields?.last?.text = "\(proc.name)"
    }
    
}

