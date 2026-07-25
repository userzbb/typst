// problem_set.typ — 题集核心组件。
// 文档里推荐导入 problem_set_dark.typ 或 problem_set_light.typ。

// 基础模板：导入原始 style_apply 作为 _base
#import "Components/typography.typ": style_apply as _base-style

// 深色模式
#import "Components/dark_mode.typ": dark_mode, inv

// ============================================================
// axiomst 函数的深色版本
// ============================================================
// 不依赖 axiomst 内部的 lighten/darken 派生，直接算最终暗色

#import "@preview/showybox:2.0.4": showybox

// axiomst 原始包（计数器、proof、instructions 等非颜色项）
#import "@preview/axiomst:0.2.1" as axi
// 颜色无关函数直接转发
#import "@preview/axiomst:0.2.1": *

// ============================================================
// 🎨 配色 & 布局面板
// 深色模式默认值
#let _g-fill = 80     // body 淡度（%）
#let _g-title = 60    // 标题栏淡度（%）
#let _g-stroke = 10   // 边框深度（%）
#let _g-color = blue.darken(20%)  // 默认主题色
#let _g-radius = 10%  // 圆角
#let _g-inset-x = 0em // 内边距--左右
#let _g-inset-y = 1em  // 内边距--上下
// 浅色模式默认值（参考 axiomst 上游）
#let _g-fill-l = 95   // body 淡度（color.lighten(95%)）
#let _g-title-l = 85  // 标题栏淡度（color.lighten(85%)）
#let _g-stroke-l = 10 // 边框深度（color.darken(10%)）
#let _g-radius-l = 4pt // 圆角（axiomst 默认）
#let _g-inset-x-l = 0.6em // 内边距--左右（axiomst 默认）
#let _g-inset-y-l = 0.6em // 内边距--上下（axiomst 默认）

// 📦 用户覆盖配置（通过 configure / style_apply 传参）
#let _cfg = state("pset-cfg", (:))
#let _or(d, k, fb) = { if k in d { d.at(k) } else { fb } }

// axiomst 没有 proposition / remark 计数器，自建
#let proposition-counter = counter("proposition")
#let remark-counter = counter("remark")

#let _theme = (
  problem: (
    color: _g-color,
    fill-l: _g-fill,
    title-l: _g-title,
    stroke-d: _g-stroke,
    gap: 1em,
  ),
  theorem: (
    color: _g-color,
    fill-l: _g-fill,
    title-l: _g-title,
    stroke-d: _g-stroke,
    gap: 0.8em,
  ),
  lemma: (
    color: green.darken(20%),
    fill-l: _g-fill,
    title-l: _g-title,
    stroke-d: _g-stroke,
    gap: 0.8em,
  ),
  definition: (
    color: purple.darken(20%),
    fill-l: _g-fill,
    title-l: _g-title,
    stroke-d: _g-stroke,
    gap: 0.8em,
  ),
  proposition: (
    color: red.darken(20%),
    fill-l: _g-fill,
    title-l: _g-title,
    stroke-d: _g-stroke,
    gap: 0.8em,
  ),
  corollary: (
    color: orange.darken(20%),
    fill-l: _g-fill,
    title-l: _g-title,
    stroke-d: _g-stroke,
    gap: 0.8em,
  ),
  example: (
    color: aqua.darken(20%),
    fill-l: _g-fill,
    title-l: _g-title,
    stroke-d: _g-stroke,
    gap: 0.8em,
  ),
  remark: (
    color: gray.darken(20%),
    fill-l: _g-fill,
    title-l: _g-title,
    stroke-d: _g-stroke,
    gap: 0.8em,
  ),
)

