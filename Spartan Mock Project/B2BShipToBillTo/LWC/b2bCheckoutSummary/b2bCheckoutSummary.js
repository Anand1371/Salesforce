import { LightningElement, api } from 'lwc';
import getBillingAddressId from '@salesforce/apex/B2B_PaymentMethodController.getBillingAddressId';
export default class B2bCheckoutSummary extends LightningElement {

    @api cartId;
    summaryData = {};
    getBillingAddressId()
    {
        getBillingAddressId({cartId : this.cartId})
        .then(result=>{
            if(result)
            {
                this.summaryData = result;
            }
        })
        .catch(error=>{
            console.log('** error' + JSON.stringify(error));
        })
    }

    connectedCallback()
    {
        this.getBillingAddressId();
    }
}