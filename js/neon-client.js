// Client compartit per Neon Data API + Neon Auth
const NEON_DATA_API_URL = 'https://ep-calm-mode-b2w6bds0.apirest.c-6.eu-central-1.aws.neon.tech/neondb/rest/v1';
const NEON_AUTH_URL = 'https://ep-calm-mode-b2w6bds0.neonauth.c-6.eu-central-1.aws.neon.tech/neondb/auth';

function toLocalDateStr(d){
  const y = d.getFullYear(), m = String(d.getMonth()+1).padStart(2,'0'), day = String(d.getDate()).padStart(2,'0');
  return `${y}-${m}-${day}`;
}
function todayStr(){ return toLocalDateStr(new Date()); }

function decodeJwtExp(token){
  const b64 = token.split('.')[1].replace(/-/g,'+').replace(/_/g,'/');
  const payload = JSON.parse(atob(b64));
  return payload.exp;
}

function getSession(){
  try{
    const s = localStorage.getItem('dash_session');
    if(!s) return null;
    return JSON.parse(s);
  }catch(e){ return null; }
}

function saveSession(token, user){
  const prev = getSession();
  const sess = {
    access_token: token,
    expires_at: decodeJwtExp(token),
    user: user || (prev ? prev.user : null)
  };
  localStorage.setItem('dash_session', JSON.stringify(sess));
  return sess;
}

// El JWT caduca als 15 min, però la sessió (cookie) dura més: la renovem en silenci.
async function refreshSession(){
  try{
    const r = await fetch(`${NEON_AUTH_URL}/token`, { credentials:'include' });
    if(!r.ok){ localStorage.removeItem('dash_session'); return null; }
    const data = await r.json();
    return saveSession(data.token);
  }catch(e){ return null; }
}

async function ensureSession(){
  let s = getSession();
  if(s && Date.now()/1000 < s.expires_at - 30) return s;
  s = await refreshSession();
  return s;
}

async function authSignIn(email, password){
  const r = await fetch(`${NEON_AUTH_URL}/sign-in/email`, {
    method:'POST',
    headers:{'Content-Type':'application/json'},
    credentials:'include',
    body: JSON.stringify({ email, password })
  });
  const data = await r.json();
  if(!r.ok) throw new Error(data.message==='Invalid email or password' ? 'Correu o contrasenya incorrectes.' : (data.message||'Error d\'accés'));

  const tokenR = await fetch(`${NEON_AUTH_URL}/token`, { credentials:'include' });
  if(!tokenR.ok) throw new Error('No s\'ha pogut obtenir el token de sessió.');
  const tokenData = await tokenR.json();
  return saveSession(tokenData.token, data.user);
}

async function doLogout(){
  try{ await fetch(`${NEON_AUTH_URL}/sign-out`, { method:'POST', credentials:'include' }); }catch(e){}
  localStorage.removeItem('dash_session');
  location.href = 'login.html';
}

function requireAuth(){
  const s = getSession();
  if(!s){ location.replace('login.html'); return false; }
  const el = document.getElementById('user-email');
  if(el) el.textContent = s.user ? s.user.email : '';
  return true;
}

function getHDR(){
  const s = getSession();
  const tok = s && s.access_token ? s.access_token : '';
  return { 'Content-Type':'application/json', 'Authorization':'Bearer '+tok, 'Prefer':'return=representation' };
}

async function sbGet(t,q=''){
  const s = await ensureSession();
  if(!s){ location.replace('login.html'); throw new Error('Sessió caducada'); }
  const r = await fetch(`${NEON_DATA_API_URL}/${t}?${q}`, { headers:getHDR() });
  if(!r.ok) throw new Error(await r.text());
  return r.json();
}
async function sbPost(t,d){
  const s = await ensureSession();
  if(!s){ location.replace('login.html'); throw new Error('Sessió caducada'); }
  const r = await fetch(`${NEON_DATA_API_URL}/${t}`, { method:'POST', headers:getHDR(), body:JSON.stringify(d) });
  if(!r.ok) throw new Error(await r.text());
  return r.json();
}
async function sbPatch(t,id,d){
  const s = await ensureSession();
  if(!s){ location.replace('login.html'); throw new Error('Sessió caducada'); }
  const r = await fetch(`${NEON_DATA_API_URL}/${t}?id=eq.${id}`, { method:'PATCH', headers:getHDR(), body:JSON.stringify(d) });
  if(!r.ok) throw new Error(await r.text());
  return r.json();
}
async function sbDel(t,id){
  const s = await ensureSession();
  if(!s){ location.replace('login.html'); throw new Error('Sessió caducada'); }
  const r = await fetch(`${NEON_DATA_API_URL}/${t}?id=eq.${id}`, { method:'DELETE', headers:getHDR() });
  if(!r.ok) throw new Error(await r.text());
}
// Esborra per un conjunt de columnes (útil per a taules sense id, com les de clau composta).
async function sbDelWhereCompound(t, filters){
  const s = await ensureSession();
  if(!s){ location.replace('login.html'); throw new Error('Sessió caducada'); }
  const q = Object.entries(filters).map(([k,v])=>`${k}=eq.${encodeURIComponent(v)}`).join('&');
  const r = await fetch(`${NEON_DATA_API_URL}/${t}?${q}`, { method:'DELETE', headers:getHDR() });
  if(!r.ok) throw new Error(await r.text());
}

// PIN per protegir l'anul·lació de factures. Canvia'l per un de propi.
const CANCEL_PIN = '1234';
function checkPin(msg){
  const pin = prompt(msg || '🔒 PIN per anul·lar la factura:');
  return pin !== null && pin === CANCEL_PIN;
}
