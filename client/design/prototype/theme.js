"use strict";
// Цвета — данные. Сервер не получает возможности исполнять CSS или JavaScript.
window.SpaceTheme = (() => {
  const storageKey = "space.design.branding.v1";
  const presets = {
    gruvbox: {
      name: "Gruvbox · по умолчанию",
      primary: "#076678",
      background: "#fbf1c7",
      surface: "#f9f5d7",
      text: "#3c3836",
    },
    forest: {
      name: "Лесной свет",
      primary: "#28614e",
      background: "#f6f5f0",
      surface: "#fffefa",
      text: "#253b34",
    },
    ocean: {
      name: "Тихий океан",
      primary: "#315d85",
      background: "#f2f5f9",
      surface: "#ffffff",
      text: "#27384c",
    },
    clay: {
      name: "Тёплая глина",
      primary: "#854c46",
      background: "#faf2eb",
      surface: "#fffbf7",
      text: "#48312f",
    },
    iris: {
      name: "Мягкий ирис",
      primary: "#625289",
      background: "#f5f2f9",
      surface: "#fffdfd",
      text: "#382f47",
    },
  };
  let state;
  try {
    state = JSON.parse(localStorage.getItem(storageKey)) || {};
  } catch {
    state = {};
  }
  const oldDefault =
    state.user &&
    ["primary", "background", "surface", "text"].every(
      (key) => state.user[key] === presets.forest[key],
    );
  if (!state.user || (oldDefault && !state.userCustomized))
    state.user = { ...presets.gruvbox };
  state.consents = state.consents || {};
  state.proposals = state.proposals || {};
  const save = () => {
    try {
      localStorage.setItem(storageKey, JSON.stringify(state));
    } catch {
      /* Настройки остаются в памяти текущего макета. */
    }
  };
  const rgb = (color) =>
    color
      .slice(1)
      .match(/../g)
      .map((v) => parseInt(v, 16));
  const mix = (a, b, weight) =>
    "#" +
    rgb(a)
      .map((v, i) =>
        Math.round(v * (1 - weight) + rgb(b)[i] * weight)
          .toString(16)
          .padStart(2, "0"),
      )
      .join("");
  const luminance = (color) =>
    rgb(color)
      .map((v) => {
        v /= 255;
        return v <= 0.04045 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4;
      })
      .reduce((sum, v, i) => sum + v * [0.2126, 0.7152, 0.0722][i], 0);
  const contrast = (a, b) => {
    const x = luminance(a),
      y = luminance(b);
    return (Math.max(x, y) + 0.05) / (Math.min(x, y) + 0.05);
  };
  function validate(palette) {
    if (!palette || typeof palette !== "object")
      return "Палитра отсутствует или имеет неверный формат.";
    if (
      !["primary", "background", "surface", "text"].every((key) =>
        /^#[0-9a-f]{6}$/i.test(palette[key] || ""),
      )
    )
      return "Нужны четыре цвета в формате #RRGGBB.";
    if (
      contrast(palette.text, palette.background) < 4.5 ||
      contrast(palette.text, palette.surface) < 4.5
    )
      return "Текст недостаточно контрастен к фону. Выберите более различимые цвета.";
    if (contrast(palette.primary, palette.surface) < 4.5)
      return "Основной цвет недостаточно контрастен к поверхности для кнопок и ссылок.";
    return "";
  }
  if (validate(state.user)) state.user = { ...presets.gruvbox };
  function tokens(palette, dark) {
    const gruvbox = ["primary", "background", "surface", "text"].every(
      (key) => palette[key] === presets.gruvbox[key],
    );
    if (dark) {
      return {
        "--bg": "#282828",
        "--panel": "#32302f",
        "--side": "#1d2021",
        "--line": "#504945",
        "--ink": "#ebdbb2",
        "--muted": "#bdae93",
        "--green": gruvbox ? "#fabd2f" : mix(palette.primary, "#ffffff", 0.68),
        "--soft": gruvbox ? "#3c3836" : mix(palette.primary, "#32302f", 0.8),
        "--sand": "#504945",
        "--accent": "#fe8019",
      };
    }
    if (gruvbox)
      return {
        "--bg": "#fbf1c7",
        "--panel": "#f9f5d7",
        "--side": "#f2e5bc",
        "--line": "#d5c4a1",
        "--ink": "#3c3836",
        "--muted": "#665c54",
        "--green": "#076678",
        "--soft": "#ebdbb2",
        "--sand": "#ebdbb2",
        "--accent": "#af3a03",
      };
    let side = mix(palette.background, palette.text, 0.03);
    if (contrast(palette.text, side) < 4.5) side = palette.background;
    let muted = palette.text;
    for (let weight = 0.25; weight >= 0; weight -= 0.05) {
      const candidate = mix(palette.text, palette.background, weight);
      if (
        [palette.background, palette.surface, side].every(
          (bg) => contrast(candidate, bg) >= 4.5,
        )
      ) {
        muted = candidate;
        break;
      }
    }
    let soft = mix(palette.surface, palette.primary, 0.1);
    if (contrast(palette.primary, soft) < 4.5) soft = palette.surface;
    let sand = mix(palette.surface, "#e0b875", 0.3);
    if (contrast(palette.text, sand) < 4.5) sand = palette.surface;
    return {
      "--bg": palette.background,
      "--panel": palette.surface,
      "--side": side,
      "--line": mix(palette.background, palette.text, 0.13),
      "--ink": palette.text,
      "--muted": muted,
      "--green": palette.primary,
      "--soft": soft,
      "--sand": sand,
    };
  }
  function proposal(server) {
    const value = state.proposals[server];
    return value && !validate(value.palette)
      ? value
      : {
          revision: 1,
          palette: { ...presets.clay },
          label: "Оформление пространства",
        };
  }
  function hash(value) {
    return JSON.stringify(value);
  }
  function consentValid(server) {
    const grant = state.consents[server];
    return !!grant?.enabled && grant.fingerprint === hash(proposal(server));
  }
  function apply(server, dark) {
    const user = validate(state.user) ? presets.gruvbox : state.user;
    for (const [key, value] of Object.entries(tokens(user, dark)))
      document.documentElement.style.setProperty(key, value);
    document.documentElement.style.setProperty(
      "--rail-bg",
      dark ? "#1d2021" : user.primary,
    );
    document.documentElement.style.setProperty(
      "--rail-ink",
      dark ? "#ebdbb2" : user.surface,
    );
    const selected =
      consentValid(server) && !validate(proposal(server).palette)
        ? proposal(server).palette
        : user;
    for (const element of [
      document.querySelector(".workspace"),
      document.querySelector("#sidebar"),
    ]) {
      if (!element) continue;
      for (const [key, value] of Object.entries(tokens(selected, dark)))
        element.style.setProperty(key, value);
    }
  }
  function swatches(palette) {
    return `<div class="theme-swatches">${["primary", "background", "surface", "text"].map((key) => `<span style="background:${palette[key]}" title="${palette[key]}"></span>`).join("")}</div>`;
  }
  function editor() {
    return `<div class="card"><h2>Мои цвета</h2><p>Ваша основа для приложения. Пространство может предложить другую палитру, но выбор остаётся за вами.</p><div class="theme-presets">${Object.entries(
      presets,
    )
      .map(
        ([key, p]) =>
          `<button class="theme-preset" data-action="user-palette" data-palette="${key}">${swatches(p)}<strong>${p.name}</strong></button>`,
      )
      .join(
        "",
      )}</div><form id="user-colors" class="stack"><div class="color-fields">${[
      ["primary", "Акцент"],
      ["background", "Фон"],
      ["surface", "Поверхность"],
      ["text", "Текст"],
    ]
      .map(
        ([key, label]) =>
          `<label class="field">${label}<input type="color" name="${key}" value="${state.user[key]}" aria-label="Мой цвет: ${label}"></label>`,
      )
      .join(
        "",
      )}</div><div id="palette-error" class="fineprint" role="alert"></div><button class="button secondary" type="submit">Сохранить мои цвета</button></form></div>`;
  }
  function agreement(server) {
    const p = proposal(server),
      enabled = consentValid(server);
    return `<div class="card" style="margin-top:20px"><div class="between"><h2>Оформление пространства</h2><span class="pill">${enabled ? "Разрешено" : "Моя тема"}</span></div><p>Этот сервер предлагает свою палитру. Согласие относится только к выбранному пространству и текущему варианту оформления.</p>${swatches(p.palette)}<p class="fineprint">Предложение ${p.revision} · ваши цвета не удаляются. Тёмная тема и настройки доступности остаются вашими.</p><button class="button ${enabled ? "secondary" : "primary"}" data-action="${enabled ? "revoke-theme" : "preview-theme"}">${enabled ? "Вернуть мои цвета" : "Посмотреть предложение"}</button></div>`;
  }
  function preview(server) {
    const p = proposal(server);
    return `<p>Предложение от выбранного пространства. Перед применением проверьте, нравится ли вам оформление.</p><div class="theme-preview" style="background:${p.palette.background};color:${p.palette.text};border-color:${mix(p.palette.text, p.palette.surface, 0.8)}"><h3>Так будет выглядеть ваше пространство</h3><p>Чат, разделы и панели получат эти цвета. Общая навигация между серверами останется вашей.</p><span class="button" style="background:${p.palette.primary};color:${p.palette.surface}">Пример кнопки</span></div>${swatches(p.palette)}<p class="fineprint">Это палитра светлого режима. Если включена тёмная тема, она сохранится, изменится только цветовой акцент. Сервер не может назначать произвольные стили, шрифты или анимации.</p><div class="modal-actions"><button class="button secondary" data-action="close">Оставить мою тему</button><button class="button primary" data-action="accept-theme">Разрешить этому пространству</button></div>`;
  }
  function admin(server) {
    const p = proposal(server);
    return `<div class="card" style="margin-top:24px"><h2>Предложить оформление участникам</h2><p>Владелец публикует палитру, а каждый участник решает, применять ли её. Изменение палитры требует нового согласия.</p>${swatches(p.palette)}<form id="server-colors" class="stack"><label class="field">Палитра пространства<select name="palette">${Object.entries(
      presets,
    )
      .map(
        ([key, value]) =>
          `<option value="${key}" ${value.primary === p.palette.primary ? "selected" : ""}>${value.name}</option>`,
      )
      .join(
        "",
      )}</select></label><button class="button" type="submit">Обновить предложение в макете</button><p class="fineprint">Текущий вариант: ${p.revision}. Согласие пользователей не подменяется настройкой владельца.</p></form></div>`;
  }
  return {
    presets,
    editor,
    agreement,
    preview,
    admin,
    apply,
    contrast,
    validate,
    useUser(key) {
      state.user = { ...presets[key] };
      state.userCustomized = true;
      save();
    },
    setUser(palette) {
      const error = validate(palette);
      if (error) return error;
      state.user = palette;
      state.userCustomized = true;
      save();
      return "";
    },
    accept(server) {
      if (validate(proposal(server).palette)) return false;
      state.consents[server] = {
        enabled: true,
        fingerprint: hash(proposal(server)),
      };
      save();
      return true;
    },
    revoke(server) {
      delete state.consents[server];
      save();
    },
    update(server, key) {
      const old = proposal(server);
      state.proposals[server] = {
        ...old,
        revision: old.revision + 1,
        palette: { ...presets[key] },
      };
      save();
    },
    consentValid,
  };
})();
