pragma solidity >=0.4.22 <0.9.0;

contract GlobalPaymentContract {
    address public senderID;
    address public beneficiaryID;
    address public senderBankID;
    address public beneficiaryBankID;
    uint256 public FX_rate;
    uint256 public transferamount;
    string public payout_conditions = "conditions";
    bool internal payerHasPaid = false;
    bool internal beneficiaryHasReceived = false;
    event print(address);
    event senderPaid(bool);
    event beneficiaryReceived(bool);

    constructor(
        address _senderID,
        address _senderBankID,
        address _beneficiaryBankID,
        address _beneficiaryID,
        uint256 _FX_rate,
        uint256 _transferamount
    ) {
        senderID = _senderID;
        senderBankID = _senderBankID;
        beneficiaryID = _beneficiaryID;
        beneficiaryBankID = _beneficiaryBankID;
        FX_rate = _FX_rate;
        transferamount = _transferamount;
    }

    function getTransferAmountBasedOnExchangeRate() public view returns (uint256) {
        return transferamount * FX_rate;
    }

    function submitTransfer() public {
        //emit print(msg.sender);
        //require(msg.sender == senderBankID,"No permission to submit the transfer");
        payerHasPaid = true;
        emit senderPaid(true);
    }

    function getAddress() public view returns (address) {
        return address(this);
    }

    function checkPayerHadPaid() public view returns (bool) {
        return payerHasPaid;
    }

    function checkBeneficiaryHasReceived() public view returns (bool) {
        return beneficiaryHasReceived;
    }

    function receiveFunds() public {
        beneficiaryHasReceived = true;
        emit beneficiaryReceived(true);
    }
}
