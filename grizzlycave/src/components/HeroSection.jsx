import React from 'react'
import "../styles/HeroSection.css"
import HeroImg from "../images/Grizzly.png"
import { HashLink as Link } from 'react-router-hash-link';

export default function HeroSection() {
    return (
        <div className="hero-cntnr" id="Home">
            <div className="hero-wrapper">
                <h1> A safe place for your files</h1>
                <p> operate with files safely. </p>
                <div className='hero-btns'>
                    <Link className="hero-btn" to="/signup">Sign In</Link>
                    <Link className="hero-btn" to="/signin">Log In</Link>
                </div>
            </div>
                <img src={HeroImg} alt="Grizzly Cave" id="HeroImg"/>
                <div className="change-cntnr"/>
                
        </div>
        
    )
}

 