pragma solidity >=0.4.22 <0.9.0;

contract GlobalPaymentContract {
    address public senderID;
    address public beneficiaryID;
    address public senderBankID;
    address public beneficiaryBankID;
    uint256 public FX_rate;
    uint256 public transferamount;
    string public payout_conditions = "No conditions";
    bool internal payerHasPaid = false;
    bool internal beneficiaryHasReceived = false;
    event print(address);
    event senderPaid(bool);
    event beneficiaryReceived(bool);

    /**
    * @dev This constructor is used to initiate a global payment smart contract.
    * @param _senderID Address of the Sender
    * @param _senderBankID Address of the Bank of the Sender
    * @param _beneficiaryBankID Address of the Bank of the Beneficiary
    * @param _beneficiaryID Address of the Beneficiary
    * @param _FX_rate Exchange rate between the different currencies
    * @param _transferamount The transferamount of the global payment
    */
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
     /**
    * @dev This function calculates new transferamount based on the exchange rate.
    * @return newtransferamount New transferamount
    */
    function getTransferAmountBasedOnExchangeRate() public view returns (uint256 newtransferamount) {
        return transferamount * FX_rate;
    }
    /**
    * @dev This functions indicates that the transfer has been submitted. Set boolean payerHasPaid and emit event senderPaid.
    */
    function submitTransfer() public {
        //emit print(msg.sender);
        //require(msg.sender == senderBankID,"No permission to submit the transfer");
        payerHasPaid = true;
        emit senderPaid(true);
    }
    /**
    * @dev This functions returns the address of the GlobalPaymentContract
    * @return addressGlobalPaymentContract Address of the GlobalPaymentContract
    */
    function getAddress() public view returns (address addressGlobalPaymentContract) {
        return address(this);
    }
    /**
    * @dev This functions checks if the sender has submitted the transfer.
    * @return checkIfPayerHasPaid Boolean indicating if payer has paid.
    */
    function checkPayerHadPaid() public view returns (bool checkIfPayerHasPaid) {
        return payerHasPaid;
    }
/**
    * @dev This functions checks if the beneficiary has received the funds.
    * @return checkIfBeneficiaryHasReceived Boolean indicating if beneficiary has received.
    */
    function checkBeneficiaryHasReceived() public view returns (bool checkIfBeneficiaryHasReceived) {
        return beneficiaryHasReceived;
    }
    /**
    * @dev This functions indicates that the funds have been received. Set boolean beneficiaryHasReceived and emit event beneficiaryReceived.
    */
    function receiveFunds() public {
        beneficiaryHasReceived = true;
        emit beneficiaryReceived(true);
    }
}
