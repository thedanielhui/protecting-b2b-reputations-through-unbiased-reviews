
// connect to Moralis server
const serverUrl = "https://x2lurelpy1o7.usemoralis.com:2053/server";
const appId = "HyZB0EEUarr7AgaJfs4d4lDVRCspCz6etzGIUzum";
Moralis.start({ serverUrl, appId });

// add from here down
async function login() {
    let user = Moralis.User.current();
    if (!user) {
        user = await Moralis.authenticate();
        $("#btn-login").hide();
        $("#btn-logout").show();

        $("#create-topic").show();

    } 
}
async function logOut() {
    await Moralis.User.logOut();
    $("#btn-login").show();
    $("#btn-logout").hide();
}

let reviewIndex = 1;
let reviewExposed = false;
async function loadReview() {
    reviewExposed = true;
}
setInterval(function () {
    if(reviewExposed){
        $("#reviews li:nth-child("+reviewIndex+")").show();
        reviewIndex++;
    }

 }, 10000);




document.getElementById("btn-fund").onclick = loadReview;

document.getElementById("btn-login").onclick = login;
document.getElementById("btn-logout").onclick = logOut;




