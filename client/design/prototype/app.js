"use strict";
const paths = {
  chat: "M4 5h16v12H9l-5 4V5Z",
  forum: "M4 4h16v13H8l-4 4V4Zm4 4h8M8 12h6",
  feed: "M5 3h14v18H5V3Zm4 4h6M9 11h6M9 15h4",
  home: "m3 10 9-7 9 7M5 9v12h5v-7h4v7h5V9",
  hash: "M9 3 7 21M17 3l-2 18M4 8h17M3 16h17",
  mic: "M9 5a3 3 0 0 1 6 0v7a3 3 0 0 1-6 0V5Zm-4 7a7 7 0 0 0 14 0M12 19v3M8 22h8",
  video: "M3 5h12v14H3V5Zm12 6 6-4v10l-6-4",
  stage: "M3 20h18M5 20v-9h14v9M9 4a3 3 0 1 0 6 0 3 3 0 0 0-6 0",
  live: "M4 7h16v14H4V7Zm4-5 4 5 4-5m-6 5 5 3-5 3V10Z",
  search: "m21 21-5-5M3 10a7 7 0 1 0 14 0 7 7 0 0 0-14 0",
  bell: "M6 9a6 6 0 0 1 12 0v7l3 2H3l3-2V9Zm4 12h4",
  moon: "M20 15A9 9 0 0 1 9 3a9 9 0 1 0 11 12Z",
  sun: "M12 3V1M12 23v-2M3 12H1m22 0h-2M4 4 3 3m18 18-1-1M4 20l-1 1M20 4l1-1M7 12a5 5 0 1 0 10 0 5 5 0 0 0-10 0",
  plus: "M12 5v14M5 12h14",
  arrow: "M4 12h16m-6-6 6 6-6 6",
  send: "m3 3 19 9-19 9 4-9-4-9Zm4 9h15",
  smile: "M3 12a9 9 0 1 0 18 0 9 9 0 0 0-18 0m4 3a6 6 0 0 0 10 0M8 8h1m6 0h1",
  clip: "m8 13 6-6a3 3 0 0 1 4 4l-8 8a5 5 0 0 1-7-7l9-9",
  leaf: "M20 3C8 1 2 8 5 16s16 4 15-13ZM3 21l13-13",
  users:
    "M8 4a4 4 0 1 0 0 8 4 4 0 0 0 0-8M1 21v-3a7 7 0 0 1 14 0v3m1-17a4 4 0 0 1 0 8m2 3a5 5 0 0 1 5 5",
  user: "M8 6a4 4 0 1 0 8 0 4 4 0 0 0-8 0M3 22v-3a9 9 0 0 1 18 0v3",
  shield: "M12 2 3 6v6c0 5 9 10 9 10s9-5 9-10V6l-9-4Zm-5 10 3 3 7-7",
  key: "M3 8a5 5 0 1 0 10 0A5 5 0 0 0 3 8Zm9 3 9 9m-4-4 3-3m-6 0 3-3",
  settings: "M4 6h16M4 12h16M4 18h16M8 3v6m8 0v6m-6 0v6",
  bookmark: "M6 3h12v19l-6-4-6 4V3Z",
  close: "m6 6 12 12M6 18 18 6",
  menu: "M4 6h16M4 12h16M4 18h16",
  more: "M4 12h1m6 0h1m6 0h1",
  check: "m4 12 5 5L20 6",
  monitor: "M3 3h18v14H3V3Zm9 14v5M7 22h10",
  phone: "M7 2h10v20H7V2Zm4 17h2",
  play: "m8 4 12 8-12 8V4Z",
  hand: "M7 12V4a2 2 0 0 1 4 0v8-10a2 2 0 0 1 4 0v10-7a2 2 0 0 1 4 0v10c0 9-11 9-14 4l-3-5a2 2 0 0 1 3-2l2 3",
  exit: "M10 3H3v18h7m3-9h9m-4-4 4 4-4 4",
  copy: "M8 8h13v13H8V8ZM4 16H2V2h14v2",
  volume: "m3 9 5 0 5-5v16l-5-5H3V9Zm14-2a8 8 0 0 1 0 10",
  flower: "M12 7C2-5 1 12 7 12c-12 10 5 11 5 5 10 12 11-5 5-5 12-10-5-11-5-5Z",
  qr: "M2 2h7v7H2V2Zm13 0h7v7h-7V2ZM2 15h7v7H2v-7Zm13 0h3v3h4v4h-7v-7",
};
const icon = (name) =>
  `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="${paths[name] || paths.chat}"/></svg>`;