// 从面板取主题，允许外部传 cfg 覆盖
// auto 时根据 dark 选择深色/浅色默认值
// 透明度优先级：模式专属 key(fill-l-dark/fill-l-light) > 共享 key(fill-l) > 模式默认值
#let _theme-for(
  name,
  dark: true,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
  cfg: (:),
) = {
  let t = _theme.at(name)
  // 模式感知的全局默认值
  let df-fill = if dark { _g-fill } else { _g-fill-l }
  let df-title = if dark { _g-title } else { _g-title-l }
  let df-stroke = if dark { _g-stroke } else { _g-stroke-l }
  // 模式专属 key
  let fill-l-key = if dark { "fill-l-dark" } else { "fill-l-light" }
  let title-l-key = if dark { "title-l-dark" } else { "title-l-light" }
  let stroke-d-key = if dark { "stroke-d-dark" } else { "stroke-d-light" }
  if color == auto {
    let color-mode-key = if dark { name + "-color-dark" } else {
      name + "-color-light"
    }
    let color-shared-key = name + "-color"
    color = if color-mode-key in cfg { cfg.at(color-mode-key) } else if (
      color-shared-key in cfg
    ) { cfg.at(color-shared-key) } else { t.color }
  }
  // 优先级：模式专属 key > 共享 key > 模式默认值
  if fill-l == auto {
    fill-l = if fill-l-key in cfg { cfg.at(fill-l-key) } else {
      _or(cfg, "fill-l", df-fill)
    }
  }
  if title-l == auto {
    title-l = if title-l-key in cfg { cfg.at(title-l-key) } else {
      _or(cfg, "title-l", df-title)
    }
  }
  if stroke-d == auto {
    stroke-d = if stroke-d-key in cfg { cfg.at(stroke-d-key) } else {
      _or(cfg, "stroke-d", df-stroke)
    }
  }
  if gap == auto {
    let k = name + "-gap"
    gap = if k in cfg { cfg.at(k) } else { t.gap }
  }
  (color: color, fill-l: fill-l, title-l: title-l, stroke-d: stroke-d, gap: gap)
}

// 根据主题参数计算最终暗色
// 根据主题参数计算最终颜色（暗色反转 inv，浅色直接 lighten/darken）
#let _fill(t, dark) = if dark { inv(t.color.lighten(t.fill-l * 1%)) } else {
  t.color.lighten(t.fill-l * 1%)
}
#let _title(t, dark) = if dark { inv(t.color.lighten(t.title-l * 1%)) } else {
  t.color.lighten(t.title-l * 1%)
}
#let _stroke(t, dark) = if dark { inv(t.color.darken(t.stroke-d * 1%)) } else {
  t.color.darken(t.stroke-d * 1%)
}
// 文字色：暗色白字(inv black)，浅色黑字
#let _txt(dark) = if dark { inv(black) } else { black }

// ⚡ 暗色模式开关
#let _is-dark = state("_pset-dark-mode", true)

// theorem-base（暗色/浅色自适应，直写不调 axi.theorem-base）
#let _theorem-base(
  ctr,
  prefix,
  theme,
  title: none,
  numbered: true,
  body,
) = context {
  let dark = _is-dark.get()
  let number = if numbered {
    ctr.step()
    context ctr.display()
  }
  let cfg = _cfg.get()
  // 模式专属 key 优先于共享 key
  let radius-key = if dark { "radius-dark" } else { "radius-light" }
  let ix-key = if dark { "inset-x-dark" } else { "inset-x-light" }
  let iy-key = if dark { "inset-y-dark" } else { "inset-y-light" }
  let rx = if radius-key in cfg { cfg.at(radius-key) } else {
    _or(cfg, "radius", if dark { _g-radius } else { _g-radius-l })
  }
  let ix = if ix-key in cfg { cfg.at(ix-key) } else {
    _or(cfg, "inset-x", if dark { _g-inset-x } else { _g-inset-x-l })
  }
  let iy = if iy-key in cfg { cfg.at(iy-key) } else {
    _or(cfg, "inset-y", if dark { _g-inset-y } else { _g-inset-y-l })
  }
  (
    block(
      width: 100%,
      fill: _fill(theme, dark),
      radius: rx,
      stroke: _stroke(theme, dark),
      inset: (x: ix, y: iy),
    )[
      #text(fill: _txt(dark), weight: "bold")[#prefix #if numbered { number }]
      #if title != none [#text(fill: _txt(dark), style: "italic")[#title].]
      #v(0.5em)
      #body
    ]
      + v(theme.gap)
  )
}

