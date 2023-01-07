// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.22 <0.9.0;

import "./GlobalPayment.sol";


contract ApplicationContract {
    
    struct Person {
        address account;
        string first_name;
        string last_name;
        bool KYC_status;
        uint balance;
    }
    struct Bank {
        address account;
        string name;
    }
    struct Regulator {
        address account;
        string name;
    }

    Person[] persons;
    Bank[] banks;
    Regulator[] regulators;
    
    event print(address);
    
    /**
    * @dev This constructor is used to initiate the actors needed to perform the two use-cases. Actors are linked with their addresses.
    */
    constructor()  {
        addPerson(0x6616a4f8d35A2Cbe3b4C0427C428BD3aF3ca52Fa,"Alice","Doe",true,1000);
        addPerson(0xCF305Bd0861b5727Fe08FEFdF8FE93871CC4ACC2,"Bob","Doe",true,1000);
        addBank(0x52C9fc3556EA3A18628F4D156604e733015064C2,"KBC");
        addBank(0x3C5389B061C808eEE0165866253097F02A39A3C8,"ING");
        addRegulator(0xc1C276483229CA36ee022e7823cDbCA1A99640E2,"Regulator");
    }
    
    function findPerson(address account) internal view returns(int index){
        uint length = persons.length;
        for(uint u = 0; u < length; u++){
            if(persons[u].account == account) return int(u);
        }
        return -1;
    } 

    function findBank(address account) internal view returns(int index){
        for(uint u = 0; u < banks.length; u++){
            if(banks[u].account == account) return int(u);
        }
        return -1;
    }

    function findRegulator(address account) internal view returns(int index){
        for(uint u = 0; u < regulators.length; u++){
            if(regulators[u].account == account) return int(u);
        }
        return -1;
    }
    /**
    * @dev This function adds a Person to the environment (list of persons)
    * @param account Address of the person
    * @param first_name First name of the person
    * @param last_name Last name of the person
    * @param KYCstatus Status of the KYC procedure of the person
    * @param balance Balance of the person
    */
    function addPerson(
    address account, 
    string memory first_name,
    string memory last_name,
    bool KYCstatus,
    uint balance 
    ) 
    public {
        require(findPerson(account) < 0, "Already exists");
        persons.push(
           Person({account: account, first_name: first_name,last_name: last_name, KYC_status: KYCstatus,balance: balance}));
    }
    /**
    * @dev This function adds a Bank to the environment (list of banks)
    * @param account Address of the bank
    * @param name Name of the bank
    */
    function addBank(
    address account, 
    string memory name
    ) 
    public {
        require(findBank(account) < 0, "Already exists");
        banks.push(
           Bank({account: account, name: name}));
    }
    /**
    * @dev This function adds a Regulator to the environment (list of regulators)
    * @param account Address of the regulator
    * @param name Name of the regulator
    */
    function addRegulator(
    address account, 
    string memory name
    ) 
    public {
        require(findRegulator(account) < 0, "Already exists");
        regulators.push(
           Regulator({account: account, name: name}));
    }
    /**
    * @dev This function gets the balance amount of a person
    * @param account Address of the person
    * @return balance Balance of the person
    */
    function getPersonBalance(address account) public view 
    returns (uint balance) {
        int index = findPerson(account);
        require(index >= 0, "This person doesn't exist");
        return persons[uint(index)].balance;
    }
    /**
    * @dev This function gets the name of a person
    * @param account Address of the person
    * @return name Name of the person
    */
    function getPersonName(address account) public view 
    returns (string memory name) {
        int index = findPerson(account);
        require(index >= 0, "This person doesn't exist");
        return persons[uint(index)].first_name;//,persons[uint(index)].last_name
    }
    /**
    * @dev This function changes the balance amount of a person
    * @param pay_receive Decides if the person is paying money (true) or receiving money (false)
    * @param account Address of the person
    * @param amount Amount of the balance change
    */
    function changeBalanceOfPerson(bool pay_receive,address account, uint amount) 
    public  {
        //require((amount > 0) && (amount <= total - allocated));
        int index = findPerson(account);
        require(index >= 0, "This person doesn't exist");
        if(pay_receive){//TRUE = person is paying money
            persons[uint(index)].balance -= amount;
        }else { //FALSE = person is receiving money
            persons[uint(index)].balance += amount;
        }   
    }
    /**
    * @dev This function changes the KYC status of a person
    * @param account Address of the person
    * @param status New KYC status of the person
    */
    function setKYCstatusperson(address account,bool status) public {
        int index = findPerson(account);
        require(index >= 0, "This person doesn't exist");
        persons[uint(index)].KYC_status = status;
    }
    /**
    * @dev This function checkes the KYC status of a person
    * @param account Address of the person
    */
    function checkKYCstatusPerson(address account) public view returns(bool KYC_status){
        int index = findPerson(account);
        require(index >= 0, "This person doesn't exist");
        return persons[uint(index)].KYC_status;
    }


    //Functionality for Global Payment process.
    event GlobalPaymentContractIsCreated(address);
    /**
    * @dev GLOBAL PAYMENT: This function initiates a GlobalPaymentContract
    * @param accountPersonSender Address of the sender (person)
    * @param accountBankSender Address of the sender (bank)
    * @param accountBankBeneficiary Address of the beneficiary (bank)
    * @param accountPersonBeneficiary Address of the beneficiary (person)
    * @param FX_rate Exchange rate between the two currencies
    * @param transferamount The transferamount of the global payment
    */
    function initiateGlobalPaymentContract(address accountPersonSender,address accountBankSender,address accountBankBeneficiary,address accountPersonBeneficiary,uint FX_rate, uint transferamount) public {
        require(msg.sender == accountBankSender,"No permission to initiate this GlobalPaymentContract");
        require(findBank(accountBankSender) >=0, "Bank of sender doesn't exist");
        require(findBank(accountBankBeneficiary) >=0, "Bank of beneficiary doesn't exist");
        require(findPerson(accountPersonSender) >=0,"Sender doesn't exist");
        require(findPerson(accountPersonBeneficiary) >=0,"Beneficiary doesn't exist");
        require(checkKYCstatusPerson(accountPersonSender) == true, "Sender isn't verified. KYC_status = false");
        require(checkKYCstatusPerson(accountPersonBeneficiary) == true, "Beneficiary isn't verified. KYC_status = false");
        GlobalPaymentContract globalPaymentContract = new GlobalPaymentContract(accountPersonSender,accountBankSender,accountBankBeneficiary,accountPersonBeneficiary,FX_rate,transferamount);
        emit GlobalPaymentContractIsCreated(globalPaymentContract.getAddress());  
    }
    /**
    * @dev GLOBAL PAYMENT: This function submits the transfer in the process of a global payment contract
    * @param globalPaymentContract Address of the GlobalPaymentContract
    */
    function submitTransfer(GlobalPaymentContract globalPaymentContract) public {
        require(msg.sender == globalPaymentContract.senderBankID(),"No permission to submit the transfer");
        require(globalPaymentContract.checkPayerHadPaid() == false,"Sender has already paid");
        require(globalPaymentContract.checkBeneficiaryHasReceived() == false,"Error in system. This is impossible.");
        changeBalanceOfPerson(true, globalPaymentContract.senderID(), globalPaymentContract.transferamount());
        globalPaymentContract.submitTransfer();
    }
    /**
    * @dev GLOBAL PAYMENT: This function receive the funds in the process of a global payment contract
    * @param globalPaymentContract Address of the GlobalPaymentContract
    */
    function receiveFunds(GlobalPaymentContract globalPaymentContract) public {
        require(msg.sender == globalPaymentContract.beneficiaryBankID(),"No permission to submit the transfer");
        require(globalPaymentContract.checkPayerHadPaid() == true,"Sender still needs to pay.");
        require(globalPaymentContract.checkBeneficiaryHasReceived() == false,"Beneficiary has already received");
        changeBalanceOfPerson(false,globalPaymentContract.beneficiaryID(),globalPaymentContract.getTransferAmountBasedOnExchangeRate());
        globalPaymentContract.receiveFunds();
    }
}
