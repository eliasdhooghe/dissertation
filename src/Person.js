 class  Person {
    constructor(address,id,first_name,last_name,balance){
        this.address = address;
        this.id = id;
        this.first_name = first_name;
        this.last_name = last_name;
        this.KYC_status = true;
        this.balance = balance;
    }

    receive(amount){
        this.balance += amount;
    }
    
    pay(amount){
        this.balance-= amount;
    }

    validateKYC(){
        return this.KYC_status
    }

}