// Problem（直调 showybox，暗色/浅色自适应配色）
#let problem(
  title: "",
  numbered: true,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
  inset-x: auto,
  inset-y: auto,
  body,
) = context {
  let dark = _is-dark.get()
  let cfg = _cfg.get()
  let t = _theme-for(
    "problem",
    dark: dark,
    color: color,
    fill-l: fill-l,
    title-l: title-l,
    stroke-d: stroke-d,
    gap: gap,
    cfg: cfg,
  )
  let ix-key = if dark { "inset-x-dark" } else { "inset-x-light" }
  let iy-key = if dark { "inset-y-dark" } else { "inset-y-light" }
  let ix = if inset-x != auto {
    inset-x
  } else if ix-key in cfg {
    cfg.at(ix-key)
  } else {
    _or(cfg, "inset-x", if dark { _g-inset-x } else { _g-inset-x-l })
  }
  let iy = if inset-y != auto {
    inset-y
  } else if iy-key in cfg {
    cfg.at(iy-key)
  } else {
    _or(cfg, "inset-y", if dark { _g-inset-y } else { _g-inset-y-l })
  }
  if numbered {
    [== Problem #axi.problem-counter.step() #context axi.problem-counter.display()]
  }
  showybox(
    frame: (
      border-color: _stroke(t, dark),
      title-color: _title(t, dark),
      body-color: _fill(t, dark),
      body-inset: (x: ix, y: iy),
    ),
    title-style: (color: _txt(dark), weight: "bold"),
    breakable: true,
    title: title,
    body,
  )
  v(t.gap)
}

// Solution（自建，读 _cfg 控制显隐，暗色/浅色自适应）
#let solution(body) = context {
  let dark = _is-dark.get()
  let visible = _or(_cfg.get(), "show-solutions", true)
  if visible {
    v(0.5em)
    block(
      width: 100%,
      breakable: true,
    )[
      #text(fill: _txt(dark), weight: "bold")[Solution:]
      #v(0.3em)
      #body
    ]
  }
}

// Theorem
#let theorem(
  title: none,
  numbered: true,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
  body,
) = context {
  let dark = _is-dark.get()
  let cfg = _cfg.get()
  _theorem-base(
    axi.theorem-counter,
    "Theorem",
    _theme-for(
      "theorem",
      dark: dark,
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
      gap: gap,
      cfg: cfg,
    ),
    title: title,
    numbered: numbered,
    body,
  )
}

#let lemma(
  title: none,
  numbered: true,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
  body,
) = context {
  let dark = _is-dark.get()
  let cfg = _cfg.get()
  _theorem-base(
    axi.lemma-counter,
    "Lemma",
    _theme-for(
      "lemma",
      dark: dark,
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
      gap: gap,
      cfg: cfg,
    ),
    title: title,
    numbered: numbered,
    body,
  )
}

#let definition(
  title: none,
  numbered: true,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
  body,
) = context {
  let dark = _is-dark.get()
  let cfg = _cfg.get()
  _theorem-base(
    axi.definition-counter,
    "Definition",
    _theme-for(
      "definition",
      dark: dark,
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
      gap: gap,
      cfg: cfg,
    ),
    title: title,
    numbered: numbered,
    body,
  )
}

#let proposition(
  title: none,
  numbered: true,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
  body,
) = context {
  let dark = _is-dark.get()
  let cfg = _cfg.get()
  _theorem-base(
    proposition-counter,
    "Proposition",
    _theme-for(
      "proposition",
      dark: dark,
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
      gap: gap,
      cfg: cfg,
    ),
    title: title,
    numbered: numbered,
    body,
  )
}

