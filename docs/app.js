const make = (tag, className, text) => {
  const node = document.createElement(tag);
  if (className) node.className = className;
  if (text) node.textContent = text;
  return node;
};

const safeHref = (value) => {
  const url = new URL(value, window.location.href);
  if (url.protocol === 'mailto:') return url.href;
  const allowedRemote = new Set(['cash.app', 'github.com', 'crispy4222.github.io']);
  if (url.origin === window.location.origin || allowedRemote.has(url.hostname)) return url.href;
  throw new Error('Catalog link host is not allowed');
};

async function loadCatalog() {
  const grid = document.querySelector('#catalog');
  if (!grid) return;

  try {
    const response = await fetch('catalog.json', { cache: 'no-store' });
    if (!response.ok) throw new Error(`catalog HTTP ${response.status}`);
    const items = await response.json();
    if (!Array.isArray(items) || items.length === 0) throw new Error('catalog is empty');

    grid.replaceChildren();

    for (const item of items) {
      const card = make('section', 'product');
      card.append(make('h2', '', item.title || 'Untitled Garage item'));
      if (item.price) card.append(make('p', 'price', item.price));
      card.append(make('p', 'desc', item.desc || ''));

      if (item.code) {
        const codeBox = make('div', 'code');
        const pre = make('pre');
        const code = make('code', '', item.code);
        pre.append(code);
        codeBox.append(pre);
        card.append(codeBox);
      }

      const actions = make('div', 'cta');

      for (const link of Array.isArray(item.links) ? item.links : []) {
        const anchor = make('a', 'btn dl', link.label || 'Open file');
        anchor.href = safeHref(link.href);
        if (link.download) anchor.setAttribute('download', '');
        actions.append(anchor);
      }

      if (item.zip) {
        const download = make('a', 'btn dl', 'Download archive');
        download.href = safeHref(`products/${item.zip}`);
        download.setAttribute('download', '');
        actions.append(download);
      }

      if (item.tip) {
        const pay = make('a', 'btn buy', item.tip_label || 'Pay with Cash App');
        pay.href = safeHref(item.tip);
        pay.target = '_blank';
        pay.rel = 'noopener noreferrer';
        actions.append(pay);
      }

      if (item.contact) {
        const contact = make('a', 'btn contact', item.contact_label || 'Email intake');
        contact.href = safeHref(item.contact);
        actions.append(contact);
      }

      if (actions.childElementCount) card.append(actions);
      if (item.note) card.append(make('p', 'fine', item.note));
      grid.append(card);
    }
  } catch (error) {
    grid.replaceChildren();
    const card = make('section', 'product');
    card.append(make('h2', '', 'Catalog unavailable'));
    card.append(make('p', 'desc', error.message));
    grid.append(card);
  }
}

window.addEventListener('DOMContentLoaded', loadCatalog);
