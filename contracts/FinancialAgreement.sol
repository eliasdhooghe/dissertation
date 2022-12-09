pragma solidity >=0.4.22 <0.9.0;

contract FinancialAgreementContract {
    address public importerID;
    address public exporterID;
    address public importerBankID;
    address public exporterBankID;
    string public product;
    uint256 public quantity;
    uint256 public price;
    uint256 public deliveryTimeline;
    string public deliveryTerms="deliveryTerms";


    constructor(uint256  _senderID,uint256  _beneficiaryID,uint256  _FX_rate,uint256  _transferamount) public {
        senderID = _senderID;
        beneficiaryID = _beneficiaryID;
        FX_rate = _FX_rate;
        transferamount = _transferamount;
    }

    function getTransferAmountBasedOnExchangeRate() public view returns(uint256){
        return transferamount * FX_rate;
    }
}