import React from 'react';
import { Link } from 'react-router-dom';
import "../designs/Auth.css";
import "../designs/Profile.css";
import { getItem } from '../helpers/localstorage';
import { AuthService } from '../services/auth';


function Profile() {
  setErrorMsg("");
  const jwt_token = getItem("PHPTOKEN");
  const response = await AuthService.getUserInfo(jwt_token);
  const parsedResponse = await response.json();
  setErrorMsg(parsedResponse.message);
  


  const username = "AnonymousGrizzly";
  const email = "test1@test1.com";
  const password = "Test123!";
  return <div>
      <div className='profile-cntnr'>
        <div className='profile-wrapper'>
            <h2>PROFILE</h2>
            <p id="username"><i className="fas fa-user"></i><b>  Username:</b>&emsp;&emsp;{username}</p>
            <p id="email"><i className="fas fa-envelope"></i><b> Email:</b> &emsp;&emsp;&emsp;&ensp;{email}</p>
            <p id="password"><i className="fas fa-key"></i><b>  Password:</b>&emsp;&emsp;{password}</p>
            <br/><br/>
            <Link smooth to="/update" className="secondary-btn" > Change <i class="fas fa-long-arrow-alt-right"></i></Link>
        </div>
      </div>
  </div>;
}

export default Profile;
