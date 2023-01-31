import { LightningElement, api, wire } from 'lwc';
import Id from '@salesforce/user/Id';

import getBillingAddressByContactId from '@salesforce/apex/B2B_AddressSelectorFlowController.getBillingAddressByContactId';
import updateBillingDefault from '@salesforce/apex/B2B_AddressSelectorFlowController.updateBillingDefault';
import userData from '@salesforce/apex/B2B_AddressSelectorFlowController.userData';
import saveToCart from '@salesforce/apex/B2B_AddressSelectorFlowController.saveToCart';

export default class B2BBillToAddress extends LightningElement {

    
    userId = Id;
    addressList;
    
    allAddressList = new Map();
    defaultAddress = {
        billToAddress : '',
        billToAccountName : '',
        billToContactName : ''
    };
    selectedAddr = {};
    options = [];
    isShowModal = false;

    


    @api BillingContactPointAddressId;
    @api contactPointAddLst;
    @api cartId;
    @api userAccountId;
    

   

    getBillingAddresses()
    {
        getBillingAddressByContactId({cartId:this.cartId})
        .then(result =>{
            if(result!=null)
            {
                console.log(result);
                let addMap = new Map();
                var address = '';
                for (let i=0;i<result.length;i++)
                {
                    address = result[i].Street + "," + result[i].City + "," + result[i].State + "," + result[i].PostalCode + "," + result[i].Country;
                    addMap.set(result[i].Id, address);
                    this.options.push({ label: address, value: result[i].Id });
                    if(result[i].AddressType == 'Billing' && result[i].IsDefault == true)
                    {
                        this.BillingContactPointAddressId = result[i].Id;
                        this.defaultAddress.billToAddress = address;
                        saveToCart({addressId : result[i].Id, cartId : this.cartId})
                    } 
                }
                this.allAddressList = addMap;
                this.selectedAddr = this.defaultAddress;
            }
        })
        .catch(error =>{
            console.log('** error' + JSON.stringify(error));
        });
    }


    getUserInfo()
    {
        userData({userId : this.userId})
        .then(result=>{
            if(result)
            {
                this.defaultAddress.billToAccountName = result[0].Contact.Account.Name;
                this.defaultAddress.billToContactName = result[0].Contact.Name;        
            }
        })
        .catch(error=>{
            console.log('** error' + JSON.stringify(error));
        });
    }

    connectedCallback()
    {
        this.getUserInfo();
        this.getBillingAddresses();
    }

    getSelectedValue(event)
    {
        this.BillingContactPointAddressId = event.detail.value;
        console.log(this.BillingContactPointAddressId);
    }

    
    
    //Open Modal Handler
    hangleChangeAddress()
    {
        this.isShowModal = true;
    }

    //Close Modal Handler
    closeModal() {
        this.isShowModal = false;
    }

    //Close Modal Handler
    saveCart()
    {
        if(this.BillingContactPointAddressId != null)
        {
            this.selectedAddr.billToAddress = this.allAddressList.get(this.BillingContactPointAddressId);

            saveToCart({addressId : this.BillingContactPointAddressId, cartId : this.cartId})
            .then(result=>{
                console.log(result);
            });
            
            updateBillingDefault({addId : this.BillingContactPointAddressId})
            .then(result=>{
                console.log(result);
            });
            console.log(this.selectedAddr.billToAddress);
            this.isShowModal = false;
        }
        else{
            console.log('selected Id is null')
            this.isShowModal = false;
        }
    }


}