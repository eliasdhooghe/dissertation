class  Bank {
    constructor(address,id,name){
        this.address = address;
        this.id = id;
        this.name = name;
    }

    changeBalanceOfPerson(paying, person, amount){
        if(paying){
            person.pay(amount)
        } else {
            person.receive(amount)
        }
    }

    requestTransfer(person) {
        return person.validateKYC()
    }
    

}