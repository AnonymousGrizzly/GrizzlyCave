
const BASEURL = "http://localhost:3001/grizzlyphp/api/";


export class AuthService {
    static async createUser(user) {
        const url = BASEURL + "create_user.php";
        const response = await fetch(url, {
            method: "POST",
            body: JSON.stringify(user)
        });
        return response;
    }

    static async loginUser(user) {
        const url = BASEURL + "login.php";
        const response = await fetch(url, {
            method: "POST", 
            body: JSON.stringify(user)
        });
        return response;
    }

};

