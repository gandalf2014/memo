const https= require('https');
const axios = require('axios').default;




(async()=>{
    let response = await axios.get("https://api.github.com/meta");
    if(response.ok){
        console.log("ok...")
         let data=response.json;
         console.table(data)
    }else{
        console.log("fail")
    }
    
})()

