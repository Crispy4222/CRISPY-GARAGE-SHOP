async function loadCatalog(){
  const host = location.pathname.replace(/\/index\.html?$/,'');
  const catalogResponse = await fetch('catalog.json').catch(()=>null);
  if (!catalogResponse || !catalogResponse.ok) return;
  const catalogItems = await catalogResponse.json().catch(()=>[]);
  const catalogGrid = document.querySelector('#catalog');
  if (!catalogGrid || !Array.isArray(catalogItems)) return;
  catalogGrid.innerHTML = '';
  for (const product of catalogItems){
    const productCard = document.createElement('section');
    productCard.className = 'product';
    productCard.innerHTML = `
      <h2>${product.title}</h2>
      <p class="desc">${product.desc||''}</p>
      ${product.code ? `<div class="code"><pre><code>${product.code}</code></pre></div>`:''}
      <div class="cta">
        ${product.tip ? `<a class="btn buy" href="${product.tip}" target="_blank" rel="noopener noreferrer">Tip ${product.tip_label||''}</a>`:''}
        ${product.zip ? `<a class="btn dl" href="products/${product.zip}" download>Download</a>`:''}
      </div>
      ${product.note ? `<p class="fine">${product.note}</p>`:''}
    `;
    catalogGrid.appendChild(productCard);
  }
}
window.addEventListener('DOMContentLoaded', loadCatalog);
