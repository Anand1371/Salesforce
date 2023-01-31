import { LightningElement, api} from 'lwc';
import Id from '@salesforce/user/Id';

import b2BNewShippingAddress from 'c/b2BNewShippingAddress';
import getShippingAddressByContactId from '@salesforce/apex/B2B_AddressSelectorFlowController.getShippingAddressByContactId';
import userData from '@salesforce/apex/B2B_AddressSelectorFlowController.userData';


export default class B2BShipToAddress extends LightningElement {

    

    async handleNewShippingAddress()
    {
        const result = await b2BNewShippingAddress.open({
            cartId : this.cartId
        });
        console.log(result);
    }

 
    userId = Id;
    addressList;
    allAddressList = new Map();
    defaultAddress = {
        shipToAddress : '',
        shipToAccountName : '',
        shipToContactName : ''
    };
    selectedAddr = {};
    options = [];
    isShowModal = false;

    


    @api selectedShippingAddressId;
    @api cartId;
    @api shippingInstructions;
    
    

   

    getShippingAddresses()
    {
        getShippingAddressByContactId({cartId:this.cartId})
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
                    if(result[i].AddressType == 'Shipping' && result[i].IsDefault == true)
                    {
                        this.selectedShippingAddressId = result[i].Id;
                        this.defaultAddress.shipToAddress = address;
                    } 
                }
                this.allAddressList = addMap;
                this.selectedAddr = this.defaultAddress;
            }
        })
        .catch(error =>{
            console.log('** error' + JSON.stringify(error));
        })
    }


    getUserInfo()
    {
        userData({userId : this.userId})
        .then(result=>{
            if(result)
            {
                this.defaultAddress.shipToAccountName = result[0].Contact.Account.Name;
                this.defaultAddress.shipToContactName = result[0].Contact.Name;        
            }
        })
        .catch(error=>{
            console.log('** error' + JSON.stringify(error));
        });
    }

    connectedCallback()
    {
        this.template.addEventListener('refresh', this.getShippingAddresses.bind(this));
        this.getUserInfo();
        this.getShippingAddresses();
    }


    getSelectedValue(event)
    {
        this.selectedShippingAddressId = event.detail.value;
        console.log(this.selectedShippingAddressId);
    }

    deliveryInstructionsHandler(event)
    {
        this.shippingInstructions = event.detail.value;
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
        if(this.selectedShippingAddressId != null)
        {
            this.selectedAddr.shipToAddress = this.allAddressList.get(this.selectedShippingAddressId);
            console.log(this.selectedAddr.shipToAddress);
            this.isShowModal = false;
        }
        else{
            console.log('selected Id is null')
            this.isShowModal = false;
        }
    }

}