#let corollary(
  title: none,
  numbered: true,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
  body,
) = context {
  let dark = _is-dark.get()
  let cfg = _cfg.get()
  _theorem-base(
    axi.corollary-counter,
    "Corollary",
    _theme-for(
      "corollary",
      dark: dark,
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
      gap: gap,
      cfg: cfg,
    ),
    title: title,
    numbered: numbered,
    body,
  )
}

#let example(
  title: none,
  numbered: true,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
  body,
) = context {
  let dark = _is-dark.get()
  let cfg = _cfg.get()
  _theorem-base(
    axi.example-counter,
    "Example",
    _theme-for(
      "example",
      dark: dark,
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
      gap: gap,
      cfg: cfg,
    ),
    title: title,
    numbered: numbered,
    body,
  )
}

#let remark(
  title: none,
  numbered: true,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
  body,
) = context {
  let dark = _is-dark.get()
  let cfg = _cfg.get()
  _theorem-base(
    remark-counter,
    "Remark",
    _theme-for(
      "remark",
      dark: dark,
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
      gap: gap,
      cfg: cfg,
    ),
    title: title,
    numbered: numbered,
    body,
  )
}

// Proof（无彩色填充，直接代理）
#let proof(body, qed-symbol: "fill") = axi.proof(
  body,
  qed-symbol: qed-symbol,
)

// Instructions（固定 yellow.lighten(90%) 背景，直接代理）
#let instructions(body) = axi.instructions(body)

// ============================================================
// 转发 axiomst 其余导出（无颜色覆盖项）
// ============================================================
#let problem-counter = axi.problem-counter
#let theorem-counter = axi.theorem-counter
#let definition-counter = axi.definition-counter
#let example-counter = axi.example-counter
#let num-counter = axi.num-counter

#let homework = axi.homework
#let only = axi.only
#let pause = axi.pause
#let section-slide = axi.section-slide
#let slide = axi.slide
#let slides = axi.slides
#let title-slide = axi.title-slide
#let uncover = axi.uncover
#let theorem-base = axi.theorem-base

// ============================================================
// 🔧 统一配置接口（供导入方自定义参数）
// ============================================================
//   #show: style_apply.with(
//     inset-x: 1.2em,          // 所有块左右内边距
//     problem-gap: 2em,         // 只改 Problem 块间距
//     theorem-color: teal,      // 只改 Theorem 颜色
//     lemma-color: green,       // 只改 Lemma 颜色
//   )

