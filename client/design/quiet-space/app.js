"use strict";
const $ = (s) => document.querySelector(s);
const icons = {
  home: "M3 10 12 3l9 7M5 9v12h5v-7h4v7h5V9",
  plus: "M12 5v14M5 12h14",
  search: "M21 21l-5-5M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0",
  sun: "M12 2v2m0 16v2M2 12h2m16 0h2M5 5l1 1m12 12 1 1M5 19l1-1M18 6l1-1M16 12a4 4 0 1 1-8 0 4 4 0 0 1 8 0",
  settings:
    "M12 8a4 4 0 1 0 0 8 4 4 0 0 0 0-8M9 3h6l1 3 3 1 2 5-2 5-3 1-1 3H9l-1-3-3-1-2-5 2-5 3-1Z",
  chevron: "m8 10 4 4 4-4",
  bookmark: "M6 3h12v18l-6-4-6 4Z",
  panel: "M3 4h18v16H3ZM15 4v16",
  close: "m6 6 12 12M6 18 18 6",
  upload: "M12 16V3m-5 5 5-5 5 5M4 15v6h16v-6",
  arrow: "M12 19V5m-6 6 6-6 6 6",
  clip: "m8 13 7-7a3 3 0 0 1 4 4l-9 9a5 5 0 0 1-7-7l9-9",
  menu: "M4 6h16M4 12h16M4 18h16",
};
const icon = (n) =>
  `<svg viewBox="0 0 24 24" aria-hidden="true"><path d="${icons[n] || icons.home}"/></svg>`;
