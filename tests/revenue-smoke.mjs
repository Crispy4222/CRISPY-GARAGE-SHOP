import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';

const catalog = JSON.parse(await readFile(new URL('../docs/catalog.json', import.meta.url), 'utf8'));
const index = await readFile(new URL('../docs/index.html', import.meta.url), 'utf8');
const app = await readFile(new URL('../docs/app.js', import.meta.url), 'utf8');

const service = catalog.find((item) => item.title === 'CRISPY Phone Cleanup + Tune-Up');
assert.ok(service, 'paid cleanup service must exist');
assert.equal(service.price, '$15');
assert.equal(service.tip, 'https://cash.app/$Lcrispy');
assert.match(service.contact, /^mailto:CRISPY@crispy-creations\.com/i);
assert.match(service.note, /manual/i);

const freeTools = catalog.find((item) => item.title === 'CRISPY Phone Cleanup Duo — Free Tools');
assert.ok(freeTools, 'free inspectable scripts must remain a separate catalog item');
assert.equal(freeTools.tip, undefined, 'free tools must not masquerade as a paid product');
assert.equal(freeTools.links.length, 2);

assert.match(index, /\$15 manual cleanup \+ tune-up/i);
assert.match(index, /automatic paid delivery is not connected yet/i);
assert.match(app, /url\.protocol === 'mailto:'/);

console.log('revenue smoke: PASS');