const escapeHTML = (value) =>
  String(value).replace(
    /[&<>"']/g,
    (c) =>
      ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[
        c
      ],
  );
const $ = (selector) => document.querySelector(selector);
const people = [
  {
    name: "Аня Миронова",
    initials: "АМ",
    color: "a2",
    role: "Дизайнер · хозяйка пространства",
  },
  { name: "Марк Лисов", initials: "МЛ", color: "a4", role: "Иллюстратор" },
  {
    name: "Соня Белова",
    initials: "СБ",
    color: "a3",
    role: "Делает красивые вещи",
  },
  { name: "Виталий", initials: "В", color: "", role: "Это вы" },
  { name: "Лев Орлов", initials: "ЛО", color: "a5", role: "Архитектор" },
];
const avatar = (person, size = "") =>
  `<span class="avatar ${person.color || ""} ${size}" aria-hidden="true">${escapeHTML(person.initials)}</span>`;
const initialMessages = [
  {
    id: 1,
    person: 0,
    time: "10:24",
    text: "Доброе утро, мастерская! 🌿\nСегодня хочется чуть меньше спешить и чуть больше замечать. Что вдохновляет вас на этой неделе?",
    reactions: [
      ["🌿", 5],
      ["🤍", 3],
    ],
  },
  {
    id: 2,
    person: 1,
    time: "10:28",
    text: "Выбрался за город и наконец-то взял с собой скетчбук. В итоге два часа рисовал один и тот же холм — и это были прекрасные два часа.",
    art: true,
    reactions: [["✨", 7]],
    replies: 2,
  },
  {
    id: 3,
    person: 2,
    time: "10:32",
    text: "@Марк невероятные цвета! Забираю это настроение в свой новый проект.",
    reactions: [["🤍", 2]],
  },
  {
    id: 4,
    person: 0,
    time: "10:35",
    text: "Кстати, в 19:00 собираемся в гостиной. Без повестки: чай, идеи и немного разговоров. Заходите, если будет настроение ☕",
    reactions: [
      ["☕", 4],
      ["🙌", 2],
    ],
  },
];
function saved(key, fallback) {
  try {
    return JSON.parse(localStorage.getItem(`space.design.${key}`)) ?? fallback;
  } catch {
    return fallback;
  }
}
const state = {
  view: "chat",
  space: 0,
  theme: saved("theme", "dark"),
  quiet: saved("quiet", false),
  compact: saved("compact", false),
  messages: saved("messages", initialMessages),
  posts: saved("posts", []),
  bookmarks: saved("bookmarks", []),
  threads: saved("threads", {}),
  reply: null,
  call: null,
  mic: false,
  camera: false,
  filter: "all",
  notificationsRead: false,
  persona: saved("persona", "Виталий"),
  disabledViews: saved("disabledViews", []),
};
state.notify = saved("notify", { answers: true, events: true, all: false });
state.phoneRevoked = saved("phoneRevoked", false);
state.eventSaved = saved("eventSaved", false);
const spaces = [
  {
    name: "Лесная мастерская",
    symbol: "leaf",
    domain: "forest.example.invalid",
    count: "24 участника",
  },
  {
    name: "Читаем вместе",
    symbol: "bookmark",
    domain: "books.example.invalid",
    count: "18 участников",
  },
  {
    name: "Небольшая команда",
    symbol: "flower",
    domain: "team.example.invalid",
    count: "8 участников",
  },
];
const views = {
  home: ["Обзор", "home"],
  chat: ["Общий чат", "hash"],
  forum: ["Обсуждения", "forum"],
  feed: ["Вдохновение", "feed"],
  rooms: ["Комнаты", "volume"],
  voice: ["Гостиная", "mic"],
  video: ["Видео-встреча", "video"],
  stage: ["Сцена", "stage"],
  live: ["Прямой эфир", "live"],
  identity: ["Моя идентичность", "shield"],
  settings: ["Настройки", "settings"],
  admin: ["Управление пространством", "settings"],
};
function persist(key, value) {
  try {
    localStorage.setItem(`space.design.${key}`, JSON.stringify(value));
  } catch {
    toast("Браузер не разрешил сохранить настройки.");
  }
}
function toast(text) {
  $("#toast").textContent = text;
  $("#toast").classList.add("visible");
  clearTimeout(toast.timer);
  toast.timer = setTimeout(() => $("#toast").classList.remove("visible"), 3500);
}
function applyPreferences() {
  document.body.classList.toggle("dark", state.theme === "dark");
  document.body.classList.toggle("compact", state.compact);
  $("#theme-button").innerHTML = icon(state.theme === "dark" ? "sun" : "moon");
  window.SpaceTheme.apply(spaces[state.space].domain, state.theme === "dark");
}
function renderNavigation() {
  $("#spaces").innerHTML =
    `<button class="brand" data-view="home" aria-label="Space, обзор">s.</button><div class="rail-separator"></div>${spaces.map((s, i) => `<button class="space-icon ${i === state.space ? "active" : ""}" data-space="${i}" aria-label="${escapeHTML(s.name)}" title="${escapeHTML(s.name)}">${icon(s.symbol)}</button>`).join("")}<button class="space-icon" data-action="add-space" aria-label="Добавить пространство">${icon("plus")}</button><div class="rail-bottom"><button class="space-icon" data-view="identity" aria-label="Моя идентичность">${icon("user")}</button></div>`;
  const item = (view, extra = "") =>
    `<button class="nav-item ${state.view === view ? "active" : ""}" data-view="${view}" ${state.disabledViews.includes(view) ? "disabled" : ""}>${icon(views[view][1])}<span>${views[view][0]}</span>${extra}</button>`;
  $("#sidebar").innerHTML =
    `<div class="space-cover"><span class="sun"></span></div><div class="between"><span class="space-name">${escapeHTML(spaces[state.space].name)}</span><button class="icon" data-action="space-menu" aria-label="Меню пространства">${icon("more")}</button></div><div class="space-meta">${icon("shield")} Независимое пространство</div><button class="invite" data-action="invite">${icon("plus")} Пригласить своих</button>${item("home")}<div class="nav-group overline">Общение</div>${item("chat", '<span class="count">3</span>')}${item("forum")}${item("feed")}<div class="nav-group overline">Встречи <span>+</span></div>${item("voice", '<span class="tiny-live"></span>')}${item("video")}${item("stage")}${item("live")}<div class="sidebar-bottom">${item("settings")}<button class="me" data-view="identity">${avatar({ initials: "В" })}<span><strong>${escapeHTML(state.persona)}</strong><br><small class="muted">Ваш профиль здесь</small></span><span class="spacer"></span>${icon("settings")}</button><p class="fineprint" style="margin-top:14px">Интерактивный прототип · все данные демонстрационные</p></div>`;
  const bottom = [
    ["home", "Обзор"],
    ["chat", "Чат"],
    ["forum", "Обсуждения"],
    ["rooms", "Встречи"],
    ["identity", "Профиль"],
  ];
  $("#bottom-nav").innerHTML = bottom
    .map(
      ([view, label]) =>
        `<button data-view="${view}" class="${state.view === view || (view === "rooms" && ["voice", "video", "stage", "live"].includes(state.view)) ? "active" : ""}">${icon(views[view][1])}<span>${label}</span></button>`,
    )
    .join("");
  $(".breadcrumbs span").textContent = spaces[state.space].name;
  $("#page-title").textContent = views[state.view][0];
}
function renderContext() {
  $("#context").innerHTML =
    `<div class="between panel-title"><span>О пространстве</span>${icon("leaf")}</div><p class="muted" style="font-size:12px;line-height:1.9">Место, где можно делиться процессом, находить своих и делать что-то хорошее вместе.</p><div class="divider"></div><div class="between panel-title"><span>Участники</span><span class="pill">24</span></div>${people
      .slice(0, 4)
      .map(
        (p) =>
          `<div class="member">${avatar(p)}<div><p>${escapeHTML(p.name)}</p><small>${p.role}</small></div></div>`,
      )
      .join(
        "",
      )}<button class="text-link" data-action="members">Все участники ${icon("arrow")}</button><div class="divider"></div><div class="context-card"><span class="pill warm">Сегодня · 19:00</span><h3 style="margin-top:14px">Чай в гостиной</h3><p>Без повестки и обязательств. Можно просто послушать.</p><button class="button" data-view="voice">${icon("mic")} Заглянуть в комнату</button></div><div class="context-quote"><strong>Можно быть собой.</strong>Здесь не нужно постоянно быть онлайн. Настройте уведомления так, как удобно вам.</div>`;
}
function go(view) {
  if (!views[view]) return;
  if (state.disabledViews.includes(view)) {
    toast("Этот раздел выключен в демонстрационных настройках.");
    return;
  }
  state.view = view;
  state.filter = "all";
  state.reply = null;
  location.hash = view;
  closeModal();
  render();
}
function heading(title, description, action = "") {
  return `<div class="page-header"><div><h1>${title}</h1><p>${description}</p></div>${action}</div>`;
}
function art() {
  return '<div class="attachment-art" role="img" aria-label="Иллюстрация зелёных холмов"><span class="sun"></span><span class="hill"></span><span class="hill second"></span></div>';
}
function renderMessage(message) {
  const p =
    message.person === 3
      ? { ...people[3], name: state.persona }
      : people[message.person];
  const count =
    (state.threads[message.id] || []).length + (message.replies || 0);
  return `<article class="message">${avatar(p)}<div class="message-body"><div class="row"><span class="message-name">${escapeHTML(p.name)}</span><time class="message-time">${message.time}</time><button class="icon message-tool" data-action="reply" data-id="${message.id}" aria-label="Ответить на сообщение">${icon("chat")}</button></div><p class="message-text">${escapeHTML(message.text)}</p>${message.art ? `${art()}<div class="art-caption">Холмы, которые хотелось запомнить · иллюстрация</div>` : ""}<div class="message-meta">${(message.reactions || []).map(([emoji, n], i) => `<button class="reaction ${message.selected === i ? "selected" : ""}" data-action="react" data-id="${message.id}" data-index="${i}" aria-label="Реакция ${emoji}, ${n}">${emoji} ${n}</button>`).join("")}<button class="reaction" data-action="new-reaction" data-id="${message.id}" aria-label="Добавить реакцию">${icon("smile")}</button>${count ? `<button class="reply-button" data-action="thread" data-id="${message.id}">${count} ответа ${icon("arrow")}</button>` : ""}</div></div></article>`;
}
function renderChat() {
  return `<div class="channel-heading"><div><h1>Общий чат <span class="muted" style="font-weight:500">/</span></h1><p>Разговоры, маленькие открытия и то, что между ними.</p></div><div class="heading-actions"><button class="icon" data-action="members" aria-label="Участники">${icon("users")}</button><button class="icon" data-action="channel-menu" aria-label="Настройки чата">${icon("more")}</button></div></div><div class="topic-banner">${icon("bookmark")}<span><strong>Наш маленький манифест.</strong> Бережно друг к другу и к чужому времени.</span><button data-action="manifesto">Открыть</button></div><div class="chat-history" id="history"><div class="date-divider">Сегодня, 7 октября</div>${state.messages.map(renderMessage).join("")}</div><div class="composer-area"><div class="typing">Делитесь, когда хочется. Ответ не обязан быть мгновенным.</div><form class="composer" id="message-form">${state.reply ? `<div class="reply-context"><span>Ответ: ${escapeHTML(state.reply.text.slice(0, 65))}</span><button class="icon" data-action="cancel-reply" type="button" aria-label="Отменить ответ">${icon("close")}</button></div>` : ""}<textarea id="message-input" aria-label="Текст сообщения" placeholder="Что у вас нового?" rows="2" maxlength="3000">${escapeHTML(saved("draft", ""))}</textarea><div class="composer-tools"><button class="icon" type="button" data-action="attachment" aria-label="Добавить вложение">${icon("plus")}</button><button class="icon" type="button" data-action="emoji" aria-label="Добавить эмодзи">${icon("smile")}</button><span class="composer-hint">Enter — отправить · Shift + Enter — новая строка</span><button class="send" type="submit" aria-label="Отправить сообщение">${icon("send")}</button></div></form></div>`;
}
function renderHome() {
  return `<div class="page">${heading("Хорошо, что вы здесь.", "Самое важное в вашем пространстве, без лишнего шума.")}<div class="hero"><div class="hero-copy"><span class="overline">Лесная мастерская</span><h1 style="margin-top:12px">Место для идей.<br>И людей за ними.</h1><p>Небольшое сообщество, большие разговоры. Продолжите с того места, где остановились.</p><button class="button primary" data-view="chat">Вернуться в разговор ${icon("arrow")}</button></div><div class="hero-art"><span class="orbit"></span><span class="floating-note">☕ Сегодня встречаемся без повестки</span></div></div><div class="section-title"><h2>Ваш следующий маленький шаг</h2></div><div class="grid"><div class="card"><span class="pill">Разговор</span><h3 style="margin-top:16px">Что вдохновляет вас сейчас?</h3><p>Аня предложила поделиться находками недели. Можно ответить картинкой, ссылкой или парой слов.</p><button class="button" data-view="chat">${icon("chat")} Открыть чат</button></div><div class="card"><span class="pill warm">Сегодня · 19:00</span><h3 style="margin-top:16px">В гостиной уже уютно</h3><p>Неспешная встреча с людьми из мастерской. Без камеры, если так комфортнее.</p><button class="button" data-view="voice">${icon("mic")} Посмотреть комнату</button></div></div><div class="section-title"><h2>Сохранённое</h2><button class="text-link" data-view="feed">К ленте ${icon("arrow")}</button></div><div class="card"><div class="row">${icon("bookmark")}<div><h3>${state.bookmarks.length ? "Ваши находки ждут вас" : "Ваше место для находок"}</h3><p>${state.bookmarks.length ? `Сохранено материалов: ${state.bookmarks.length}. Откройте ленту и выберите «Сохранённое».` : "Сохраняйте то, к чему хочется вернуться. Это личная полка, не список обязательств."}</p></div></div></div></div>`;
}
const topics = [
  {
    title: "Соберём небольшой зин про осень?",
    person: 2,
    text: "Идея для совместного проекта · обновлено 20 минут назад",
    tag: "Совместное",
    replies: 12,
  },
  {
    title: "Какие книги помогают вам смотреть по-новому?",
    person: 1,
    text: "Книги и вдохновение · вчера",
    tag: "Вопрос",
    replies: 8,
  },
  {
    title: "Как мы хотим жить в этом пространстве",
    person: 0,
    text: "Бережное общение · закреплено",
    tag: "О пространстве",
    replies: 5,
  },
];
function renderForum() {
  const all = [...state.posts.filter((p) => p.kind === "topic"), ...topics];
  return `<div class="page">${heading("Хорошие разговоры остаются.", "Здесь обсуждениям есть время и место.", `<button class="button primary" data-action="new-topic">${icon("plus")} Новая тема</button>`)}<div class="tabs"><button class="tab ${state.filter === "all" ? "active" : ""}" data-filter="all">Все темы</button><button class="tab ${state.filter === "Вопрос" ? "active" : ""}" data-filter="Вопрос">Вопросы</button><button class="tab ${state.filter === "Совместное" ? "active" : ""}" data-filter="Совместное">Совместное</button></div>${all
    .filter((t) => state.filter === "all" || t.tag === state.filter)
    .map(
      (t, i) =>
        `<article class="topic">${avatar(people[t.person ?? 3])}<button class="topic-main" data-action="topic" data-index="${i}"><h3>${escapeHTML(t.title)}</h3><p>${escapeHTML(t.text)}</p><span class="pill ${t.tag === "Совместное" ? "warm" : ""}">${escapeHTML(t.tag)}</span></button><div class="topic-stat"><strong>${t.replies || 0}</strong>ответов</div></article>`,
    )
    .join(
      "",
    )}<div class="end-note">Можно читать в своём темпе. Разговор подождёт.</div></div>`;
}
const feeds = [
  {
    id: "f1",
    person: 0,
    title: "Маленькие вещи, которые делают день",
    text: "Свежий воздух в комнате, любимая кружка и десять минут без экрана. Иногда лучший способ придумать что-то новое — оставить немного места для ничего.",
    art: "🌱",
    label: "Заметка",
    date: "Сегодня, 09:40",
  },
  {
    id: "f2",
    person: 1,
    title: "Палитра выходных",
    text: "Сохранил цвета прогулки: тихий зелёный, цвет влажной земли и немного тёплого света. Делюсь — вдруг они пригодятся и вам.",
    art: "◒",
    label: "Находка",
    date: "Вчера, 18:15",
  },
];
function renderFeed() {
  const all = [...state.posts.filter((p) => p.kind === "feed"), ...feeds];
  return `<div class="page">${heading("Немного вдохновения.", "Лента людей, которых вы выбрали. В хронологическом порядке.", `<button class="button primary" data-action="new-post">${icon("plus")} Поделиться</button>`)}<div class="tabs"><button class="tab ${state.filter === "all" ? "active" : ""}" data-filter="all">Все записи</button><button class="tab ${state.filter === "saved" ? "active" : ""}" data-filter="saved">${icon("bookmark")} Сохранённое</button></div>${
    all
      .filter((p) => state.filter !== "saved" || state.bookmarks.includes(p.id))
      .map(
        (p) =>
          `<article class="feed-card">${p.art ? `<div class="feed-art" aria-hidden="true">${p.art}</div>` : ""}<div class="feed-body"><div class="between"><div class="row">${avatar(people[p.person ?? 3])}<div><h3>${escapeHTML(people[p.person ?? 3].name)}</h3><small class="muted">${p.date || "Только что"}</small></div></div><span class="pill">${p.label || "Заметка"}</span></div><h2>${escapeHTML(p.title)}</h2><p>${escapeHTML(p.text)}</p></div><div class="feed-actions"><button data-action="feed-like" data-id="${p.id}">${icon("smile")} Поддержать</button><button data-action="post-discuss" data-id="${p.id}">${icon("chat")} Обсудить</button><span class="spacer"></span><button data-action="save" data-id="${p.id}">${icon("bookmark")} ${state.bookmarks.includes(p.id) ? "Сохранено" : "Сохранить"}</button></div></article>`,
      )
      .join("") ||
    '<div class="empty">Здесь появятся ваши сохранённые находки.</div>'
  }<div class="end-note">Вы всё посмотрели. Хорошего вам дня 🌿</div></div>`;
}
function renderRooms() {
  return `<div class="page">${heading("Быть рядом — по-разному.", "Голос, видео или просто послушать. Вы выбираете формат.")}<div class="grid">${[
    [
      "voice",
      "Гостиная",
      "Чай, идеи и разговоры без повестки.",
      "3 участника",
      "mic",
    ],
    [
      "video",
      "Покажем процесс",
      "Камерная встреча с видео и демонстрацией экрана.",
      "Встреча в 20:00",
      "video",
    ],
    [
      "stage",
      "Разговор о внимании",
      "Несколько спикеров, много хороших вопросов.",
      "Сегодня, 19:30",
      "stage",
    ],
    [
      "live",
      "Прогулка по мастерской",
      "Небольшой эфир о том, что мы делаем.",
      "Запись и эфир",
      "live",
    ],
  ]
    .map(
      ([v, title, text, badge, ico]) =>
        `<div class="card room"><span class="pill">${badge}</span><div class="room-symbol">${icon(ico)}</div><h3>${title}</h3><p>${text}</p><div class="room-footer"><div class="avatar-stack">${people
          .slice(0, 3)
          .map((p) => avatar(p, "small"))
          .join(
            "",
          )}</div><button class="button" data-view="${v}">Заглянуть ${icon("arrow")}</button></div></div>`,
    )
    .join("")}</div></div>`;
}
function renderRoom(type) {
  const voice = type === "voice",
    joined = state.call?.type === type;
  return `<div class="page">${heading(voice ? "Гостиная" : "Покажем процесс", voice ? "Можно говорить, можно слушать. Камера не нужна." : "Небольшая встреча для идей и обратной связи.", `<button class="button secondary" data-view="rooms">Все комнаты</button>`)}<div class="room-notice">${icon("shield")} ${joined ? "Вы в демонстрационной комнате. Реальный микрофон и камера не используются." : "Вы ещё не подключены. Сначала выберите, как хотите присоединиться."}</div><div class="participants-grid">${people
    .slice(0, joined ? 4 : 3)
    .map(
      (p, i) =>
        `<div class="participant-tile ${i === 0 && joined ? "speaking" : ""}">${avatar(p, "large")}<h3>${p.name}</h3>${i === 0 && joined ? '<div class="audio-bars"><i></i><i></i><i></i><i></i></div>' : `<small>${i === 3 ? "Вы · микрофон выключен" : voice ? "Слушает" : "Камера выключена"}</small>`}</div>`,
    )
    .join(
      "",
    )}</div>${joined ? `<div class="call-controls"><button class="icon ${state.mic ? "" : "off"}" data-action="mic" aria-label="${state.mic ? "Выключить" : "Включить"} микрофон">${icon("mic")}</button>${!voice ? `<button class="icon ${state.camera ? "" : "off"}" data-action="camera" aria-label="Переключить камеру">${icon("video")}</button><button class="icon" data-action="screen" aria-label="Демонстрация экрана">${icon("monitor")}</button>` : ""}<button class="icon hangup" data-action="leave" aria-label="Покинуть комнату">${icon("exit")}</button></div>` : `<div style="text-align:center"><button class="button primary" data-action="join" data-type="${type}">${icon(voice ? "mic" : "video")} Присоединиться с выключенным микрофоном</button><p class="fineprint" style="margin-top:14px">Демонстрация интерфейса · без доступа к устройствам</p></div>`}<div class="card" style="margin-top:30px"><div class="between"><h3>Сегодня без повестки</h3><span class="pill warm">Неспешно</span></div><p>Расскажите, что вас занимает, покажите незавершённое или просто побудьте рядом. Выйти можно в любой момент.</p></div></div>`;
}
function renderStage(type) {
  const live = type === "live",
    joined = state.call?.type === type;
  return `<div class="page">${heading(live ? "Прогулка по мастерской" : "Разговор о внимании", live ? "Небольшой эфир с людьми, которые любят своё дело." : "Что помогает замечать больше и создавать осмысленнее.", `<button class="button secondary" data-view="rooms">Все встречи</button>`)}<div class="media-scene"><span class="pill">${icon(live ? "live" : "stage")} ${live ? "Демонстрационный эфир" : "Демонстрационная сцена"}</span><div class="media-scene-content">${live ? `<button class="play-button" data-action="join" data-type="live" aria-label="Посмотреть демонстрацию эфира">${icon("play")}</button>` : ""}<h2>${live ? "Заглянем за кулисы." : "Больше внимания.\nМеньше спешки."}</h2><p>${live ? "С Аней Мироновой" : "Аня Миронова · Марк Лисов"}</p></div></div><div class="between" style="margin:22px 0"><div class="row"><div class="avatar-stack">${people
    .slice(0, 3)
    .map((p) => avatar(p, "small"))
    .join(
      "",
    )}</div><small class="muted">${live ? "18 зрителей" : "12 слушателей"} · демоданные</small></div><button class="button ${joined ? "secondary" : "primary"}" data-action="${joined ? (live ? "leave" : "hand") : "join"}" data-type="${type}">${icon(joined ? (live ? "exit" : "hand") : "volume")}${joined ? (live ? "Остановить" : "Поднять руку") : "Присоединиться"}</button></div><div class="grid"><div class="card"><h3>О встрече</h3><p>Поговорим о творческом процессе, привычках и том, как оставлять себе пространство для нового. Вопросы приветствуются.</p><button class="text-link" data-action="question">Задать вопрос ${icon("chat")}</button></div><div class="card"><h3>${live ? "Материалы эфира" : "Как участвовать"}</h3><p>${live ? "Ссылки, заметки и запись останутся здесь после встречи." : "Вы входите слушателем. Чтобы выступить, поднимите руку: микрофон включается только после вашего согласия."}</p><button class="text-link" data-action="save-event">Сохранить встречу ${icon("bookmark")}</button></div></div></div>`;
}
function renderIdentity() {
  return `<div class="page">${heading("Вы — это вы.", "Одна идентичность. Разные стороны вас в разных пространствах.")}<div class="identity-hero">${avatar({ initials: "В" }, "large")}<div><h1>${escapeHTML(state.persona)}</h1><p class="muted">В Лесной мастерской</p><div class="profile-pills"><span class="pill">${icon("shield")} Ключи принадлежат вам</span><button class="pill" data-action="persona">Изменить профиль</button></div></div></div><div class="grid"><div class="card"><div class="room-symbol">${icon("qr")}</div><h2>Карточка восстановления</h2><p>Вернуться к своей идентичности на новом устройстве. Карточка хранится у вас, а не у пространства.</p><button class="button" data-action="recovery">Посмотреть образец</button><div class="identity-warning">Карточка с открытым секретом даёт полный доступ тому, у кого она есть. Не отправляйте её в чаты.</div></div><div class="card"><div class="room-symbol">${icon("user")}</div><h2>Ваши профили</h2><p>Имя, аватар и описание могут отличаться. Разные пространства не обязаны знать, что это один человек.</p><div class="setting-row"><div><strong>Лесная мастерская</strong><p>${escapeHTML(state.persona)} · творческий профиль</p></div><button class="icon" data-action="persona" aria-label="Изменить профиль">${icon("settings")}</button></div><div class="setting-row"><div><strong>Небольшая команда</strong><p>Виталий · рабочий профиль</p></div><span class="pill">Отдельно</span></div></div></div><div class="section-title"><h2>Ваши устройства</h2><span class="pill">Демонстрация</span></div><div class="card"><div class="device"><div class="room-symbol">${icon("monitor")}</div><div><h3>Этот компьютер</h3><p>Windows · текущая сессия</p></div><span class="pill" style="margin-left:auto">Это вы</span></div><div class="device"><div class="room-symbol">${icon("phone")}</div><div><h3>Телефон</h3><p>Последний вход вчера · демоданные</p></div><button class="text-link" data-action="revoke-device">Отозвать</button></div></div></div>`;
}
function switchButton(action, on, label) {
  return `<button class="switch ${on ? "on" : ""}" role="switch" aria-checked="${on}" aria-label="${label}" data-action="${action}"></button>`;
}
function renderSettings() {
  return `<div class="page">${heading("Пусть будет удобно вам.", "Приложение подстраивается под ваш ритм, а не наоборот.")}<div class="card"><h2>Внешний вид</h2><div class="setting-row"><div><strong>Тёмная тема</strong><p>Та же спокойная палитра, меньше света.</p></div>${switchButton("theme", state.theme === "dark", "Тёмная тема")}</div><div class="setting-row"><div><strong>Компактный режим</strong><p>Больше сообщений на экране, когда это нужно.</p></div>${switchButton("compact", state.compact, "Компактный режим")}</div></div><div class="card" style="margin-top:20px"><h2>Ваше внимание</h2><div class="setting-row"><div><strong>Тихий режим</strong><p>Уведомления остаются внутри приложения. Можно спокойно закончить свои дела.</p></div>${switchButton("quiet", state.quiet, "Тихий режим")}</div><div class="setting-row"><div><strong>Уведомления пространства</strong><p>Выбирайте важное: личные ответы, упоминания, встречи.</p></div><button class="text-link" data-action="notification-settings">Настроить</button></div></div><div class="card" style="margin-top:20px"><h2>Идентичность и устройства</h2><p>Ключи, профили и восстановление собраны в одном месте.</p><button class="button" data-view="identity">${icon("shield")} Моя идентичность</button></div><div class="card" style="margin-top:20px"><h2>Для владельца пространства</h2><p>Настройка разделов, правил входа и доступности контента. Отдельная роль, отдельные права.</p><button class="button secondary" data-view="admin">${icon("settings")} Посмотреть панель управления</button></div></div>`;
}
function renderAdmin() {
  return `<div class="page">${heading("Ваше пространство. Ваши правила.", "Демонстрация веб-панели владельца, без изменений настоящего сервера.")}<div class="grid three"><div class="card"><span class="overline">Участники</span><h1 style="margin-top:12px">24</h1><p>Небольшое сообщество</p></div><div class="card"><span class="overline">Разделы</span><h1 style="margin-top:12px">${7 - state.disabledViews.length}</h1><p>Включено в этом макете</p></div><div class="card"><span class="overline">Сервер</span><h3 style="margin-top:16px">forest.example.invalid</h3><p>Демонстрационный адрес</p></div></div><div class="section-title"><h2>Доступные разделы</h2></div><div class="card"><p style="margin:0 0 12px">Выключение раздела скрывает его в этом прототипе. Контент не удаляется.</p>${["chat", "forum", "feed", "voice", "video", "stage", "live"].map((v) => `<div class="admin-view"><div class="row">${icon(views[v][1])}<strong>${views[v][0]}</strong></div><button class="switch ${state.disabledViews.includes(v) ? "" : "on"}" data-action="toggle-view" data-view-name="${v}" role="switch" aria-label="Доступность: ${views[v][0]}" aria-checked="${!state.disabledViews.includes(v)}"></button></div>`).join("")}</div><div class="section-title"><h2>Вход и доступ</h2></div><div class="grid"><div class="card"><h3>Небольшой круг</h3><p>Вход по приглашениям; роли назначаются отдельно. Участник не становится владельцем от создания профиля.</p><button class="button" data-action="access-policy">Настроить правила</button></div><div class="card"><h3>Резервное копирование</h3><p>Идентичность сервера, настройки и содержимое. С понятной датой последней проверки восстановления.</p><button class="button secondary" data-action="backup">Посмотреть состояние</button></div></div></div>`;
}
function renderCallbar() {
  document.body.classList.toggle("call-active", !!state.call);
  $("#callbar").innerHTML = state.call
    ? `<div class="callbar">${icon(views[state.call.type][1])}<div><strong>${views[state.call.type][0]}</strong><small>Демонстрация · микрофон не используется</small></div><span class="spacer"></span><button class="icon" data-view="${state.call.type}" aria-label="Вернуться в комнату">${icon("arrow")}</button><button class="icon" data-action="mic" aria-label="Переключить состояние микрофона">${icon(state.mic ? "mic" : "volume")}</button><button class="icon" data-action="leave" aria-label="Покинуть комнату">${icon("exit")}</button></div>`
    : "";
}
function render() {
  applyPreferences();
  renderNavigation();
  renderContext();
  const renderers = {
    chat: renderChat,
    home: renderHome,
    forum: renderForum,
    feed: renderFeed,
    rooms: renderRooms,
    voice: () => renderRoom("voice"),
    video: () => renderRoom("video"),
    stage: () => renderStage("stage"),
    live: () => renderStage("live"),
    identity: renderIdentity,
    settings: renderSettings,
    admin: renderAdmin,
  };
  $("#content").innerHTML = renderers[state.view]();
  renderCallbar();
  syncDerivedState();
  if (state.view === "chat") {
    $("#history").scrollTop = $("#history").scrollHeight;
  }
}
function syncDerivedState() {
  if (state.view === "settings")
    $(".page .card").insertAdjacentHTML(
      "afterend",
      window.SpaceTheme.editor() +
        window.SpaceTheme.agreement(spaces[state.space].domain),
    );
  if (state.view === "admin")
    $(".page").insertAdjacentHTML(
      "beforeend",
      window.SpaceTheme.admin(spaces[state.space].domain),
    );
  if (state.phoneRevoked && $('[data-action="revoke-device"]'))
    $('[data-action="revoke-device"]').outerHTML =
      '<span class="pill warm" style="margin-left:auto">Доступ отозван</span>';
  document.querySelectorAll('[data-action="save-event"]').forEach((button) => {
    button.innerHTML =
      icon("bookmark") +
      (state.eventSaved ? " Встреча сохранена" : " Сохранить встречу");
  });
  if (state.view === "chat")
    document
      .querySelectorAll('[data-view="chat"] .count')
      .forEach((badge) => badge.remove());
  if (state.call) {
    const ownTile = [...document.querySelectorAll(".participant-tile")].find(
      (tile) => tile.textContent.includes("Виталий"),
    );
    if (ownTile) {
      const status = ownTile.querySelector("small");
      if (status)
        status.textContent = state.mic
          ? "Вы · микрофон включён в макете"
          : "Вы · микрофон выключен";
    }
  }
}
function modal(title, body, wide = false) {
  $("#modal").className = wide ? "modal-nav" : "";
  $("#modal-body").innerHTML =
    `<div class="modal-header"><h2>${title}</h2><button class="icon" data-action="close" aria-label="Закрыть окно">${icon("close")}</button></div><div class="modal-content">${body}</div>`;
  if (!$("#modal").open) $("#modal").showModal();
}
function closeModal() {
  if ($("#modal").open) $("#modal").close();
}
function submitMessage() {
  const input = $("#message-input");
  const text = input.value.trim();
  if (!text) return;
  const time = new Date().toLocaleTimeString("ru-RU", {
    hour: "2-digit",
    minute: "2-digit",
  });
  state.messages.push({
    id: Date.now(),
    person: 3,
    time,
    text: state.reply ? `↳ ${state.reply.text.slice(0, 70)}\n${text}` : text,
    reactions: [],
  });
  persist("messages", state.messages);
  persist("draft", "");
  state.reply = null;
  render();
  $("#message-input").focus();
}
function newPost(kind) {
  modal(
    kind === "topic" ? "Начать разговор" : "Поделиться находкой",
    `<form id="post-form" data-kind="${kind}" class="stack"><label class="field">${kind === "topic" ? "Название темы" : "Заголовок"}<input name="title" required maxlength="120" placeholder="О чём хочется поговорить?"></label><label class="field">${kind === "topic" ? "Первая мысль" : "Ваша запись"}<textarea name="text" required maxlength="3000" placeholder="Можно начать с пары предложений."></textarea></label>${kind === "topic" ? '<label class="field">Раздел<select name="tag"><option>Вопрос</option><option>Совместное</option><option>О пространстве</option></select></label>' : ""}<div class="modal-actions"><button class="button secondary" data-action="close" type="button">Отмена</button><button class="button primary" type="submit">${kind === "topic" ? "Создать тему" : "Опубликовать в макете"}</button></div><p class="fineprint">Запись остаётся только в этом браузерном прототипе.</p></form>`,
  );
}
function search(query = "") {
  const results = Object.entries(views).filter(([, v]) =>
    v[0].toLowerCase().includes(query.toLowerCase()),
  );
  const messages = state.messages.filter(
    (m) => query && m.text.toLowerCase().includes(query.toLowerCase()),
  );
  $("#search-results").innerHTML =
    results
      .map(
        ([v, [label, ico]]) =>
          `<button class="search-result" data-view="${v}">${icon(ico)}<span><strong>${label}</strong><small>Раздел пространства</small></span><span class="spacer"></span>${icon("arrow")}</button>`,
      )
      .join("") +
    messages
      .slice(0, 5)
      .map(
        (m) =>
          `<button class="search-result" data-action="jump-message" data-id="${m.id}">${icon("chat")}<span><strong>${escapeHTML(people[m.person].name)}</strong><small>${escapeHTML(m.text.slice(0, 100))}</small></span></button>`,
      )
      .join("");
  if (!results.length && !messages.length)
    $("#search-results").innerHTML =
      '<div class="empty">Ничего не нашли. Попробуйте другое слово.</div>';
}
function thread(message) {
  const replies = state.threads[message.id] || [];
  modal(
    "Разговор в стороне",
    `<div class="thread-original"><strong>${people[message.person].name}</strong><p>${escapeHTML(message.text)}</p></div>${message.replies ? '<p class="fineprint">В исходном макете у этой темы два демонстрационных ответа.</p>' : ""}${replies.map((r) => `<div><strong>${escapeHTML(state.persona)}</strong><p>${escapeHTML(r)}</p></div>`).join("")}<form id="thread-form" data-id="${message.id}" class="stack"><label class="field">Ваш ответ<textarea name="text" required maxlength="2000" placeholder="Продолжить мысль…"></textarea></label><button class="button primary">Ответить в ветке</button></form>`,
  );
}
const actions = {
  close: closeModal,
  navigation() {
    modal(
      "Ваше пространство",
      `<div class="space-sidebar">${$("#sidebar").innerHTML}</div>`,
      true,
    );
  },
  search() {
    modal(
      "Найти своё",
      `<input class="search-input" id="search-input" placeholder="Раздел, имя или фраза…" aria-label="Поиск"><div id="search-results"></div>`,
    );
    search();
    $("#search-input").focus();
  },
  theme() {
    state.theme = state.theme === "light" ? "dark" : "light";
    persist("theme", state.theme);
    render();
  },
  compact() {
    state.compact = !state.compact;
    persist("compact", state.compact);
    render();
  },
  quiet() {
    state.quiet = !state.quiet;
    persist("quiet", state.quiet);
    render();
    toast(
      state.quiet
        ? "Тихий режим включён. Можно выдохнуть."
        : "Тихий режим выключен.",
    );
  },
  notifications() {
    modal(
      "Для вас",
      `<div class="between"><span class="muted">${state.notificationsRead ? "Всё прочитано" : "Только то, что имеет отношение к вам"}</span><button class="text-link" data-action="read-all">Прочитать всё</button></div>${state.notificationsRead ? '<div class="empty">Вы в курсе. Остальное подождёт.</div>' : `<button class="notification" data-view="forum">${avatar(people[2])}<span><p><strong>Соня</strong> ответила в обсуждении про зин.</p><small>20 минут назад · демонстрация</small></span></button><button class="notification" data-view="voice">${icon("mic")}<span><p>Сегодня в 19:00 — чай в гостиной.</p><small>Вы сохранили эту встречу · демонстрация</small></span></button>`}<button class="button secondary" data-action="notification-settings">Настроить уведомления</button>`,
    );
  },
  "read-all"() {
    state.notificationsRead = true;
    actions.notifications();
  },
  "notification-settings"() {
    modal(
      "Какие новости вам нужны?",
      `<p>Только выбранные события. Не каждое сообщение.</p><div class="setting-row"><strong>Личные ответы и упоминания</strong><input type="checkbox" checked aria-label="Личные ответы" style="width:22px"></div><div class="setting-row"><strong>Сохранённые встречи</strong><input type="checkbox" checked aria-label="Встречи" style="width:22px"></div><div class="setting-row"><strong>Все сообщения</strong><input type="checkbox" aria-label="Все сообщения" style="width:22px"></div><button class="button primary" data-action="save-preferences">Готово</button>`,
    );
  },
  "save-preferences"() {
    closeModal();
    toast("Настройки выбраны в макете. Системные уведомления не включались.");
  },
  members() {
    modal(
      "Люди мастерской",
      people
        .map(
          (p) =>
            `<div class="member">${avatar(p)}<div><h3>${p.name}</h3><p class="fineprint">${p.role}</p></div></div>`,
        )
        .join("") +
        '<p class="fineprint">Персонажи и статусы демонстрационные.</p>',
    );
  },
  manifesto() {
    modal(
      "Бережно друг к другу.",
      `<p>Несколько простых договорённостей, чтобы здесь хотелось быть.</p><ul class="checklist"><li>Можно отвечать не сразу.</li><li>Критикуем идеи, не людей.</li><li>Спрашиваем согласие, прежде чем давать советы.</li><li>В голосовую комнату можно прийти просто слушать.</li><li>Секретные ключи и recovery-карточки не отправляем в чат.</li></ul><button class="button primary" data-action="close">Мне подходит</button>`,
    );
  },
  "space-menu"() {
    modal(
      "Лесная мастерская",
      `<button class="search-result" data-action="invite">${icon("plus")} Пригласить</button><button class="search-result" data-view="admin">${icon("settings")} Управлять пространством</button><button class="search-result" data-view="identity">${icon("user")} Мой профиль здесь</button><button class="search-result" data-view="settings">${icon("bell")} Уведомления и внешний вид</button>`,
    );
  },
  "channel-menu"() {
    modal(
      "Общий чат",
      `<p>Общий разговор мастерской. Для участников пространства.</p><button class="button" data-action="notification-settings">${icon("bell")} Уведомления чата</button><button class="button secondary" data-action="manifesto">Договорённости</button>`,
    );
  },
  invite() {
    modal(
      "Позвать своих",
      `<p>В демо это образец приглашения. Он не открывает доступ к настоящему серверу.</p><label class="field">Ссылка-образец<input readonly value="https://forest.example.invalid/invite/sample"></label><label class="field">Срок приглашения<select><option>7 дней</option><option>1 день</option><option>Без срока</option></select></label><button class="button primary" data-action="copy-invite">${icon("copy")} Скопировать образец</button>`,
    );
  },
  "copy-invite"() {
    navigator.clipboard
      ?.writeText("https://forest.example.invalid/invite/sample")
      .then(() => toast("Скопирована демонстрационная ссылка."))
      .catch(() => toast("Можно выделить ссылку и скопировать вручную."));
  },
  "add-space"() {
    modal(
      "Найдите своё место.",
      `<p>Добавьте адрес независимого пространства. В этом прототипе сеть не проверяется.</p><form id="space-form" class="stack"><label class="field">Адрес пространства<input type="url" name="url" placeholder="https://ваше-пространство.example" required></label><div class="onboard-step"><b>1</b><p>Проверка адреса и возможностей</p></div><div class="onboard-step"><b>2</b><p>Осознанное доверие к серверу</p></div><div class="onboard-step"><b>3</b><p>Отдельный профиль и ключ устройства</p></div><button class="button primary">Добавить в макет ${icon("arrow")}</button><p class="fineprint">Ключи не создаются; адрес сохраняется только в состоянии макета.</p></form>`,
    );
  },
  react(button) {
    const m = state.messages.find((m) => m.id === Number(button.dataset.id));
    const i = Number(button.dataset.index);
    if (m.selected === i) {
      m.reactions[i][1]--;
      delete m.selected;
    } else {
      if (m.selected !== undefined) m.reactions[m.selected][1]--;
      m.reactions[i][1]++;
      m.selected = i;
    }
    persist("messages", state.messages);
    render();
  },
  "new-reaction"(button) {
    const m = state.messages.find((m) => m.id === Number(button.dataset.id));
    if (!m.reactions) m.reactions = [];
    m.reactions.push(["🤍", 1]);
    m.selected = m.reactions.length - 1;
    persist("messages", state.messages);
    render();
  },
  reply(button) {
    state.reply = state.messages.find(
      (m) => m.id === Number(button.dataset.id),
    );
    render();
    $("#message-input").focus();
  },
  "cancel-reply"() {
    state.reply = null;
    render();
  },
  thread(button) {
    thread(state.messages.find((m) => m.id === Number(button.dataset.id)));
  },
  attachment() {
    modal(
      "Добавить к разговору",
      `<p>Вложение в этом прототипе не загружается на сервер.</p><label class="field">Выберите локальный файл<input type="file" id="attachment-file" accept="image/*,.pdf,.txt"></label><button class="button" data-action="attach-demo">Добавить название в черновик</button>`,
    );
  },
  "attach-demo"() {
    const file = $("#attachment-file").files[0];
    closeModal();
    if (file && $("#message-input")) {
      $("#message-input").value += `\n[Вложение в макете: ${file.name}]`;
      persist("draft", $("#message-input").value);
      toast("Файл не загружен. В черновик добавлено его название.");
    }
  },
  emoji() {
    if ($("#message-input")) {
      $("#message-input").value += " 🌿";
      $("#message-input").focus();
    }
  },
  "new-topic"() {
    newPost("topic");
  },
  "new-post"() {
    newPost("feed");
  },
  topic(button) {
    const list = [
      ...state.posts.filter((p) => p.kind === "topic"),
      ...topics,
    ].filter((t) => state.filter === "all" || t.tag === state.filter);
    const t = list[Number(button.dataset.index)];
    modal(
      escapeHTML(t.title),
      `<span class="pill">${escapeHTML(t.tag)}</span><p>${escapeHTML(t.text)}</p><div class="thread-original">Давайте соберём идеи без спешки. Можно присоединиться на любом этапе.</div><form id="topic-reply" class="stack"><label class="field">Ваш ответ<textarea name="text" required maxlength="2000"></textarea></label><button class="button primary">Добавить ответ в макет</button></form>`,
    );
  },
  save(button) {
    const id = button.dataset.id;
    state.bookmarks = state.bookmarks.includes(id)
      ? state.bookmarks.filter((v) => v !== id)
      : [...state.bookmarks, id];
    persist("bookmarks", state.bookmarks);
    render();
    toast(
      state.bookmarks.includes(id)
        ? "Находка на вашей личной полке."
        : "Убрано из сохранённого.",
    );
  },
  "feed-like"(button) {
    button.innerHTML = icon("check") + " Поддержали";
    button.disabled = true;
    toast("Тёплый знак отправлен в макете.");
  },
  "post-discuss"() {
    modal(
      "Продолжить мысль",
      `<p>Комментарий остаётся в демо, не отправляется реальным участникам.</p><form id="topic-reply" class="stack"><label class="field">Комментарий<textarea name="text" required maxlength="2000"></textarea></label><button class="button primary">Добавить комментарий</button></form>`,
    );
  },
  join(button) {
    const type = button.dataset.type;
    if (state.call && state.call.type !== type) {
      toast("Сначала выйдите из текущей комнаты.");
      return;
    }
    state.call = { type };
    state.mic = false;
    state.camera = false;
    render();
    toast(
      "Демонстрационная комната открыта. Доступ к микрофону не запрашивался.",
    );
  },
  leave() {
    state.call = null;
    render();
    toast("Вы вышли из демонстрационной комнаты.");
  },
  mic() {
    state.mic = !state.mic;
    render();
    toast(
      state.mic
        ? "Состояние: микрофон включён в макете. Звук не записывается."
        : "Состояние: микрофон выключен.",
    );
  },
  camera() {
    state.camera = !state.camera;
    render();
    toast("Камера переключена в макете. Видео не снимается.");
  },
  screen() {
    toast("Демонстрация экрана в прототипе не запускается.");
  },
  hand(button) {
    button.disabled = true;
    button.innerHTML = icon("check") + " Рука поднята";
    toast("В макете ведущий увидит ваше желание выступить.");
  },
  question() {
    modal(
      "Ваш вопрос",
      `<form id="topic-reply" class="stack"><label class="field">Что хочется спросить?<textarea name="text" required maxlength="1500"></textarea></label><button class="button primary">Добавить вопрос в макет</button></form>`,
    );
  },
  "save-event"() {
    toast("Встреча сохранена в демонстрационном сценарии.");
  },
  persona() {
    modal(
      "Как вас зовут здесь?",
      `<p>Этот профиль относится только к текущему пространству.</p><form id="persona-form" class="stack"><label class="field">Имя<input name="name" value="${escapeHTML(state.persona)}" maxlength="40" required></label><label class="field">Немного о себе<textarea name="bio" placeholder="Если хочется рассказать"></textarea></label><button class="button primary">Сохранить профиль в макете</button></form>`,
    );
  },
  recovery() {
    modal(
      "Образец карточки восстановления",
      `<span class="pill warm">Образец · не секретный ключ</span><div class="recovery-demo">${icon("qr")}<strong>Здесь будет ваша приватная карточка</strong></div><p>Для открытой карточки достаточно одного изображения. Для зашифрованной потребуется ещё и пароль.</p><div class="identity-warning">Любой, получивший открытую карточку, может восстановить доступ. Храните её отдельно от переписки. История сообщений и список серверов требуют отдельного backup.</div><button class="button primary" data-action="close">Понятно</button>`,
    );
  },
  "revoke-device"() {
    modal(
      "Отозвать телефон?",
      `<p>В рабочем приложении устройство потеряет доступ к этому серверу. История сообщений останется. Сейчас показан только сценарий подтверждения.</p><div class="modal-actions"><button class="button secondary" data-action="close">Оставить</button><button class="button danger" data-action="confirm-revoke">Отозвать в макете</button></div>`,
    );
  },
  "confirm-revoke"() {
    closeModal();
    toast("Демонстрационный отзыв подтверждён. Реальные ключи не изменялись.");
  },
  "toggle-view"(button) {
    const view = button.dataset.viewName;
    state.disabledViews = state.disabledViews.includes(view)
      ? state.disabledViews.filter((v) => v !== view)
      : [...state.disabledViews, view];
    persist("disabledViews", state.disabledViews);
    render();
    toast("Доступность раздела изменена только в прототипе.");
  },
  "access-policy"() {
    modal(
      "Кто может присоединиться?",
      `<label class="field">Политика входа<select><option>По приглашению</option><option>С одобрением владельца</option><option>Открытое пространство</option></select></label><label class="field">Роль нового участника<select><option>Участник</option><option>Читатель</option></select></label><p>Владельцем никто не становится автоматически.</p><button class="button primary" data-action="save-preferences">Применить в макете</button>`,
    );
  },
  backup() {
    modal(
      "Резервная копия пространства",
      `<span class="pill warm">Демонстрация состояния</span><p>В полноценной панели здесь будут дата backup, состав данных и результат последней проверки восстановления.</p><ul class="checklist"><li>Идентичность сервера и его ключ</li><li>Контент и настройки</li><li>Роли и разрешения</li><li>Медиа и вложения</li></ul><button class="button secondary" data-action="close">Вернуться</button>`,
    );
  },
  "jump-message"(button) {
    const id = Number(button.dataset.id);
    go("chat");
    const message = state.messages.find((m) => m.id === id);
    const node = [...document.querySelectorAll(".message")][
      state.messages.indexOf(message)
    ];
    const reduced = matchMedia("(prefers-reduced-motion: reduce)").matches;
    node?.scrollIntoView({
      block: "center",
      behavior: reduced ? "auto" : "smooth",
    });
    if (!reduced)
      node?.animate(
        [{ background: "var(--soft)" }, { background: "transparent" }],
        { duration: 1200 },
      );
  },
};
actions["notification-settings"] = () =>
  modal(
    "Какие новости вам нужны?",
    `<p>Только выбранные события. Не каждое сообщение.</p>${[
      ["answers", "Личные ответы и упоминания"],
      ["events", "Сохранённые встречи"],
      ["all", "Все сообщения"],
    ]
      .map(
        ([key, label]) =>
          `<label class="setting-row"><strong>${label}</strong><input type="checkbox" data-pref="${key}" ${state.notify[key] ? "checked" : ""} style="width:22px"></label>`,
      )
      .join(
        "",
      )}<button class="button primary" data-action="save-notifications">Готово</button>`,
  );
actions["save-notifications"] = () => {
  document
    .querySelectorAll("[data-pref]")
    .forEach((input) => (state.notify[input.dataset.pref] = input.checked));
  persist("notify", state.notify);
  closeModal();
  toast(
    "Предпочтения сохранены в макете. Системные уведомления не запрашивались.",
  );
};
actions["confirm-revoke"] = () => {
  state.phoneRevoked = true;
  persist("phoneRevoked", true);
  closeModal();
  render();
  toast("Телефон отозван в макете. Реальные ключи не изменялись.");
};
actions["save-event"] = () => {
  state.eventSaved = !state.eventSaved;
  persist("eventSaved", state.eventSaved);
  syncDerivedState();
  toast(
    state.eventSaved
      ? "Встреча сохранена на личной полке."
      : "Встреча убрана из сохранённого.",
  );
};
actions["user-palette"] = (button) => {
  window.SpaceTheme.useUser(button.dataset.palette);
  render();
  toast(
    "Сохранены ваши цвета. Разрешённая тема пространства имеет приоритет только внутри него.",
  );
};
actions["preview-theme"] = () =>
  modal(
    "Примеряем оформление пространства",
    window.SpaceTheme.preview(spaces[state.space].domain),
  );
actions["accept-theme"] = () => {
  if (window.SpaceTheme.accept(spaces[state.space].domain)) {
    closeModal();
    render();
    toast("Оформление разрешено только для этого пространства.");
  }
};
actions["revoke-theme"] = () => {
  window.SpaceTheme.revoke(spaces[state.space].domain);
  render();
  toast("Снова используются ваши цвета.");
};
document.addEventListener("submit", (event) => {
  if (event.target.id === "user-colors") {
    event.preventDefault();
    const palette = Object.fromEntries(new FormData(event.target));
    const error = window.SpaceTheme.setUser(palette);
    if (error) {
      $("#palette-error").textContent = error;
      return;
    }
    render();
    toast("Ваши цвета сохранены.");
  }
  if (event.target.id === "server-colors") {
    event.preventDefault();
    window.SpaceTheme.update(
      spaces[state.space].domain,
      String(new FormData(event.target).get("palette")),
    );
    render();
    toast(
      "Новое оформление предложено в макете. Предыдущее согласие не переносится.",
    );
  }
});
document.addEventListener("click", (event) => {
  const button = event.target.closest("button");
  if (!button) return;
  if (button.dataset.space !== undefined) {
    state.space = Number(button.dataset.space);
    render();
    toast(
      `Пространство: ${spaces[state.space].name}. Данные демонстрационные.`,
    );
    return;
  }
  if (button.dataset.view) {
    go(button.dataset.view);
    return;
  }
  if (button.dataset.filter) {
    state.filter = button.dataset.filter;
    render();
    return;
  }
  if (button.dataset.action && actions[button.dataset.action]) {
    event.preventDefault();
    actions[button.dataset.action](button);
  }
});
document.addEventListener("submit", (event) => {
  event.preventDefault();
  const form = event.target;
  if (form.id === "message-form") {
    submitMessage();
    return;
  }
  const data = new FormData(form);
  if (form.id === "post-form") {
    state.posts.unshift({
      id: `p${Date.now()}`,
      kind: form.dataset.kind,
      title: String(data.get("title")),
      text: String(data.get("text")),
      tag: String(data.get("tag") || "Заметка"),
      person: 3,
      replies: 0,
      date: "Только что",
    });
    persist("posts", state.posts);
    closeModal();
    render();
    toast("Сохранено в вашем браузерном прототипе.");
  }
  if (form.id === "thread-form") {
    const id = form.dataset.id;
    state.threads[id] = [
      ...(state.threads[id] || []),
      String(data.get("text")),
    ];
    persist("threads", state.threads);
    thread(state.messages.find((m) => m.id === Number(id)));
  }
  if (form.id === "topic-reply") {
    const text = String(data.get("text"));
    form.insertAdjacentHTML(
      "beforebegin",
      `<div class="thread-original"><strong>${escapeHTML(state.persona)}</strong><p>${escapeHTML(text)}</p></div>`,
    );
    form.reset();
    toast("Ответ добавлен в демонстрационное обсуждение.");
  }
  if (form.id === "persona-form") {
    state.persona = String(data.get("name"));
    persist("persona", state.persona);
    closeModal();
    render();
  }
  if (form.id === "space-form") {
    const url = new URL(String(data.get("url")));
    if (!["http:", "https:"].includes(url.protocol)) {
      toast("Нужен HTTP или HTTPS адрес.");
      return;
    }
    spaces.push({
      name: url.hostname,
      symbol: "flower",
      domain: url.hostname,
      count: "Демо",
    });
    state.space = spaces.length - 1;
    closeModal();
    render();
    toast("Добавлено в макет. Сервер не запрашивался, ключи не создавались.");
  }
});
document.addEventListener("input", (event) => {
  if (event.target.id === "message-input") persist("draft", event.target.value);
  if (event.target.id === "search-input") search(event.target.value);
});
document.addEventListener("keydown", (event) => {
  if ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === "k") {
    event.preventDefault();
    actions.search();
  }
  if (
    event.target.id === "message-input" &&
    event.key === "Enter" &&
    !event.shiftKey &&
    !event.isComposing
  ) {
    event.preventDefault();
    submitMessage();
  }
});
$("#modal").addEventListener("click", (event) => {
  if (event.target === $("#modal")) closeModal();
});
window.addEventListener("hashchange", () => {
  const view = location.hash.slice(1);
  if (views[view] && state.view !== view) {
    state.view = view;
    render();
  }
});
$("#search-icon").innerHTML = icon("search");
$("#notification-button").innerHTML = icon("bell");
$(".mobile-menu").innerHTML = icon("menu");
if (views[location.hash.slice(1)]) state.view = location.hash.slice(1);
render();
