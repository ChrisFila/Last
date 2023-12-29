////////////////////////////////////////////////////
////////////////// CONFIGURATION ///////////////////
////////////////////////////////////////////////////

// Véhicules (Syntaxe : "labelDuVéhicule": prixDuVéhicule,)
let config = {
    "faggio": 250,
    "panto": 500
};

// ATTENTION ! LES IMAGES DES VÉHICULES NE SONT PAS PRÉSENTES DE BASE, VOUS DEVEZ LES RAJOUTER VOUS-MÊMES AU FORMAT .PNG DANS LE DOSSIER img !

////////////////////////////////////////////////////
//////////// CODE (évitez de toucher) //////////////
////////////////////////////////////////////////////

let i = 0;
let vehicles = Object.keys(config)
vehiclesContainer.innerHTML = "<img width=300px height=200px id=vehicleImage src=../img/"+vehicles[i]+".png> <p id=price>Prix: "+config[vehicles[i]]+"$</p>";

$(function () {
    function display(bool) {
        if (bool) {
            $("#location").show();
        } else {
            $("#location").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })
    document.onkeyup = function (data) {
        if (data.which == 27 || data.which == 8) {
            $.post(`http://${GetParentResourceName()}/exit`, JSON.stringify({}));
            return
        }
    };
    $("#leaveicon").click(function () {
        $.post(`http://${GetParentResourceName()}/exit`, JSON.stringify({}));
        return
    });
    $("#leftArrow").click(function () {
        prevImage()
        return
    });
    $("#rightArrow").click(function () {
        nextImage()
        return
    });
    $("#hireVehicle").click(function () {
        $.post(`http://${GetParentResourceName()}/rentVehicle`, JSON.stringify({
            vehicle: vehicles[i],
            price: config[vehicles[i]]
        }))
    })
})



function nextImage(){
    if (i<vehicles.length-1) {
        i++;
    } else {
        i = 0;
    }
    vehiclesContainer.innerHTML = "<img width=300px height=200px id=vehicleImage src=../img/"+vehicles[i]+".png> <p id=price>Prix: "+config[vehicles[i]]+"$</p>";
}
function prevImage(){
    if (i > 0) {
        i--;
    } else {
        i = vehicles.length-1;
    }
    vehiclesContainer.innerHTML = "<img width=300px height=200px id=vehicleImage src=../img/"+vehicles[i]+".png> <p id=price>Prix: "+config[vehicles[i]]+"$</p>";
}