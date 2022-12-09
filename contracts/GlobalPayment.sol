pragma solidity >=0.4.22 <0.9.0;

contract GlobalPaymentContract {
    address public senderID;
    address public beneficiaryID;
    address public senderBankID;
    address public beneficiaryBankID;
    uint256 public FX_rate;
    uint256 public transferamount;
    string public payout_conditions="conditions";
    bool payerHasPaid= false;
    bool beneficiaryHasReceived = false; 
    
    event senderPaid(bool);
    event beneficiaryReceived(bool);

    constructor(
    address  _senderID,
    address  _senderBankID,
    address  _beneficiaryID,
    address _beneficiaryBankID,
    uint256  _FX_rate,
    uint256  _transferamount)
    public 
    {
        senderID = _senderID;
        senderBankID = _senderBankID;
        beneficiaryID = _beneficiaryID;
        beneficiaryBankID = _beneficiaryBankID;
        FX_rate = _FX_rate;
        transferamount = _transferamount;
    }

    function getTransferAmountBasedOnExchangeRate() public view returns(uint256){
        return transferamount * FX_rate;
    }
    function submitTransfer() public {
        payerHasPaid= true;
        emit senderPaid(true);
    }
    function getAddress() public view returns(address){
        return address(this);
    }
    function checkPayerHadPaid() public view returns(bool){
        return payerHasPaid;
    }   
    function checkBeneficiaryHasReceived() public view returns(bool){
        return beneficiaryHasReceived;
    }
    function receiveFunds() public {
        beneficiaryHasReceived= true;
        emit beneficiaryReceived(true);
    }




    


    


    // function getSenderID() public returns(uint) {
    //     return senderID;
    // }
    // function getBeneficiaryID() public returns(uint) {
    //     return beneficiaryID;
    // }
    // function getFX_rate() public returns(uint) {
    //     return FX_rate;
    // }
    // function getTransferamount() public returns(uint) {
    //     return transferamount;
    // }
    // function setSenderID(uint _senderID) public {
    //     senderID = _senderID;
    // }
    // function setBeneficiaryID(uint _beneficiaryID) public {
    //     beneficiaryID = _beneficiaryID;
    // }
    // function setFX_rate(uint _FX_rate) public {
    //     FX_rate = _FX_rate;
    // }
    // function setTransferamount(uint _transferamount) public {
    //     transferamount = _transferamount;
    // }

}



