import { LightningElement, api } from 'lwc';
import SOCIAL from '@salesforce/resourceUrl/SOCIAL';
import submitRequest from 'c/submitRequest';
import isguest from '@salesforce/user/isGuest';
import Id from '@salesforce/user/Id';

export default class SpartanFooter extends LightningElement {
    
    result;
    GuestUser = isguest;
    userId = Id;
    async handlePromptClick()
    {
        this.result = await submitRequest.open(
            {
                content : 'hello',
                isGuestUser : this.GuestUser,
                userId : this.userId
            }
        );
        console.log(this.result);
    }





    ABOUT_COMPANY={
        NAME:'SPARTAN',
        ROLE:'Full Stack Developer',
        EMAIL:'pochanaanandkumar@gmail.com',
        PHONE:'+918790242342',
        HOME: 'Andhra Pradesh, 516360, India',
        CHAT: '+919381556307'
    }

    SOCIAL_LINKS=[
        {
            type:'twitter',
            label:"twitter/Spartan",
            link:"https://twitter.com/Spartan",
            icon:SOCIAL+'/SOCIAL/twitter.svg'
        },
        {
            type: "facebook",
            label: "facebook/Spartan",
            link: "https://facebook.com/Spartan",
            icon: SOCIAL + '/SOCIAL/facebook.svg'
        },
        {
            type: "github",
            label: "github/Spartan",
            link: "https://github.com/Spartan",
            icon: SOCIAL + '/SOCIAL/github.svg'
        },
        {
            type: "linkedin",
            label: "linkedin/Spartan",
            link: "https://www.linkedin.com/in/Spartan/",
            icon: SOCIAL + '/SOCIAL/linkedin.svg'
        },
    ]
    COMPANY_SUMMARY={
        DESCRIPTION: "Spartan Cycles has practically created and perfected every new cycle category in the country. Spartan, our retail brand with the vision of ‘Spreading the joy of cycling’ has become India’s one stop shop for all your cycling needs - bicycle sales, service, spares and accessories.",
    }
}