function decorate() {
  document
    .querySelectorAll("[data-icon]")
    .forEach((el) => (el.innerHTML = icon(el.dataset.icon)));
}
const esc = (s) =>
  String(s).replace(
    /[&<>"']/g,
    (c) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[
        c
      ],
  );
const initial = {
  channels: ["Чатик", "Идеи и находки", "Планы на выходные"],
  messages: [
    {
      id: 1,
      channel: "Чатик",
      author: "Аня",
      text: "Здесь можно просто быть. Делитесь тем, что порадовало сегодня — даже если это всего лишь хороший кофе ☕",
      time: "10:24",
    },
    {
      id: 2,
      channel: "Чатик",
      author: "Вы",
      text: "А я наконец собрал нас в одном месте. Без лишнего шума, только свои.",
      time: "10:26",
    },
    {
      id: 3,
      channel: "Чатик",
      author: "Миша",
      text: "Вот это мне нравится. Давайте начнём с маленькой традиции: одна хорошая находка в день ✨",
      time: "10:28",
    },
  ],
  saved: [],
  liked: [],
  light: false,
  glass: true,
  name: "Моё пространство",
  open: false,
};
let state = structuredClone(initial);
try {
  const stored = JSON.parse(localStorage.getItem("space.quiet.v1"));
  if (
    stored &&
    Array.isArray(stored.channels) &&
    Array.isArray(stored.messages)
  )
    state = { ...state, ...stored };
} catch {}
let view = "chat",
  channel = state.channels[0],
  pending = [],
  drafts = {},
  toastTimer;
function persist() {
  try {
    localStorage.setItem("space.quiet.v1", JSON.stringify(state));
  } catch {
    toast("Не удалось сохранить: хранилище браузера недоступно");
  }
}
function toast(text) {
  $("#toast").textContent = text;
  $("#toast").classList.add("show");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => $("#toast").classList.remove("show"), 2800);
}
function applyTheme() {
  document.body.classList.toggle("light", state.light);
  document.body.classList.toggle("no-glass", !state.glass);
  $(".space-heading strong").textContent = state.name;
}
function channels() {
  $("#channels").innerHTML = state.channels
    .map(
      (name, i) =>
        `<button class="nav-row ${view === "chat" && channel === name ? "selected" : ""}" data-channel="${esc(name)}"><span class="hash">#</span>${esc(name)}${i === 0 ? '<span class="badge">3</span>' : ""}</button>`,
    )
    .join("");
  $("#saved-count").textContent = state.saved.length || "";
  document
    .querySelectorAll("[data-view]")
    .forEach((b) => b.classList.toggle("selected", b.dataset.view === view));
}
function message(m) {
  const own = m.author === "Вы";
  return `<article id="message-${m.id}" class="message ${own ? "own" : ""}">${own ? "" : `<div class="avatar ${m.author === "Миша" ? "lilac" : ""}">${esc(m.author[0])}</div>`}<div class="message-body">${own ? "" : `<div class="message-meta">${esc(m.author)}<time>${esc(m.time)}</time></div>`}<p>${esc(m.text).replace(/\n/g, "<br>")}</p>${(m.files || []).map((f) => `<div class="attachment">${icon("clip")}${esc(f.name)} <small>${Math.max(1, Math.round(f.size / 1024))} КБ</small></div>`).join("")}<div class="message-actions"><button class="reaction ${state.liked.includes(m.id) ? "on" : ""}" data-like="${m.id}" aria-label="Нравится" aria-pressed="${state.liked.includes(m.id)}">♡ ${state.liked.includes(m.id) ? 1 : ""}</button><button class="save ${state.saved.includes(m.id) ? "is-saved" : ""}" data-save="${m.id}" aria-pressed="${state.saved.includes(m.id)}" aria-label="${state.saved.includes(m.id) ? "Убрать из избранного" : "Добавить в избранное"}" title="${state.saved.includes(m.id) ? "Убрать из избранного" : "Добавить в избранное"}">${icon("bookmark")}</button>${own ? `<time class="fine">${esc(m.time)} · локально</time>` : ""}</div></div></article>`;
}
let composerResize;
function render() {
  composerResize?.disconnect();
  $(".favorite-preview")?.remove();
  channels();
  $("#title").textContent =
    { home: "Обзор", settings: "Управление", saved: "Сохранённое" }[view] ||
    channel;
  $("#info").hidden = true;
  setMobileMenu(false);
  if (view === "chat") renderChat();
  else if (view === "settings") renderSettings();
  else if (view === "saved")
    $("#content").innerHTML =
      `<section class="page"><div class="eyebrow">ПОД РУКОЙ</div><h1>То, что хочется оставить</h1>${
        state.messages
          .filter((m) => state.saved.includes(m.id))
          .map(message)
          .join("") ||
        '<p class="empty">Сохраните сообщение кнопкой закладки в чате.</p>'
      }</section>`;
  else renderHome();
  decorate();
}
function renderChat() {
  const list = state.messages.filter((m) => m.channel === channel);
  $("#content").innerHTML =
    `<div class="chat-area"><div class="chat-scroll"><div class="conversation"><div class="intro"><div class="symbol">✧</div><h1>${channel === state.channels[0] ? "Хорошо, что вы здесь." : esc(channel)}</h1><p>${channel === state.channels[0] ? "Разговоры, из которых складывается близость." : "Место для нового разговора."}</p></div><div class="date">${list.length ? "Сегодня · демонстрационный разговор" : "Начало вашей истории"}</div><div id="messages">${list.map(message).join("")}</div></div></div>${favoriteMarkers(list)}</div><div class="composer-wrap"><form class="composer" id="compose"><div id="attachments"></div><textarea id="message" aria-label="Сообщение" placeholder="Что у вас нового?" rows="2"></textarea><div class="composer-footer"><button type="button" data-action="attach" title="Прикрепить файл">${icon("plus")}</button><span class="hint">Можно просто перетащить файл сюда</span><button class="send" type="submit" title="Отправить сообщение">${icon("arrow")}</button></div></form><p class="below">Ваш маленький уголок большого мира</p></div>`;
  const composerWrap = $('.composer-wrap');
  const syncComposerHeight = () => {
    $('#content').style.setProperty('--composer-height', `${composerWrap.offsetHeight}px`);
  };
  syncComposerHeight();
  composerResize = new ResizeObserver(syncComposerHeight);
  composerResize.observe(composerWrap);
  bindFavoritePreviews();
  $("#message").value = drafts[channel] || "";
  renderAttachments();
  $("#message").oninput = () => {
    drafts[channel] = $("#message").value;
    updateSend();
  };
  $("#message").onkeydown = (e) => {
    if (e.key === "Enter" && !e.shiftKey && !e.isComposing) {
      e.preventDefault();
      send();
    }
  };
  $("#compose").onsubmit = (e) => {
    e.preventDefault();
    send();
  };
}
function updateSend() {
  if ($(".send"))
    $(".send").disabled = !$("#message").value.trim() && !pending.length;
}
function renderAttachments() {
  if (!$("#attachments")) return;
  $("#attachments").innerHTML = pending
    .map(
      (f, i) =>
        `<span class="attachment">${icon("clip")}${esc(f.name)}<button type="button" data-remove="${i}" title="Убрать вложение">${icon("close")}</button></span>`,
    )
    .join("");
  updateSend();
}
function send() {
  const text = $("#message").value.trim();
  if (!text && !pending.length) return;
  state.messages.push({
    id: Date.now(),
    channel,
    author: "Вы",
    text,
    files: pending.map((f) => ({ name: f.name, size: f.size })),
    time: new Date().toLocaleTimeString("ru", {
      hour: "2-digit",
      minute: "2-digit",
    }),
  });
  pending = [];
  drafts[channel] = "";
  persist();
  render();
  $(".chat-scroll").scrollTop = $(".chat-scroll").scrollHeight;
  $("#message").focus();
}
function renderHome() {
  $("#content").innerHTML =
    `<section class="page"><div class="eyebrow">ВАШ SPACE</div><h1>Свои люди. Своё место.</h1><p>Вернитесь к разговору или начните что-то новое.</p><div class="cards"><button class="card" data-channel="${esc(state.channels[0])}"><span class="symbol">✧</span><span class="arrow">↗</span><h3>${esc(state.name)}</h3><p>${state.channels.length} канала · 3 участника<br>Разговоры и маленькие открытия</p><small>Продолжить общение →</small></button><button class="card" data-action="add"><span class="symbol">＋</span><h3>Ещё одно место для своих</h3><p>Для семьи, друзей или вашей команды.<br>Всё важное — рядом.</p><small>Добавить пространство →</small></button></div><div class="section-label">НЕДАВНИЕ РАЗГОВОРЫ</div>${state.channels.map((c) => `<button class="nav-row" data-channel="${esc(c)}"><span class="hash">#</span>${esc(c)}<span style="margin-left:auto">→</span></button>`).join("")}</section>`;
}
function renderSettings() {
  $("#content").innerHTML =
    `<section class="page"><div class="eyebrow">ПРОСТОЕ УПРАВЛЕНИЕ</div><h1>Пусть будет по-вашему.</h1><p>Настройки этого демонстрационного пространства.</p><label class="setting"><div>Название пространства<p>Так его видят ваши участники</p></div><input id="space-name" type="text" maxlength="50" value="${esc(state.name)}"></label><label class="setting"><div>Светлая тема<p>Мягкие бумажные оттенки вместо графита</p></div><input type="checkbox" id="light-setting" ${state.light ? "checked" : ""}></label><label class="setting"><div>Матовое стекло<p>Прозрачность и размытие плавающих панелей</p></div><input type="checkbox" id="glass-setting" ${state.glass ? "checked" : ""}></label><label class="setting"><div>Открытая регистрация<p>Демонстрация настройки доступа</p></div><input type="checkbox" id="open-setting" ${state.open ? "checked" : ""}></label><div class="setting"><div>Каналы<p>Разделяйте разговоры по темам</p></div><button class="wide" data-action="channel">Добавить канал</button></div><p class="fine">Изменения сохраняются только в этом браузере.</p><button class="wide" data-action="save-settings">Сохранить настройки</button></section>`;
}
function modal(html) {
  $("#modal-body").innerHTML = html;
  $("#modal").showModal();
  decorate();
}
function search() {
  modal(
    '<h2>Найти в пространстве</h2><input type="search" id="query" placeholder="Канал или текст сообщения" aria-label="Поиск"><div id="results"></div>',
  );
  const searchResults = () => {
    const q = $("#query").value.toLowerCase().trim();
    $("#results").innerHTML =
      state.channels
        .filter((c) => c.toLowerCase().includes(q))
        .map(
          (c) =>
            `<button class="nav-row" data-channel="${esc(c)}"># ${esc(c)}</button>`,
        )
        .join("") +
      (q
        ? state.messages
            .filter((m) => m.text.toLowerCase().includes(q))
            .slice(-8)
            .map(
              (m) =>
                `<button class="nav-row" data-channel="${esc(m.channel)}">${esc(m.author)}: ${esc(m.text.slice(0, 70))}</button>`,
            )
            .join("")
        : "");
    if (!$("#results").textContent)
      $("#results").textContent = "Ничего не найдено";
  };
  $("#query").oninput = searchResults;
  searchResults();
  $("#query").focus();
}
const actions = {
  theme() {
    state.light = !state.light;
    applyTheme();
    persist();
    if (view === "settings") render();
  },
  info() {
    setMobileMenu(false);
    $("#info").hidden = !$("#info").hidden;
  },
  "menu-close"() { setMobileMenu(false); },
  menu() {
    setMobileMenu(!$(".sidebar").classList.contains("open"));
  },
  close() {
    $("#modal").close();
  },
  search,
  attach() {
    $("#file-input").click();
  },
  channel() {
    modal(
      '<h2>Новый разговор</h2><p>Дайте каналу понятное название.</p><form id="new-channel"><input name="name" type="text" maxlength="40" placeholder="Например, Музыка" required aria-label="Название канала"><button class="wide">Создать канал</button></form>',
    );
    $("#new-channel").onsubmit = (e) => {
      e.preventDefault();
      const name = new FormData(e.target).get("name").trim();
      if (!name) return;
      if (state.channels.includes(name)) {
        toast("Такой канал уже есть");
        return;
      }
      state.channels.push(name);
      channel = name;
      view = "chat";
      persist();
      $("#modal").close();
      render();
    };
  },
  add() {
    modal(
      '<h2>Место для нового</h2><p>В этом варианте можно создать локальный канал и попробовать общение. Подключение новых серверов появится при переносе во Flutter.</p><button class="wide" data-action="channel">Создать канал</button>',
    );
  },
  "save-settings"() {
    state.name = $("#space-name").value.trim() || "Моё пространство";
    state.light = $("#light-setting").checked;
    state.glass = $("#glass-setting").checked;
    state.open = $("#open-setting").checked;
    persist();
    applyTheme();
    toast("Настройки сохранены в браузере");
  },
};
document.addEventListener("click", (e) => {
  const b = e.target.closest("button");
  if (!b) return;
  if (b.dataset.jump) {
    const target = document.getElementById(`message-${b.dataset.jump}`);
    target?.scrollIntoView({behavior: matchMedia('(prefers-reduced-motion: reduce)').matches ? 'instant' : 'smooth', block: 'center'});
    target?.setAttribute('tabindex', '-1');
    target?.focus({preventScroll: true});
    $('.favorite-preview')?.remove();
    return;
  }
  if (b.dataset.action) {
    actions[b.dataset.action]?.();
    return;
  }
  if (b.dataset.channel) {
    channel = b.dataset.channel;
    view = "chat";
    pending = [];
    $("#modal").close();
    render();
    return;
  }
  if (b.dataset.view) {
    view = b.dataset.view;
    render();
    return;
  }
  for (const [key, field] of [
    ["save", "saved"],
    ["like", "liked"],
  ]) {
    if (b.dataset[key]) {
      const id = Number(b.dataset[key]);
      state[field] = state[field].includes(id)
        ? state[field].filter((x) => x !== id)
        : [...state[field], id];
      persist();
      const scroll = $(".chat-scroll")?.scrollTop;
      render();
      if (scroll !== undefined) $(".chat-scroll").scrollTop = scroll;
      return;
    }
  }
  if (b.dataset.remove !== undefined) {
    pending.splice(Number(b.dataset.remove), 1);
    renderAttachments();
  }
});
function addFiles(files) {
  if (view !== "chat") {
    toast("Откройте канал, чтобы приложить файлы");
    return;
  }
  pending.push(...Array.from(files).slice(0, 10 - pending.length));
  renderAttachments();
  toast("Добавлены вложения. В прототипе сохраняются только названия файлов.");
}
$("#file-input").onchange = (e) => {
  addFiles(e.target.files);
  e.target.value = "";
};
let dragDepth = 0;
document.addEventListener("dragenter", (e) => {
  if (!e.dataTransfer.types.includes("Files")) return;
  e.preventDefault();
  dragDepth++;
  if (view === "chat") $("#dropzone").classList.add("show");
});
document.addEventListener("dragover", (e) => e.preventDefault());
document.addEventListener("dragleave", () => {
  dragDepth--;
  if (dragDepth <= 0) $("#dropzone").classList.remove("show");
});
document.addEventListener("drop", (e) => {
  e.preventDefault();
  dragDepth = 0;
  $("#dropzone").classList.remove("show");
  addFiles(e.dataTransfer.files);
});
document.addEventListener("keydown", (e) => {
  if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === "k") {
    e.preventDefault();
    if (!$("#modal").open) search();
  }
  if (e.key === "Escape") {
    $("#info").hidden = true;
    setMobileMenu(false);
  }
});
applyTheme();
render();

