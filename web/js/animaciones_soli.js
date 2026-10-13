const eventos = [

    {
        id_evento: 1,
        id_local: 1,
        nombre_evento: "Noche Indie",
        fecha_evento: "2027-06-10",
        hora_evento: "21:30",
        aforo: 400,
        descripcion: "Buscamos grupos indie emergentes.",
        local: "Sala El Refugio"
    },

    {
        id_evento: 2,
        id_local: 2,
        nombre_evento: "Electronic Summer",
        fecha_evento: "2027-07-22",
        hora_evento: "23:00",
        aforo: 900,
        descripcion: "Festival de música electrónica.",
        local: "Club Aurora"
    }

];

function renderEventos() {

    const q = document.getElementById("q").value.toLowerCase();
    const fecha = document.getElementById("fFecha").value;
    const hora = document.getElementById("fHora").value;
    const aforo = document.getElementById("fAforo").value;

    const resultados = eventos.filter(e =>

        e.nombre_evento.toLowerCase().includes(q) &&

        (!fecha || e.fecha_evento === fecha) &&

        (!hora || e.hora_evento === hora) &&

        (
            !aforo ||

            (aforo === "100" && e.aforo <= 100) ||

            (aforo === "500" && e.aforo >= 101 && e.aforo <= 500) ||

            (aforo === "1000" && e.aforo >= 501 && e.aforo <= 1000) ||

            (aforo === "2000" && e.aforo > 1000)
        )
    );

    document.getElementById("results").innerHTML =

        resultados.length

        ? resultados.map(e => `

            <div class="card">

                <span class="tag">🎫 Evento</span>

                <h3>${e.nombre_evento}</h3>

                <p><strong>🏛️ Local:</strong> ${e.local}</p>

                <p><strong>📅 Fecha:</strong> ${e.fecha_evento}</p>

                <p><strong>🕒 Hora:</strong> ${e.hora_evento}</p>

                <p><strong>👥 Aforo:</strong> ${e.aforo}</p>

                <p>${e.descripcion}</p>

               <button
    class="btn btn-primary"
    onclick="solicitarParticipacion()">
    Solicitar participación
</button>

            </div>

        `).join("")

        :

        `<p style="text-align:center;">
            No se encontraron eventos.
        </p>`;
}
function solicitarParticipacion() {
    alert(
        "✅ Se ha enviado tu solicitud correctamente.\n\nVe a la bandeja de chat para ver si el local confirma tu participación."
    );
}

renderEventos();
// MENU HAMBURGUESA

const burger = document.getElementById("burger");
const navLinks = document.getElementById("navLinks");

if (burger && navLinks) {
  burger.addEventListener("click", () => {
    navLinks.classList.toggle("open");
  });
}

// MODAL LOGIN

function openModal(tipo) {

  const modal = document.getElementById("modal");
  const modalContent = document.getElementById("modalContent");

  if (!modal || !modalContent) return;

  if (tipo === "login") {

    modalContent.innerHTML = `
      <h3>Iniciar sesión</h3>

      <form onsubmit="fakeSubmit(event)">

        <div class="field">
          <label>Correo electrónico</label>
          <input type="email" required>
        </div>

        <div class="field">
          <label>Contraseña</label>
          <input type="password" required>
        </div>

        <button class="btn btn-primary w100">
          Entrar
        </button>

          <div id="okMsg" class="msg"></div>

      </form>
    `;
  }

  modal.classList.add("open");
}

function closeModal() {
  document.getElementById("modal").classList.remove("open");
}

function fakeSubmit(event) {

  event.preventDefault();

  const okMsg = document.getElementById("okMsg");

  okMsg.textContent = "Sesión iniciada correctamente";
  okMsg.style.display = "block";

  setTimeout(() => {
    closeModal();
  }, 2000);
}

// CERRAR MODAL AL HACER CLICK FUERA

const modal = document.getElementById("modal");

if (modal) {
  modal.addEventListener("click", (e) => {
    if (e.target.id === "modal") {
      closeModal();
    }
  });
}