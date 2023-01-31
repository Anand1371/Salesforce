import { LightningElement, api} from 'lwc';
import Id from '@salesforce/user/Id';
import getBillingAddressByContactId from '@salesforce/apex/B2B_AddressSelectorFlowController.getBillingAddressByContactId';
import getShippingAddressByContactId from '@salesforce/apex/B2B_AddressSelectorFlowController.getShippingAddressByContactId';
import userData from '@salesforce/apex/B2B_AddressSelectorFlowController.userData';
import getBillingAddressByOrderSummary from '@salesforce/apex/B2B_AddressSelectorFlowController.getBillingAddressByOrderSummary';
import getShippingAddressByOrderSummary from '@salesforce/apex/B2B_AddressSelectorFlowController.getShippingAddressByOrderSummary';
export default class B2BDisplayBillToAddress extends LightningElement {
    @api cartId;
    @api orderSummaryId;

    userId = Id;
    selectedBillingAddress = {};
    billingAddress = {
        billToAddress : '',
        billToName : ''
    };

    selectedShippingAddress = {};
    shippingAddress = {
        shipToAddress : '',
        shipToName : ''
    };

    selectedBuyerDetails = {};
    buyerDetails = {
        contactName : '',
        email : '',
        phone : ''
    };

    getShippingAddress()
    {
        getShippingAddressByContactId({cartId:this.cartId})
        .then(result =>{
            if(result!=null)
            {
                console.log(result);
                var address = '';
                for (let i=0;i<result.length;i++)
                {
                    address = result[i].Street + "," + result[i].City + "," + result[i].State + "," + result[i].PostalCode + "," + result[i].Country;
                    if(result[i].IsDefault == true)
                    {
                        this.shippingAddress.shipToAddress = address;
                        this.shippingAddress.shipToName = result[i].City;
                    } 
                }
                this.selectedShippingAddress = this.shippingAddress;
            }
        })
        .catch(error =>{
            console.log('** error' + JSON.stringify(error));
        })
    }

    getBillingAddress()
    {
        getBillingAddressByContactId({cartId : this.cartId})
        .then(result=>{
            if(result!=null)
            {
                var address = '';
                console.log(result);
                for(let i=0;i<result.length;i++)
                {
                    address = result[i].Street + ", " + result[i].City + ", " + result[i].State + ", " + result[i].PostalCode + ", " + result[i].Country;
                    if(result[i].IsDefault == true)
                    {
                        this.billingAddress.billToAddress = address;
                        this.billingAddress.billToName = result[i].Name;
                    }
                    this.selectedBillingAddress = this.billingAddress; 
                }
            }
        })
        .catch(error=>{
            console.log('** error' + JSON.stringify(error));
        });
    }

    

    getBillingAddressByOrderSummary()
    {
        getBillingAddressByOrderSummary({orderSummaryId : this.orderSummaryId})
        .then(result=>{
            if(result!=null)
            {
                var address = '';
                console.log(result);
                address = result[0].BillingStreet + ", " + result[0].BillingCity + ", " + result[0].BillingState + ", " + result[0].BillingPostalCode + ", " + result[0].BillingCountry;
                this.billingAddress.billToAddress = address;
                this.billingAddress.billToName = result[0].BillingCity;   
            }
            this.selectedBillingAddress = this.billingAddress;
            
        })
        .catch(error=>{
            console.log('** error' + JSON.stringify(error));
        });
    }


    getShippingAddressByOrderSummary()
    {
        getShippingAddressByOrderSummary({orderSummaryId : this.orderSummaryId})
        .then(result=>{
            if(result!=null)
            {
                var address = '';
                console.log(result);
                address = result[0].DeliverToStreet + ", " + result[0].DeliverToCity + ", " + result[0].DeliverToState + ", " + result[0].DeliverToPostalCode + ", " + result[0].DeliverToCountry;
                this.shippingAddress.shipToAddress = address;
                this.shippingAddress.shipToName = result[0].DeliverToCity;   
            }
            this.selectedShippingAddress = this.shippingAddress;
            
        })
        .catch(error=>{
            console.log('** error' + JSON.stringify(error));
        });
    }

    getUserInfo()
    {
        userData({userId : this.userId})
        .then(result=>{
            console.log(result);
            if(result)
            {
                this.buyerDetails.contactName = result[0].Contact.Name;
                this.buyerDetails.email = result[0].Email;
                this.buyerDetails.phone = result[0].Phone;     
            }
            this.selectedBuyerDetails = this.buyerDetails;
        })
        .catch(error=>{
            console.log('** error' + JSON.stringify(error));
        });
    }

    connectedCallback()
    {
        if(this.orderSummaryId!=null)
        {
            this.getShippingAddressByOrderSummary();
            this.getBillingAddressByOrderSummary();
            this.getUserInfo();
        }
        else{
            this.getBillingAddress();
            this.getShippingAddress();
            this.getUserInfo();
        }    
    }
}