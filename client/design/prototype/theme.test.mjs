import { readFile } from "node:fs/promises";
import { runInNewContext } from "node:vm";
import assert from "node:assert/strict";
const styles = new Map();
const element = (name) => ({
  style: { setProperty: (key, value) => styles.set(`${name}:${key}`, value) },
});
const nodes = {
  root: element("root"),
  ".workspace": element("space"),
  "#sidebar": element("sidebar"),
};
const values = new Map();
const context = {
  window: {},
  document: {
    documentElement: nodes.root,
    querySelector: (selector) => nodes[selector],
  },
  localStorage: {
    getItem: (key) => values.get(key),
    setItem: (key, value) => values.set(key, value),
  },
};
runInNewContext(
  await readFile(new URL("theme.js", import.meta.url), "utf8"),
  context,
);
const theme = context.window.SpaceTheme;
for (const palette of Object.values(theme.presets))
  assert.equal(theme.validate(palette), "");
assert.notEqual(
  theme.validate({
    primary: "#eeeeee",
    background: "#ffffff",
    surface: "#ffffff",
    text: "#eeeeee",
  }),
  "",
);
theme.useUser("ocean");
theme.apply("a.example", false);
assert.equal(styles.get("root:--green"), "#315d85");
assert.equal(styles.get("space:--green"), "#315d85");
assert.equal(theme.consentValid("a.example"), false);
theme.accept("a.example");
theme.apply("a.example", false);
assert.equal(styles.get("space:--green"), "#854c46");
assert.equal(styles.get("root:--green"), "#315d85");
theme.apply("b.example", false);
assert.equal(styles.get("space:--green"), "#315d85");
theme.update("a.example", "forest");
assert.equal(theme.consentValid("a.example"), false);
theme.apply("a.example", false);
assert.equal(styles.get("space:--green"), "#315d85");
theme.accept("a.example");
theme.apply("a.example", true);
assert.equal(styles.get("space:--bg"), "#282828");
theme.revoke("a.example");
assert.equal(theme.consentValid("a.example"), false);
process.stdout.write(
  "Палитры: контраст, согласие, область сервера, обновление и тёмный режим — успешно.\n",
);