function favoriteMarkers(messages) {
  const favorites = messages.filter(m => state.saved.includes(m.id));
  if (!favorites.length) return '';
  return `<nav class="favorite-markers" aria-label="Избранные сообщения">${favorites.map(m => `<button class="favorite-marker ${m.author === 'Вы' ? 'mine' : ''}" data-jump="${m.id}" aria-label="Избранное: ${esc(m.author)}. ${esc(m.text)}"><span></span></button>`).join('')}</nav>`;
}
function bindFavoritePreviews() {
  let closing;
  const hide = () => {
    clearTimeout(closing);
    closing = setTimeout(() => {
      if (document.activeElement?.closest('.favorite-preview, .favorite-marker')) return;
      $('.favorite-preview')?.remove();
      document.querySelectorAll('.favorite-marker').forEach(b => b.style.removeProperty('--marker-width'));
      document.querySelectorAll('.favorite-marker.expanded').forEach(b => b.classList.remove('expanded'));
    }, 150);
  };
  const markers = [...document.querySelectorAll('.favorite-marker')];
  markers.forEach((marker, index) => {
    const show = () => {
      clearTimeout(closing);
      $('.favorite-preview')?.remove();
      document.querySelectorAll('.favorite-marker.expanded').forEach(b => b.classList.remove('expanded'));
      marker.classList.add('expanded');
      markers.forEach((item, position) => {
        const distance = Math.abs(position - index);
        item.style.setProperty('--marker-width', `${Math.max(8, 38 - distance * 9)}px`);
      });
      const m = state.messages.find(m => String(m.id) === marker.dataset.jump);
      const card = document.createElement('section');
      card.className = `favorite-preview ${m.author === 'Вы' ? 'mine' : ''}`;
      card.setAttribute('aria-label', 'Избранное сообщение');
      const previewText = m.text || (m.files || []).map(f => f.name).join(', ');
      const [heading, ...remaining] = previewText.split('\n').filter(line => line.trim());
      const excerpt = remaining.join('\n') || previewText;
      card.innerHTML = `<div class="favorite-preview-header"><button class="favorite-title" data-jump="${m.id}" title="${esc(heading || m.author)}">${esc(heading || m.author)}</button><button class="save is-saved" data-save="${m.id}" aria-label="Убрать из избранного" title="Убрать из избранного">${icon('bookmark')}</button></div><button class="favorite-excerpt" data-jump="${m.id}" aria-label="Перейти к сообщению"><span>${esc(excerpt)}</span></button>`;
      document.body.append(card);
      const rect = marker.getBoundingClientRect();
      card.style.left = `${Math.min(rect.right + 14, innerWidth - card.offsetWidth - 8)}px`;
      card.style.top = `${Math.max(8, Math.min(rect.top + rect.height / 2 - card.offsetHeight / 2, innerHeight - card.offsetHeight - 8))}px`;
      card.onpointerenter = () => clearTimeout(closing);
      card.onpointerleave = hide;
      card.onfocusin = () => clearTimeout(closing);
      card.onfocusout = hide;
    };
    marker.onpointerenter = show;
    marker.onpointerleave = hide;
    marker.onfocus = show;
    marker.onblur = hide;
    marker.onkeydown = e => {
      if (e.key === 'ArrowRight') {
        e.preventDefault();
        $('.favorite-preview button')?.focus();
      }
    };
  });
}
document.addEventListener('keydown', e => {
  if (e.key === 'Escape') $('.favorite-preview')?.remove();
});

