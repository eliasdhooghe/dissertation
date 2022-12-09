const persons = [];
const banks = [];
const addresses = ['0x6616a4f8d35A2Cbe3b4C0427C428BD3aF3ca52Fa','0xCF305Bd0861b5727Fe08FEFdF8FE93871CC4ACC2','0x52C9fc3556EA3A18628F4D156604e733015064C2','0x3C5389B061C808eEE0165866253097F02A39A3C8']
const connection = new Web3.providers.HttpProvider("http://127.0.0.1:7545");
let contracts
App = {
    
    contracts: [],    
    load: async () => {
        //Connect to the blockchain
        await App.connectToBlockchain()
        //Get the ApplicationContract for data
        await App.requestApplicationContract()

        //await App.loadPersonsDummy()
        //await App.loadBanksDummy()
        //Load app
        
        //await App.loadAccounts()
        //await App.loadContract()
        //await App.render()
        //await App.renderPersons()
        //await App.renderBanks()
        console.log("App is loading")
    },
    requestApplicationContract: async ()=>{
            let applicationContractJSON = await $.getJSON('ApplicationContract.json')
            let applicationContract = await TruffleContract(applicationContractJSON)
            applicationContract.setProvider(connection);
            //Create SmartContract from BANK of payer.
            App.contracts.applicationContract = await applicationContract.deployed()//(personID_payer,personID_beneficiary,parseInt(2.05),100,{ from: '0xcd34ec771dd6a648432d5be0abea7de3122970dd' })
            console.log(App.contracts.applicationContract)
    },
    submitTransfer: async (personID_payer,bankID_payer) =>{
        banks[bankID_payer].changeBalanceOfPerson(true,persons[personID_payer],(await App.contracts.globalPaymentContract.transferamount()).toNumber())
        await App.renderPersons()
    },
    requestTransfer: async (personID_payer,bankID_payer,bankID_beneficiary, personID_beneficiary) => {
        
            if(banks[bankID_payer].requestTransfer(persons[personID_payer])){
            try {
            //Validated is good, now connect to blockchain to initiate a smart Contract
            let globalPaymentContractJSON = await $.getJSON('GlobalPaymentContract.json')
            let globalPaymentContract = await TruffleContract(globalPaymentContractJSON)
            globalPaymentContract.setProvider(connection);
            App.contracts.globalPaymentContract = await globalPaymentContract.new(personID_payer,personID_beneficiary,parseInt(2.05),100,{ from: '0xcd34ec771dd6a648432d5be0abea7de3122970dd' })
            
            console.log(App.contracts.globalPaymentContract)
            //When payer pays.changeBalance of payer
            //let transferamountContract = (await globalPaymentContract.transferamount()).toNumber()
            //banks[bankID_payer].changeBalanceOfPerson(true,persons[personID_payer],transferamountContract)
            //ChangeBalance of beneficiary with fiat currency
            //banks[bankID_beneficiary].changeBalanceOfPerson(false,persons[personID_beneficiary],(await App.contracts.globalPaymentContract.getTransferAmountBasedOnExchangeRate()).toNumber())
            } finally {
                    //GlobalPayment Smart Contract is finished; 
                    App.renderPersons()
            }
        } else {
            console.log("KYC is not validated. Request Transfer is denied")
        }  
    },
    loadPersonsDummy: async () => {
        for(let i = 0; i < 2; i++){
            persons[i] = new Person(addresses[i],i,'Elias','DHooghe',1000)
        }
        console.log(persons)
    },
    renderPersons: async () => {
        let personsList = document.getElementById("personsList")
        let items = "";
        for(let i = 0; i < persons.length; i++){
            items += `<li class="list-group-item"><div class="row">
            <div class="col-md-12">` + persons[i].first_name +" "+persons[i].last_name +`</div></div><div class="row"><div class="col-md-12">`+persons[i].address+`</div></div>
            <div class="row"><div class="col-md-12">`+persons[i].balance+`</div></div></li>`
        }
        personsList.innerHTML= items;
    },
    renderBanks: async () => {
        let banksList = document.getElementById("banksList")
        
        let items = "";
        for(let i = 0; i < 2; i++){
            items += `<li class="list-group-item">` + banks[i].name +" "+banks[i].id+" "+banks[i].address+`</li>`
        }
        banksList.innerHTML= items;
    },
    loadBanksDummy: async () => {
        for(let i = 0; i < 2; i++){
            banks[i] = new Bank(addresses[i+2],i,"KBC");
        }
        console.log(banks)
    },
    // https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8
    connectToBlockchain: async () => {
        window.addEventListener('load', async () => {
            // Modern dapp browsers...
            if (window.ethereum) {
                window.web3 = new Web3(ethereum);
                console.log("Loaded....")
                try {
                    // Request account access if needed
                    await ethereum.enable();
                    // Acccounts now exposed
                    web3.eth.sendTransaction({/* ... */});
                    console.log("Connected to the blockchain network")
                } catch (error) {
                    // User denied account access...
                }
                
            }
            // Legacy dapp browsers...
            else if (window.web3) {
                window.web3 = new Web3(web3.currentProvider);
                // Acccounts always exposed
                web3.eth.sendTransaction({/* ... */});
                console.log("Connected to the blockchain network")
            }
            // Non-dapp browsers...
            else {
                console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
            }
            });
  },
  loadAccounts: async () =>{
    App.account = await ethereum.request({method: 'eth_accounts'});
    console.log(App.account);
  },
  loadContract: async () => {
    let applicationContractJSON = await $.getJSON('ApplicationContract.json')
    let applicationContract = await TruffleContract(applicationContractJSON)
    applicationContract.setProvider(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
    applicationContract = await applicationContract.deployed()
    console.log(applicationContract)
    console.log((await applicationContract.createInstance({ from: '0xcd34ec771dd6a648432d5be0abea7de3122970dd' })).toNumber())
    let globalPaymentContractJSON = await $.getJSON('GlobalPaymentContract.json')
    let  globalPaymentContract = await TruffleContract(globalPaymentContractJSON)
    globalPaymentContract.setProvider(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
    globalPaymentContract = await globalPaymentContract.deployed()
    console.log(globalPaymentContract)
    console.log((await globalPaymentContract.senderID().toNumber()))
    console.log(await globalPaymentContract.newPerson({ from: '0xcd34ec771dd6a648432d5be0abea7de3122970dd' }))

    // applicationContract.setProvider(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
    // applicationContract = await applicationContract.deployed()
    // console.log(applicationContract)
    // const boolean_value = 
    // console.log(boolean_value)
    // App.applicationContract = await App.contracts.ApplicationContract.deployed()
    // const waarde = await App.applicationContract.createInstance()
    // console.log(waarde)
    // const GBContract = await $.getJSON('GlobalPaymentContract.json')
    // const GlobalPaymentContract = await TruffleContract(GBContract)
    // GlobalPaymentContract.setProvider(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));

    // const value = await App.contracts.ApplicationContract.createInstance()
    // App.contracts.GlobalPaymentContract = await App.contracts.GlobalPaymentContract.deployed()
    // console.log(value)
    // console.log(App.contracts.GlobalPaymentContract)
  },
  render: async () => {
    $('#account').html(App.account)
  }

}

$(() => {
    $(window).load(() => {
        App.load()
    })
})