#let configure(
  body,
  show-solutions: auto,
  fill-l: auto,
  fill-l-dark: auto,
  fill-l-light: auto,
  title-l: auto,
  title-l-dark: auto,
  title-l-light: auto,
  stroke-d: auto,
  stroke-d-dark: auto,
  stroke-d-light: auto,
  problem-color: auto,
  problem-color-dark: auto,
  problem-color-light: auto,
  theorem-color: auto,
  theorem-color-dark: auto,
  theorem-color-light: auto,
  lemma-color: auto,
  lemma-color-dark: auto,
  lemma-color-light: auto,
  definition-color: auto,
  definition-color-dark: auto,
  definition-color-light: auto,
  proposition-color: auto,
  proposition-color-dark: auto,
  proposition-color-light: auto,
  corollary-color: auto,
  corollary-color-dark: auto,
  corollary-color-light: auto,
  example-color: auto,
  example-color-dark: auto,
  example-color-light: auto,
  remark-color: auto,
  remark-color-dark: auto,
  remark-color-light: auto,
  radius: auto,
  radius-dark: auto,
  radius-light: auto,
  inset-x: auto,
  inset-x-dark: auto,
  inset-x-light: auto,
  inset-y: auto,
  inset-y-dark: auto,
  inset-y-light: auto,
  gap: auto,
  problem-gap: auto,
  theorem-gap: auto,
  lemma-gap: auto,
  definition-gap: auto,
  proposition-gap: auto,
  corollary-gap: auto,
  example-gap: auto,
  remark-gap: auto,
) = {
  let ov = (:)
  if show-solutions != auto { ov.insert("show-solutions", show-solutions) }
  if fill-l != auto { ov.insert("fill-l", fill-l) }
  if title-l != auto { ov.insert("title-l", title-l) }
  if stroke-d != auto { ov.insert("stroke-d", stroke-d) }
  if fill-l-dark != auto { ov.insert("fill-l-dark", fill-l-dark) }
  if fill-l-light != auto { ov.insert("fill-l-light", fill-l-light) }
  if title-l-dark != auto { ov.insert("title-l-dark", title-l-dark) }
  if title-l-light != auto { ov.insert("title-l-light", title-l-light) }
  if stroke-d-dark != auto { ov.insert("stroke-d-dark", stroke-d-dark) }
  if stroke-d-light != auto { ov.insert("stroke-d-light", stroke-d-light) }
  if problem-color != auto { ov.insert("problem-color", problem-color) }
  if problem-color-dark != auto {
    ov.insert("problem-color-dark", problem-color-dark)
  }
  if problem-color-light != auto {
    ov.insert("problem-color-light", problem-color-light)
  }
  if theorem-color != auto { ov.insert("theorem-color", theorem-color) }
  if theorem-color-dark != auto {
    ov.insert("theorem-color-dark", theorem-color-dark)
  }
  if theorem-color-light != auto {
    ov.insert("theorem-color-light", theorem-color-light)
  }
  if lemma-color != auto { ov.insert("lemma-color", lemma-color) }
  if lemma-color-dark != auto {
    ov.insert("lemma-color-dark", lemma-color-dark)
  }
  if lemma-color-light != auto {
    ov.insert("lemma-color-light", lemma-color-light)
  }
  if definition-color != auto {
    ov.insert("definition-color", definition-color)
  }
  if definition-color-dark != auto {
    ov.insert("definition-color-dark", definition-color-dark)
  }
  if definition-color-light != auto {
    ov.insert("definition-color-light", definition-color-light)
  }
  if proposition-color != auto {
    ov.insert("proposition-color", proposition-color)
  }
  if proposition-color-dark != auto {
    ov.insert("proposition-color-dark", proposition-color-dark)
  }
  if proposition-color-light != auto {
    ov.insert("proposition-color-light", proposition-color-light)
  }
  if corollary-color != auto { ov.insert("corollary-color", corollary-color) }
  if corollary-color-dark != auto {
    ov.insert("corollary-color-dark", corollary-color-dark)
  }
  if corollary-color-light != auto {
    ov.insert("corollary-color-light", corollary-color-light)
  }
  if example-color != auto { ov.insert("example-color", example-color) }
  if example-color-dark != auto {
    ov.insert("example-color-dark", example-color-dark)
  }
  if example-color-light != auto {
    ov.insert("example-color-light", example-color-light)
  }
  if remark-color != auto { ov.insert("remark-color", remark-color) }
  if remark-color-dark != auto {
    ov.insert("remark-color-dark", remark-color-dark)
  }
  if remark-color-light != auto {
    ov.insert("remark-color-light", remark-color-light)
  }
  if radius != auto { ov.insert("radius", radius) }
  if radius-dark != auto { ov.insert("radius-dark", radius-dark) }
  if radius-light != auto { ov.insert("radius-light", radius-light) }
  if inset-x != auto { ov.insert("inset-x", inset-x) }
  if inset-x-dark != auto { ov.insert("inset-x-dark", inset-x-dark) }
  if inset-x-light != auto { ov.insert("inset-x-light", inset-x-light) }
  if inset-y != auto { ov.insert("inset-y", inset-y) }
  if inset-y-dark != auto { ov.insert("inset-y-dark", inset-y-dark) }
  if inset-y-light != auto { ov.insert("inset-y-light", inset-y-light) }
  if problem-gap != auto { ov.insert("problem-gap", problem-gap) }
  if theorem-gap != auto { ov.insert("theorem-gap", theorem-gap) }
  if lemma-gap != auto { ov.insert("lemma-gap", lemma-gap) }
  if definition-gap != auto { ov.insert("definition-gap", definition-gap) }
  if proposition-gap != auto { ov.insert("proposition-gap", proposition-gap) }
  if corollary-gap != auto { ov.insert("corollary-gap", corollary-gap) }
  if example-gap != auto { ov.insert("example-gap", example-gap) }
  if remark-gap != auto { ov.insert("remark-gap", remark-gap) }
  _cfg.update(old => old + ov)
  body
}

