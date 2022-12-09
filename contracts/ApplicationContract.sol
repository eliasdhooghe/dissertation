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
    Person[] persons;
    Bank[] banks;
    //GlobalPaymentContract[] contracts;

    constructor() public {
        addPerson(0x6616a4f8d35A2Cbe3b4C0427C428BD3aF3ca52Fa,"Elias","DHooghe",true,1000);
        addPerson(0xCF305Bd0861b5727Fe08FEFdF8FE93871CC4ACC2,"Xan","Maes",true,1000);
        addBank(0x52C9fc3556EA3A18628F4D156604e733015064C2,"KBC");
        addBank(0x3C5389B061C808eEE0165866253097F02A39A3C8,"ING");
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
    function addBank(
    address account, 
    string memory name
    ) 
    public {
        require(findBank(account) < 0, "Already exists");
        banks.push(
           Bank({account: account, name: name}));
    }
    function getPersonBalance(address account) public view 
    returns (uint) {
        int index = findPerson(account);
        require(index >= 0, "This person doesn't exist");
        return persons[uint(index)].balance;
    }
    function getPersonName(address account) public view 
    returns (string memory) {
        int index = findPerson(account);
        require(index >= 0, "This person doesn't exist");
        return persons[uint(index)].first_name;//,persons[uint(index)].last_name
    }

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
    event GlobalPaymentContractIsCreated(address);

    function initiateGlobalPaymentContract(address accountPersonSender,address accountBankSender,address accountBankBeneficiary,address accountPersonBeneficiary,uint FX_rate, uint transferamount) public {
        require(findBank(accountBankSender) >=0, "Bank of sender doesn't exist");
        require(findBank(accountBankBeneficiary) >=0, "Bank of beneficiary doesn't exist");
        require(findPerson(accountPersonSender) >=0,"Sender doesn't exist");
        require(findPerson(accountPersonBeneficiary) >=0,"Beneficiary doesn't exist");
        GlobalPaymentContract globalPaymentContract = new GlobalPaymentContract(accountPersonSender,accountBankSender,accountBankBeneficiary,accountPersonBeneficiary,FX_rate,transferamount);
        emit GlobalPaymentContractIsCreated(globalPaymentContract.getAddress());
        //return globalPaymentContract.getAddress();
        
        //Mapping nodig :> address , objectGPContract    
    }

    function submitTransfer(GlobalPaymentContract globalPaymentContract,address accountPersonSender) public {
        //Paying the value
        require(globalPaymentContract.checkPayerHadPaid() == false,"Sender has already paid");
        changeBalanceOfPerson(true, accountPersonSender, globalPaymentContract.transferamount());
        globalPaymentContract.submitTransfer();
    }
    function receiveFunds(GlobalPaymentContract globalPaymentContract,address accountPersonBeneficiary) public {
        require(globalPaymentContract.checkBeneficiaryHasReceived() == false,"Beneficiary has already received");
        changeBalanceOfPerson(false,accountPersonBeneficiary,globalPaymentContract.getTransferAmountBasedOnExchangeRate());
        globalPaymentContract.receiveFunds();
    }
    //TradeFinance functionality
    function initiateFinancialAgreement() public {
        //Create instance Financial agreement
    }
    function reviewFinancialAgreement() public {
        //Create letter of credit and share it with the export bank.
    }
    function reviewLetterOfCredit() public {
        //review by the export bank + initiateShipment
    }
    function signLetterOfCredit() public {
        //exporter signs the letter of credit to initiate shipment
    }
    function receiveShipment() public {
        //emit ShipmentReceived
    }
    function initiatePayment() public {
        //pay for goods after receiving the goods. Automatic?
    }
    





    

}
