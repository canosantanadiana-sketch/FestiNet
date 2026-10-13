const mensajes = [];

function cargarChat() {

    const contenedor = document.getElementById("chatContainer");

    if (mensajes.length === 0) {
        contenedor.innerHTML = `
            <div class="chat-vacio">
                <h3>No tienes conversaciones activas</h3>
                <p>
                    Cuando solicites participar en un evento,
                    los mensajes aparecerán aquí.
                </p>
            </div>
        `;
    }
}

cargarChat();
const mensajes = [
    {
        local: "Sala El Refugio",
        mensaje: "Buenas tardes, estoy interesado en participar en el evento Noche Indie.",
        estado: "Pendiente de respuesta"
    }
];

function cargarChat() {

    const contenedor = document.getElementById("chatContainer");

    contenedor.innerHTML = mensajes.map(chat => `
        <div class="chat-card">

            <h3>🏛️ ${chat.local}</h3>

            <p>
                <strong>Tú:</strong><br>
                ${chat.mensaje}
            </p>

            <p style="color:orange;">
                ⏳ ${chat.estado}
            </p>

        </div>
    `).join("");
}

cargarChat();