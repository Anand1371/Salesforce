import { LightningElement, api } from 'lwc';

export default class B2BProgressIndicatorCheckoutFlow extends LightningElement {
    @api currentStep = '';
    steps = [
        { label:'Shipping/Billing Address', value:'shippingBillingAddress' },
        { label:'Delivery Method', value:'deliveryMethod' },
        { label:'Order Review', value:'checkoutSummary' },
        { label:'Payment', value:'payment' },
        { label:'Order Confirmation', value:'orderConfirmation' }
    ]
    
}