function setMobileMenu(open) {
  const compact = matchMedia('(max-width: 720px)').matches;
  const showing = open && compact;
  $('.sidebar').classList.toggle('open', showing);
  document.body.classList.toggle('menu-open', showing);
  $('.mobile-menu').setAttribute('aria-expanded', String(showing));
  $('main').inert = showing;
  $('.sidebar').inert = compact && !showing;
  if (showing) $('.mobile-tools button').focus();
  else if ($('.sidebar').contains(document.activeElement) && compact) $('.mobile-menu').focus();
}
matchMedia('(max-width: 720px)').addEventListener('change', () => setMobileMenu(false));
let menuTouch;
document.addEventListener('touchstart', e => {
  if (e.touches.length !== 1 || !matchMedia('(max-width: 720px)').matches || $('#modal').open) return;
  const t = e.touches[0];
  const open = $('.sidebar').classList.contains('open');
  menuTouch = (open || t.clientX < 24) ? {x:t.clientX, y:t.clientY, open} : null;
}, {passive:true});
document.addEventListener('touchend', e => {
  if (!menuTouch) return;
  const t = e.changedTouches[0], dx=t.clientX-menuTouch.x, dy=t.clientY-menuTouch.y;
  if (Math.abs(dx)>70 && Math.abs(dx)>Math.abs(dy)*1.5) {
    if (!menuTouch.open && dx>0) setMobileMenu(true);
    if (menuTouch.open && dx<0) setMobileMenu(false);
  }
  menuTouch=null;
}, {passive:true});
document.addEventListener('touchcancel', () => { menuTouch=null; }, {passive:true});
document.addEventListener('keydown', e => {
  if (e.key !== 'Tab' || !document.body.classList.contains('menu-open') || $('#modal').open) return;
  const buttons = [...$('.sidebar').querySelectorAll('button')].filter(b => b.getClientRects().length && !b.disabled);
  const first=buttons[0], last=buttons[buttons.length-1];
  if (e.shiftKey && document.activeElement===first) { e.preventDefault(); last.focus(); }
  else if (!e.shiftKey && document.activeElement===last) { e.preventDefault(); first.focus(); }
});