// ⚡ 深色 / 浅色入口
#let style_apply(
  body,
  show-solutions: auto,
  page-paper: "a4",
  page-margin: (top: 1%, rest: 5%),
  text-size: 12pt,
  fill-l: auto,
  fill-l-dark: auto,
  fill-l-light: auto,
  title-l: auto,
  title-l-dark: auto,
  title-l-light: auto,
  stroke-d: auto,
  stroke-d-dark: auto,
  stroke-d-light: auto,
  problem-color: auto,
  problem-color-dark: auto,
  problem-color-light: auto,
  theorem-color: auto,
  theorem-color-dark: auto,
  theorem-color-light: auto,
  lemma-color: auto,
  lemma-color-dark: auto,
  lemma-color-light: auto,
  definition-color: auto,
  definition-color-dark: auto,
  definition-color-light: auto,
  proposition-color: auto,
  proposition-color-dark: auto,
  proposition-color-light: auto,
  corollary-color: auto,
  corollary-color-dark: auto,
  corollary-color-light: auto,
  example-color: auto,
  example-color-dark: auto,
  example-color-light: auto,
  remark-color: auto,
  remark-color-dark: auto,
  remark-color-light: auto,
  radius: auto,
  radius-dark: auto,
  radius-light: auto,
  inset-x: auto,
  inset-x-dark: auto,
  inset-x-light: auto,
  inset-y: auto,
  inset-y-dark: auto,
  inset-y-light: auto,
  problem-gap: auto,
  theorem-gap: auto,
  lemma-gap: auto,
  definition-gap: auto,
  proposition-gap: auto,
  corollary-gap: auto,
  example-gap: auto,
  remark-gap: auto,
) = {
  body = configure(
    body,
    show-solutions: show-solutions,
    fill-l: fill-l,
    fill-l-dark: fill-l-dark,
    fill-l-light: fill-l-light,
    title-l: title-l,
    title-l-dark: title-l-dark,
    title-l-light: title-l-light,
    stroke-d: stroke-d,
    stroke-d-dark: stroke-d-dark,
    stroke-d-light: stroke-d-light,
    problem-color: problem-color,
    problem-color-dark: problem-color-dark,
    problem-color-light: problem-color-light,
    theorem-color: theorem-color,
    theorem-color-dark: theorem-color-dark,
    theorem-color-light: theorem-color-light,
    lemma-color: lemma-color,
    lemma-color-dark: lemma-color-dark,
    lemma-color-light: lemma-color-light,
    definition-color: definition-color,
    definition-color-dark: definition-color-dark,
    definition-color-light: definition-color-light,
    proposition-color: proposition-color,
    proposition-color-dark: proposition-color-dark,
    proposition-color-light: proposition-color-light,
    corollary-color: corollary-color,
    corollary-color-dark: corollary-color-dark,
    corollary-color-light: corollary-color-light,
    example-color: example-color,
    example-color-dark: example-color-dark,
    example-color-light: example-color-light,
    remark-color: remark-color,
    remark-color-dark: remark-color-dark,
    remark-color-light: remark-color-light,
    radius: radius,
    radius-dark: radius-dark,
    radius-light: radius-light,
    inset-x: inset-x,
    inset-x-dark: inset-x-dark,
    inset-x-light: inset-x-light,
    inset-y: inset-y,
    inset-y-dark: inset-y-dark,
    inset-y-light: inset-y-light,
    problem-gap: problem-gap,
    theorem-gap: theorem-gap,
    lemma-gap: lemma-gap,
    definition-gap: definition-gap,
    proposition-gap: proposition-gap,
    corollary-gap: corollary-gap,
    example-gap: example-gap,
    remark-gap: remark-gap,
  )
  _is-dark.update(true)
  dark_mode(_base-style(
    body,
    page-paper: page-paper,
    page-margin: page-margin,
    text-size: text-size,
  ))
}

