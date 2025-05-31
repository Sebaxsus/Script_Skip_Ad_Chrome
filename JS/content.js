// Estado global para manejar los dobleClicks
let hasClicked = false
// Estado global para manejar el timeout | Si timeOutId es distinto a number no se ha asignado.
let timeOutId = null
// Estado Global para manejar los cambios en la URL de Youtube
let lastUrl = location.href
// Selecciono el elemento que voy a observar
// const targetNode = document.querySelector("button.ytp-skip-ad-button")

// Creo la configuracion del EventHandler MutationObserver
const config = {
    attributes: true,
    attributeFilter: ["disabled"],
    subtree: false
}

function forceClickAfterDelay(delay = 6200) {
    timeOutId = setTimeout(() => {
        const currentButton = document.querySelector("button.ytp-skip-ad-button");
        if (currentButton && !hasClicked) {
            console.warn("⏱️ Forzando clic después de 5.2s (ignorar disabled)");

            const clonedButton = currentButton.cloneNode(true);
            currentButton.replaceWith(clonedButton);
            clonedButton.click();
            hasClicked = true;
        } else {
            console.warn("❌ No se pudo forzar clic (botón no encontrado o ya clickeado)");
        }
    }, delay);

}

function triggerButtonClick() {
    const button = document.querySelector("button.ytp-skip-ad-button");

    if (!button) {
        // console.info("Reiniciando el eventListiner!")
        setTimeout(triggerButtonClick, 500);
        return;
    }

    console.log("🔔 Botón encontrado. Disabled?", button.disabled, " IsNull: ", button.offsetParent === null, " IsUndefined: ", typeof(button.offsetParent) === "undefined");

    const observer = new MutationObserver(() => {
        const newButton = document.querySelector("button.ytp-skip-ad-button");

        if (!hasClicked && newButton) {
            if (newButton.disabled) {
                console.log("😯 El botón está desactivado");
                // Nada más aquí, dejamos que el timeout se encargue
            } else {
                console.log("🎯 Clic inmediato al botón activo");
                newButton.click();
                hasClicked = true;
            }
        }
    });

    observer.observe(button, config);

    // if (!timeOutId) {
    //     console.warn("⏳ Creando timeout para forzar clic...");

    //     forceClickAfterDelay(6000)

        
    // } else {
    //     console.warn("⚠️ Timeout ya existente");
    // }
}

const obeserverYT = new MutationObserver(() => {
    if (location.href !== lastUrl) {
        console.log("📌 URL cambió, reiniciando triggerButtonClick()"),
        
        lastUrl = location.href
        
        // Reseteando estados
        clearTimeout(timeOutId)
        timeOutId = null
        hasClicked = false
        
        triggerButtonClick()
    }
})

obeserverYT.observe(document.body, {childList: true, subtree: true})

window.addEventListener("load", triggerButtonClick)

// const observer = new MutationObserver((mutationsList) => {
//     const button = document.querySelector("button.ytp-skip-ad-button")
    

//     // Si encontro un boton con la clase ytp-skip-ad-button
//     if (button) {
//         // console.log("🔔 Encontre el boton con su clase ", "\n Disabled?: ", button.disabled)

//         for (const mutation of mutationsList) {
//             if (mutation.type === "attributes" && mutation.attributeName == "disabled") {
//                 const isDisabled = button.disabled
//                 console.log("🔄 Estado del botón cambiado: ", isDisabled)
//             }
//         }
   
//         // Verifica si el texto del boton es saltar
//         // if (button.textContent.toLowerCase().includes("saltar"))
//         //     console.log("🔔‼️ El boton tiene el texto saltar")
//         // Verifica que el boton este visiable dentro de la ventana
//         if (button.offsetParent !== null && !hasClicked) {
//             // Verifica si el boton tiene el atributo disabled
//             if (button.disabled) {
//                 console.log("😯 El botón esta desactivado, Activandolo")
//                 // const timeOut = setTimeout(() => {
//                 //     // Le cambio el estado a disabled
//                 //     button.disabled = false
//                 //     // // Le quito al elemento HTML el atributo disabled
//                 //     button.removeAttribute("disabled")
//                 //     console.log("Se desactico el boton ", button, "\n Disabled?: ", button.disabled)
//                 // }, 5200)
                
//             } else {
//                 console.log("🎯 Haciendo clic en el boton...")
//                 // Hago el click
//                 button.click() // https://developer.mozilla.org/es/docs/Web/API/HTMLElement/click
//                 hasClicked = true
//                 // Esperar 10 segundos antes de volver a permitir click
//                 setTimeout(() => hasClicked = false, 3000)
//             }

//         }
//     } else {

//     }

// })

// observer.observe(targetNode, config)
// https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver