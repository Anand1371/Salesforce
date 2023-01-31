import { LightningElement, api } from 'lwc';
import Id from '@salesforce/user/Id';
import getOrderIdByOrderSummaryId from '@salesforce/apex/B2B_AddressSelectorFlowController.getOrderIdByOrderSummaryId';
import userData from '@salesforce/apex/B2B_AddressSelectorFlowController.userData';
export default class B2bThanksConfirmation extends LightningElement {
    @api orderSummaryId;
    orderId;
    email;
    data;
    userId = Id;

    connectedCallback()
    {
        getOrderIdByOrderSummaryId({orderSummaryId : this.orderSummaryId})
        .then(result=>{
            this.data = 'Your order '+ result +' has successfully been placed and a confirmation email has been sent to the email address below';
            this.orderId = result;
        });

        userData({userId : this.userId})
        .then(result=>{
            console.log(result);
            if(result)
            {
                this.email = result[0].Email;    
            }
            
        });
        
    }
}