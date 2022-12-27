/**
 * @description       : Register Component
 * @author            : Anand Kumar Reddy
 * @group             : 
 * @last modified on  : 07-12-2022
 * @last modified by  : Anand Kumar Reddy
 * Modifications Log 
 * Ver   Date         Author              Modification
 * 1.0   07-12-2022   Anand Kumar Reddy   Initial Version
**/

import { LightningElement,api,track,wire } from 'lwc';
import registerUser from '@salesforce/apex/B2B_SelfRegisterCustomController.registerUser';
import isEmailExist from '@salesforce/apex/B2B_SelfRegisterCustomController.isEmailExist';
import isPhoneExist from '@salesforce/apex/B2B_SelfRegisterCustomController.isPhoneExist';
import pset from '@salesforce/apex/B2B_SelfRegisterCustomController.pset';

export default class b2b_customSelfRegister extends LightningElement 
{
    @api showModal = false; // to show the modal for an error success or any warning
    firstName; // first name I have passed the apex class full name = firsrName+LastName;
    lastName;
    email;
    username;
    phone;
    password;
    confirmPassword;

    
    @track isComapnyUser = false;
    @track accountName = null;
    @track psetGroupId = '0PG5h000000bzgUGAQ';
    @track newUID;
    @track loginUrl;
    // @track navigationVar;
    // Error Handling

    @track errorCheck;
    @track defaultErrorMsg;
    @track emailError;
    @track errorMessage;
    
    
   
    @track userName = '';
    @track userCreated = false;
    showUserName;
    @track pageLoading = true;
    


    connectedCallback()
    {
        this.pageLoading = false;
        this.defaultErrorMsg = "Something Went Wrong, Please Try Again after sometimes";
        this.errorCheck = false;
        this.isComapnyUser= false;
    }

    //First Name Handler
    handleFirstNameChange(event)
    {
        this.firstName = event.target.value;
        if(!this.isComapnyUser)
        {
            this.accountName = this.firstName + this.lastName;
            console.log(this.accountName);
        }
        if(this.lastName == '' && this.firstName == '')
        {
            this.accountName = null;
        }
        if(this.lastName == null && this.firstName == null)
        {
            this.accountName = null;
        }

    }

    //Last Name Handler
    handleLastNameChange(event)
    {
        this.lastName = event.target.value;
        if(!this.isComapnyUser)
        {
            this.accountName = this.firstName + this.lastName;
            console.log(this.accountName);
        }
        if(this.lastName == '' && this.firstName == '')
        {
            this.accountName = null;
        }
        if(this.lastName == null && this.firstName == null)
        {
            this.accountName = null;
        }
    }

    //Phone Handler
    handlePhoneChange(event)
    {
        this.phone = event.target.value;
    }
    
    //Email Handler
    handleEmailChange(event)
    {
        this.email = event.target.value;
        this.userName = event.target.value;
    }
    onEmailInvalid(event)
    {

        if (!event.target.validity.valid) 
        {
            event.target.setCustomValidity('Enter a valid email Address!')
        }
    }
    onEmailInput(event)
    {

        event.target.setCustomValidity('')
    }

    //Password Handler
    handlePasswordChange(event){

        this.password = event.target.value;
    }

    onPasswordInvalid(event)
    {
        if (!event.target.validity.valid) 
        {
            event.target.setCustomValidity('Password must be Minimum eight characters, at least one letter, one number and one special character.')
        }
    }

    //Confirm Password Handler
    handleConfirmPasswordChange(event){

        this.confirmPassword = event.target.value;
    }
    
    
    //By Using Imperative Method  

