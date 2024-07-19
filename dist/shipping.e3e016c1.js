console.log("hello from shippingweb.js");
function openAddCargo() {
    const addCargoDiv = document.getElementById("addCargo-content");
    const addOptionDiv = document.getElementById("addOption");
    let activeEl = document.getElementsByClassName("active");
    let clickedEl = document.getElementsByClassName("clicked");
    clickedEl[0].classList.remove("clicked");
    activeEl[0].classList.remove("active");
    addCargoDiv.classList.add("active");
    addOptionDiv.classList.add("clicked");
}
function openUpdateLocation() {
    const updateLocationDiv = document.getElementById("updateLocation-content");
    const updateOptionDiv = document.getElementById("updateOption");
    let activeEl = document.getElementsByClassName("active");
    let clickedEl = document.getElementsByClassName("clicked");
    activeEl[0].classList.remove("active");
    clickedEl[0].classList.remove("clicked");
    updateLocationDiv.classList.add("active");
    updateOptionDiv.classList.add("clicked");
}
function openShipHistory() {
    const shipHistoryDiv = document.getElementById("shipHistory-content");
    const historyOptionDiv = document.getElementById("historyOption");
    let activeEl = document.getElementsByClassName("active");
    let clickedEl = document.getElementsByClassName("clicked");
    activeEl[0].classList.remove("active");
    clickedEl[0].classList.remove("clicked");
    shipHistoryDiv.classList.add("active");
    historyOptionDiv.classList.add("clicked");
}

//# sourceMappingURL=shipping.e3e016c1.js.map
