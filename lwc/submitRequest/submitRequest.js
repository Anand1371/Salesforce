import { LightningElement, api, track } from 'lwc';
import LightningModal from 'lightning/modal';
import registerLead from '@salesforce/apex/submitRequestController.registerLead';
import registerCase from '@salesforce/apex/submitRequestController.registerCase';


export default class SubmitRequest extends LightningModal {
    
    @api content;
    @api isGuestUser;
    @api userId;

    @track firstName = ''; 
    @track lastName = '';
    @track email = null;
    @track companyName=null;
    @track comment=null;

    handleFirstNameChange(event)
    {
        this.firstName = event.target.value;
    }

    handleLastNameChange(event)
    {
        this.lastName = event.target.value;
    }

    handleEmailChange(event)
    {
        this.email = event.target.value;
    }

    handleCompanyNameChange(event)
    {
        this.comapnyName = event.target.value;
    }

    handleComment(event)
    {
        this.comment = event.target.value;
    }
        

    handleSubmitLead() {
        registerLead({firstname : this.firstName, lastname : this.lastName, email : this.email, companyname : this.companyName, comment : this.comment})
        .then((result) =>
        {
            console.log(result);
        })
        this.close('okay');
    }


    handleSubmitCase() {
        registerCase({comment : this.comment, Id : this.userId})
        .then((result1) =>
        {
            console.log(result1);
        })
        this.close('okay');
    }
}