#let style_apply_light(
  body,
  show-solutions: auto,
  page-paper: "a4",
  page-margin: (top: 1%, rest: 5%),
  text-size: 12pt,
  fill-l: auto,
  fill-l-dark: auto,
  fill-l-light: auto,
  title-l: auto,
  title-l-dark: auto,
  title-l-light: auto,
  stroke-d: auto,
  stroke-d-dark: auto,
  stroke-d-light: auto,
  problem-color: auto,
  problem-color-dark: auto,
  problem-color-light: auto,
  theorem-color: auto,
  theorem-color-dark: auto,
  theorem-color-light: auto,
  lemma-color: auto,
  lemma-color-dark: auto,
  lemma-color-light: auto,
  definition-color: auto,
  definition-color-dark: auto,
  definition-color-light: auto,
  proposition-color: auto,
  proposition-color-dark: auto,
  proposition-color-light: auto,
  corollary-color: auto,
  corollary-color-dark: auto,
  corollary-color-light: auto,
  example-color: auto,
  example-color-dark: auto,
  example-color-light: auto,
  remark-color: auto,
  remark-color-dark: auto,
  remark-color-light: auto,
  radius: auto,
  radius-dark: auto,
  radius-light: auto,
  inset-x: auto,
  inset-x-dark: auto,
  inset-x-light: auto,
  inset-y: auto,
  inset-y-dark: auto,
  inset-y-light: auto,
  problem-gap: auto,
  theorem-gap: auto,
  lemma-gap: auto,
  definition-gap: auto,
  proposition-gap: auto,
  corollary-gap: auto,
  example-gap: auto,
  remark-gap: auto,
) = {
  body = configure(
    body,
    show-solutions: show-solutions,
    fill-l: fill-l,
    fill-l-dark: fill-l-dark,
    fill-l-light: fill-l-light,
    title-l: title-l,
    title-l-dark: title-l-dark,
    title-l-light: title-l-light,
    stroke-d: stroke-d,
    stroke-d-dark: stroke-d-dark,
    stroke-d-light: stroke-d-light,
    problem-color: problem-color,
    problem-color-dark: problem-color-dark,
    problem-color-light: problem-color-light,
    theorem-color: theorem-color,
    theorem-color-dark: theorem-color-dark,
    theorem-color-light: theorem-color-light,
    lemma-color: lemma-color,
    lemma-color-dark: lemma-color-dark,
    lemma-color-light: lemma-color-light,
    definition-color: definition-color,
    definition-color-dark: definition-color-dark,
    definition-color-light: definition-color-light,
    proposition-color: proposition-color,
    proposition-color-dark: proposition-color-dark,
    proposition-color-light: proposition-color-light,
    corollary-color: corollary-color,
    corollary-color-dark: corollary-color-dark,
    corollary-color-light: corollary-color-light,
    example-color: example-color,
    example-color-dark: example-color-dark,
    example-color-light: example-color-light,
    remark-color: remark-color,
    remark-color-dark: remark-color-dark,
    remark-color-light: remark-color-light,
    radius: radius,
    radius-dark: radius-dark,
    radius-light: radius-light,
    inset-x: inset-x,
    inset-x-dark: inset-x-dark,
    inset-x-light: inset-x-light,
    inset-y: inset-y,
    inset-y-dark: inset-y-dark,
    inset-y-light: inset-y-light,
    problem-gap: problem-gap,
    theorem-gap: theorem-gap,
    lemma-gap: lemma-gap,
    definition-gap: definition-gap,
    proposition-gap: proposition-gap,
    corollary-gap: corollary-gap,
    example-gap: example-gap,
    remark-gap: remark-gap,
  )
  _is-dark.update(false)
  _base-style(
    body,
    page-paper: page-paper,
    page-margin: page-margin,
    text-size: text-size,
  )
}
