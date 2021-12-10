// SPDX-License-Identifier: MIT

//La licencia indica que se puede usar mi codigo

pragma solidity ^0.6.6;

contract Simple_Wallet {
    //Vamos a crear una wallet dueña que permita a la gente retirar y que añada balance a la cartera
    address owner;
    //Balance del contrato
    uint256 Balance_Received;
    uint256 Total_Employee = 10; //Cantidad de ETH*10
    //Objeto Employee
    Employee employee;
    uint256 Total_Children = 1; //Cantidad de ETH*10
    //Objeto Children
    Children children;
    uint256 employee_time = 1638313200; // 00:00 UTC+1 1 de Diciembre 2021
    uint256 children_time = 1638313200; // 00:00 UTC+1 1 de Diciembre 2021

    //Vamos a crear un enum que represente el estado de cobro. Esto lo usaremos para que. el dueño del contrato
    // pueda bloquear los fondos cuando quiera
    enum Charge_State {
        Open,
        Closed
    }

    Charge_State internal charge_state;

    //definimos al principio el dueño del contrato
    constructor() public {
        owner = msg.sender;
        charge_state = Charge_State.Open;
    }

    //Un modificador para que solo el dueño pueda realizar determinadas acciones
    modifier OnlyOwner() {
        require(msg.sender == owner, "No eres el dueño!");
        _;
    }

    //Un modificador para que solo los empleados puedan realizar determinadas acciones
    modifier OnlyEmployees() {
        require(msg.sender == employee.employee_address, "No eres empleado!");
        _;
    }

    //Un modificador para que solo los chavales puedan realizar determinadas acciones
    modifier OnlyChildrens() {
        require(msg.sender == children.children_address, "No eres un chaval!");
        _;
    }

    //Definimos la estructura empleado
    struct Employee {
        string first_name;
        string last_name;
        address payable employee_address;
    }

    //Definimos la estructura chaval
    struct Children {
        string first_name;
        address payable children_address;
    }

    //Añadimos balance al contrato
    function add_balance() public payable OnlyOwner {
        Balance_Received += msg.value;
    }

    //Vemos el balance disponible en el contrato
    function get_balance() public view returns (uint256) {
        return address(this).balance;
    }

    //pasamos a wei los eth (tengo que poner medidas mas comodas)
    function eth_to_wei(uint256 _wei) internal pure returns (uint256) {
        uint256 eth = _wei * 10**17;
        return (eth);
    }

    //Añadimos empleados
    function add_employee(
        string memory _firstname,
        string memory _lastname,
        address payable _employee_address
    ) public OnlyOwner {
        employee = Employee(_firstname, _lastname, _employee_address);
    }

    //Añadimos chaval
    function add_children(
        string memory _firstname,
        address payable _children_address
    ) public OnlyOwner {
        children = Children(_firstname, _children_address);
    }

    //Bloqueamos los pagos
    function block_payments() public OnlyOwner {
        charge_state = Charge_State.Closed;
    }

    //Abrimos los pagos
    function open_payments() public OnlyOwner {
        charge_state = Charge_State.Open;
    }

    //Asignamos la cantidad que vamos a transferir a los empleados
    function amount_balance_employees(uint256 _total) public OnlyOwner {
        Total_Employee = _total;
    }

    //Asignamos la cantidad que vamos a transferir a los chavales
    function amount_balance_childrens(uint256 _total) public OnlyOwner {
        Total_Children = _total;
    }

    //Funcion para que los empleados puedan sacar dinero
    function withdraw_balance_employees() public payable OnlyEmployees {
        require(
            charge_state == Charge_State.Open,
            "Los pagos han sido restringidos!"
        );
        require(
            employee_time <= block.timestamp,
            "Espera al mes siguiente para cobrar!"
        );
        employee_time += 2635200;
        uint256 Balance_employee = eth_to_wei(Total_Employee);
        require(
            Balance_employee <= address(this).balance,
            "No hay suficiente saldo en el contrato!"
        );
        Balance_Received -= Balance_employee;
        employee.employee_address.transfer(Balance_employee);
    }

    //Funcion para que los chavales puedan sacar dinero
    function withdraw_balance_children() public payable OnlyChildrens {
        require(
            charge_state == Charge_State.Open,
            "Los pagos han sido restringidos!"
        );
        require(
            children_time <= block.timestamp,
            "Espera a la semana siguiente para cobrar!"
        );
        children_time += 604800;
        uint256 Balance_children = eth_to_wei(Total_Children);
        require(
            Balance_children <= address(this).balance,
            "No hay suficiente saldo en el contrato!"
        );
        Balance_Received -= Balance_children;
        children.children_address.transfer(Balance_children);
    }

    /*Funcion para ver el tiempo en segundos
    function time () public view returns (uint256){
        return (block.timestamp);
    }*/
}
