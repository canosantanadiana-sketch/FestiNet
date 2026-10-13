document.addEventListener("DOMContentLoaded", () => {
    const boton = document.querySelector(".burger");
    const navLinks = document.querySelector(".nav-links");
    boton.addEventListener("click", () => {
        navLinks.classList.toggle("open");
    });
});
function openModal(kind,extra){
  const m=document.getElementById('modalContent');
  if(kind==='registro'){
    m.innerHTML=`
    <h3>Crear cuenta en festiNET</h3>
    <div class="tabs">
      <button id="tabA" class="${extra!=='local'?'active':''}" onclick="setRegTab('artista')">🎤 Artista</button>
      <button id="tabL" class="${extra==='local'?'active':''}" onclick="setRegTab('local')">🏛️ Local / Promotor</button>
    </div>
    <form onsubmit="fakeSubmit(event,'¡Cuenta creada! Revisa tu correo para verificar tu identidad.')">
      <div class="field"><label>Nombre artístico / Nombre del local</label><input required></div>
      <div class="field"><label>Correo electrónico</label><input type="email" required></div>
      <div class="field"><label>Contraseña</label><input type="password" minlength="8" required></div>
      <div class="field" id="regExtra"></div>
      <button class="btn btn-primary w100">Registrarme</button>
      <div class="msg" id="okMsg"></div>
    </form>`;
    setRegTab(extra==='local'?'local':'artista');
  }else if(kind==='login'){
    m.innerHTML=`<h3>Iniciar sesión</h3>
    <form onsubmit="fakeSubmit(event,'Sesión iniciada. ¡Bienvenido de nuevo!')">
      <div class="field"><label>Correo electrónico</label><input type="email" required></div>
      <div class="field"><label>Contraseña</label><input type="password" required></div>
      <button class="btn btn-primary w100">Entrar</button>
      <div class="msg" id="okMsg"></div>
    </form>`;
  }else{
    m.innerHTML=`<h3>Solicitud de contratación</h3>
    <form onsubmit="fakeSubmit(event,'Solicitud enviada. El otro usuario la recibirá en su panel y podráá responder por chat.')">
      <div class="field"><label>Dirigida a</label><input value="${extra||'—'}" readonly></div>
      <div class="field"><label>Fecha del evento</label><input type="date" required></div>
      <div class="field"><label>Presupuesto (€)</label><input type="number" min="1" placeholder="ej. 800" required></div>
      <div class="field"><label>Mensaje</label><textarea rows="3" placeholder="Cuéntanos los detalles del evento..." required></textarea></div>
      <button class="btn btn-primary w100">Enviar solicitud</button>
      <div class="msg" id="okMsg"></div>
    </form>`;
  }
  document.getElementById('modal').classList.add('open');
}
function setRegTab(t){
  document.getElementById('tabA').classList.toggle('active',t==='artista');
  document.getElementById('tabL').classList.toggle('active',t==='local');
  document.getElementById('regExtra').innerHTML = t==='artista'
    ? `<label>Género musical</label><select><option>Pop</option><option>Rock</option><option>Electrónica</option><option>Urbano</option><option>Indie</option><option>Jazz</option></select>`
    : `<label>Capacidad del local</label><input type="number" min="10" placeholder="ej. 400">`;
}
function closeModal(){document.getElementById('modal').classList.remove('open')}
function fakeSubmit(e,msg){
  e.preventDefault();
  const el=document.getElementById('okMsg');
  el.textContent=msg; el.style.display='block';
  setTimeout(closeModal,2200);
}
document.getElementById('modal').addEventListener('click',e=>{if(e.target.id==='modal')closeModal()});
document.getElementById('burger').onclick=()=>document.getElementById('navLinks').classList.toggle('open');
document.querySelectorAll('.nav-links a').forEach(a=>a.onclick=()=>document.getElementById('navLinks').classList.remove('open'));
