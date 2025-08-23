async function loadCatalog(){
  const host = location.pathname.replace(/\/index\.html?$/,'');
  const res = await fetch('catalog.json').catch(()=>null);
  if (!res || !res.ok) return;
  const items = await res.json().catch(()=>[]);
  const grid = document.querySelector('#catalog');
  if (!grid || !Array.isArray(items)) return;
  grid.innerHTML = '';
  for (const it of items){
    const card = document.createElement('section');
    card.className = 'product';
    card.innerHTML = `
      <h2>${it.title}</h2>
      <p class="desc">${it.desc||''}</p>
      ${it.code ? `<div class="code"><pre><code>${it.code}</code></pre></div>`:''}
      <div class="cta">
        ${it.tip ? `<a class="btn buy" href="${it.tip}" target="_blank" rel="noopener noreferrer">Tip ${it.tip_label||''}</a>`:''}
        ${it.zip ? `<a class="btn dl" href="products/${it.zip}" download>Download</a>`:''}
      </div>
      ${it.note ? `<p class="fine">${it.note}</p>`:''}
    `;
    grid.appendChild(card);
  }
}
window.addEventListener('DOMContentLoaded', loadCatalog);