    handleRegister(event)
    {
                            // Field Validation
                            console.log('Inside Handle Register');
                            this.errorCheck = false;
                            this.errorMessage = null;
                            this.pageLoading = true;
                                                   

                            if(this.lastName==null || this.email==null || this.phone==null || this.password==null || this.confirmPassword==null)
                            {
                                this.errorCheck = true;
                                this.errorMessage = 'Required Fields are missing';
                                this.pageLoading = false;
                                event.preventDefault();
                                this.pageLoading = false;
                                return;
                            }


                            if(this.firstName && this.lastName && this.email && this.phone && this.userName && this.password && this.confirmPassword)
                            {
                                this.pageLoading = true;
                                if(this.password != this.confirmPassword){   
                                    this.errorCheck = true;
                                    this.errorMessage = 'Password did not match. Please Make sure both the passwords match.';
                                    this.pageLoading = false;
                                    event.preventDefault();
                                    this.pageLoading = false;
                                    return;
                                }
                            }
                             
                            
                            
                            if( this.accountName ==  '' || this.accountName == null)
                            {
                                this.errorCheck = true;
                                console.log('Account Assignment Error');
                                this.errorMessage = 'Please Refresh and Retry to Enter all Required Field';
                                this.pageLoading = false;
                                return;
                            }


                            console.log('PasswordCheckCompleted');
                            event.preventDefault();
                            //apex class call imperative method


                            
                            isEmailExist({Email: this.email})
                            .then((result3) =>{
                                if(result3 != null && result3 != undefined && result3 == true)
                                {
                                    console.log('UsernameError');
                                    console.log('result', result3)
                                    this.emailError = 'Your username already exists somewhere on the  Salesforce Ecosystem.';
                                    this.errorCheck = true;
                                    this.errorMessage = 'Your Email already exists.';
                                    this.pageLoading = false;
                                }
                                else {
                                    isPhoneExist({Phone: this.phone})
                                    .then((result) =>{
                                        if(result != null && result != undefined && result == true)
                                        {
                                            console.log('PhoneNumberError');
                                            console.log('result', result)
                                            this.emailError = 'Your username already exists somewhere on the  Salesforce Ecosystem.';
                                            this.errorCheck = true;
                                            this.errorMessage = 'Your PhoneNumber already exists.';
                                            this.pageLoading = false;
                                        }
                                        else {
                                            registerUser({ firstName: this.firstName, lastName: this.lastName, email: this.email, phone: this.phone, accountName : this.accountName, pass:this.password, orgUser:this.isComapnyUser})
                                                .then((result1) => 
                                                {
                                                                
                                                    if(result1){    
                                                                                    
                                                        console.log(result1);
                                                        this.newUID = result1['userId'];
                                                        this.loginUrl = result1['pageRef'];
                                                        
        
                                                        this.userCreated  =true;
                                                        this.assignPS();
                                                    
                                                    }
                                                    this.pageLoading = false;
                                                })
                                                .catch((error) => {
                                                    console.log('User not Created');
                                                    
                                                    console.log('error-',error);
                                                    
                                                    this.pageLoading = false;
                                    
                                                    if(error && error.body && error.body.message){
                                    
                                                        this.errorCheck = true;
                                                        this.errorMessage = error.body.message;
                                                        console.log('Check 6');
                                                        
                                                    
                                                    }           
                                                    
                                                });
                                            }
                                    })
                                    .catch((error) => {
                                        this.error = error;
                                        console.log('Error at PhoneNumber');
                                    
                                        if(error && error.body && error.body.message){
                                            console.log('error msg-', error.body.message);
                                        }
        
                                        this.pageLoading = false;
                                        
                                    });
                                }
                            })
                            .catch((error) => {
                                this.error = error;
                                console.log('Error at Email');
                                
                                if(error && error.body && error.body.message){
                                    console.log('error msg-', error.body.message);
                                }
    
                                this.pageLoading = false;
                                    
                            });
                      
    }


    // Assigning Permission Sets to new User

    assignPS()
    {
        this.pageLoading = true;
        pset({permissionsetGroupsID:this.psetGroupId, userId:this.newUID})
        .then((result2) =>
        {
            console.log(result2);
            console.log(this.loginUrl);
            window.location.href = this.loginUrl;

        })
        .catch((error) =>
        {

            this.error = error;
            console.log('Error at Assigning Permission Set to User');
            this.pageLoading =false;
            console.log(error);
        });
    }

    // Permission Set Assignment Ended

}