const headerTemplate = document.createElement('template');

headerTemplate.innerHTML = `
    <header>
        <nav class="nav-bar shippingnav-bar">
            <h3><a href="../homepage.html">Test Shipping and Receiving App</a></h3>
            <div class="right-nav-bar">
                <h3 style="padding-right: 20px;"><a href="../shipping.html">Ship Delivery</a></h3>
                <button id="connect-btn" class="connect-btn">
                    Connect Wallet
                    <span id="is-connected-value"></span>
                    <span id="address-value"></span>
                </button>
            </div>
        </nav>
    </header>
`

document.body.prepend(headerTemplate.content);

document.addEventListener("DOMContentLoaded", () => {
    // Retrieve userAdress from localStorage
    const userAddress = localStorage.getItem('userAddress');

    if(userAddress){
        document.getElementById('address-value').textContent = userAddress;
        document.getElementById('is-connected-value').textContent = "Connected";
    } else {
        document.getElementById('is-connected-value').textContent = "Not Connected";
    }
});