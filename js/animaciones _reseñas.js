function agregarResena() {

    const tipo =
        document.getElementById("tipoValoracion").value;

    const autor =
        document.getElementById("autor").value;

    const destinatario =
        document.getElementById("destinatario").value;

    const puntuacion =
        document.getElementById("puntuacion").value;

    const comentario =
        document.getElementById("comentario").value;

    const fecha = new Date().toLocaleDateString("es-ES");

    if(!autor || !destinatario || !comentario){
        alert("Completa todos los campos");
        return;
    }

    const estrellas = "⭐".repeat(puntuacion);

    const etiqueta =
        tipo === "artista-local"
        ? "🎤 Artista → 🏛️ Local"
        : "🏛️ Local → 🎤 Artista";

    document.getElementById("listaResenas")
    .insertAdjacentHTML("afterbegin",`

        <div class="review-card">

            <div class="review-head">

                <span class="review-type">
                    ${etiqueta}
                </span>

                <span class="review-stars">
                    ${estrellas}
                </span>

            </div>

            <h4>
                ${autor} → ${destinatario}
            </h4>

            <p class="review-date">
                📅 ${fecha}
            </p>

            <p>
                ${comentario}
            </p>

        </div>

    `);

}