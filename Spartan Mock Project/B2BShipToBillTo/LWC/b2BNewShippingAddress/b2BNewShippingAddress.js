import { LightningElement, api } from 'lwc';
import LightningModal from 'lightning/modal';

import createNewContactPointShippingAddress from '@salesforce/apex/B2B_AddressSelectorFlowController.createNewContactPointShippingAddress';

export default class B2BNewShippingAddress extends LightningModal {
    @api cartId;
    contactPointAddressData = {
        name : '',
        street : '',
        city : '',
        state : '',
        postalCode : '',
        country : '',
    };

    isDefault = false;
    isAddressForFutureUse = false;

    
    nameHandler(event)
    {
        this.contactPointAddressData.name = event.detail.value;
    }

    streetHandler(event)
    {
        this.contactPointAddressData.street = event.detail.value;
    }

    cityHandler(event)
    {
        this.contactPointAddressData.city = event.detail.value;
    }

    stateHandler(event)
    {
        this.contactPointAddressData.state = event.detail.value;
    }

    postalCodeHandler(event)
    {
        this.contactPointAddressData.postalCode = event.detail.value;
    }

    countryHandler(event)
    {
        this.contactPointAddressData.country = event.detail.value;
    }

    isDefaultHandler(event)
    {
        this.isDefault = event.detail.checked;
        console.log(this.isDefault);
    }

    isAddressForFutureUseHandler(event)
    {
        this.isAddressForFutureUse = event.detail.checked;
    }

    handleSave()
    {

        createNewContactPointShippingAddress({newAddress : this.contactPointAddressData, isDefault: this.isDefault, isAddressForFutureUse : this.isAddressForFutureUse, cartId : this.cartId})
        .then(result=>{
            console.log(result);
            this.updateRecordView();
            this.close('Okay');
            //this.dispatchEvent(new CustomEvent('refresh'));
        })
        .catch(error=>{
            console.log('** error' + JSON.stringify(error));
        })
        
        
    }

    updateRecordView() {
        // setTimeout(() => {
        //      eval("$A.get('e.force:refreshView').fire();");
        // }, 1000);
        window.location.reload();
    }
}