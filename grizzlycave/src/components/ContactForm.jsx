import React, { useEffect, useState } from 'react';
import emailjs from '@emailjs/browser';
import '../styles/ContactForm.css';
import { Mail, Lock } from 'react-feather';
import {validateEmail} from '../RegEx/validateEmail';

export default function ContactForm() {
  const [email, setEmail] = useState('');
  const [isValid, setValid] = useState('');

  function sendEmail(e) {
    e.preventDefault();
    emailjs.sendForm('service_7bw3ypg', 'template_pjtvv4s', e.target, 'user_Gs5hL6Zeeq6azeTc0ccJB')
      .then((result) => {
          console.log(result.text);
          alert("Message sent!");
      }, (error) => {
          console.log(error.text);
          alert("An error occured!");
      });
      e.target.reset(); 
  }

  useEffect(() => {
    setValid(validateEmail(email));
  }, [email]);

  return (
    <div className='contactform-cntnr'>
     <form className="contact-form" onSubmit={sendEmail}>
        <h1 id ="ContactUs" className='icon2'>Contact us &nbsp; <Mail size="35"/></h1>
        <p>-  We'd love to hear from you! - </p>
        <input type="text" name="user_name" id="user_name" placeholder="Name or Company"  required/>
        <input type="email" onInput={(e) => setEmail(e.target.value)} value={email} name="user_email" id="user_email" placeholder="Email" clasname="field" required/>
        <textarea name="user_message" id="user_message" placeholder="        How can we help you?" required />
        <p className='icon'><Lock size="20"/> &nbsp; we NEVER share your email with anyone</p>
        {isValid && (<input type="submit" value="Send"  className="submit-btn"/>)}
     </form>
    
    </div>
  );
}