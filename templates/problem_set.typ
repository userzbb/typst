// problem_set_dark.typ — axiomst 深色模板，含浅色一键切换
// 用法： #import "../templates/problem_set_dark.typ": *
//        #show: style_apply        // 深色
//        #show: style_apply_light  // 浅色

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
#let _g-fill = 80     // body 淡度（%）
#let _g-title = 60    // 标题栏淡度（%）
#let _g-stroke = 10   // 边框深度（%）
#let _g-color = blue.darken(20%)  // 默认主题色
#let _g-radius = 10%  // 圆角
#let _g-inset-x = 0em // 内边距——左右
#let _g-inset-y = 1em  // 内边距——上下

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

// 从面板取主题，允许外部覆盖 color/fill-l/title-l/stroke-d
#let _theme-for(
  name,
  color: auto,
  fill-l: auto,
  title-l: auto,
  stroke-d: auto,
  gap: auto,
) = {
  let t = _theme.at(name)
  if color == auto { color = t.color }
  if fill-l == auto { fill-l = t.fill-l }
  if title-l == auto { title-l = t.title-l }
  if stroke-d == auto { stroke-d = t.stroke-d }
  if gap == auto { gap = t.gap }
  (color: color, fill-l: fill-l, title-l: title-l, stroke-d: stroke-d, gap: gap)
}

// 根据主题参数计算最终暗色
#let _dark-fill(t) = inv(t.color.lighten(t.fill-l * 1%))
#let _dark-title(t) = inv(t.color.lighten(t.title-l * 1%))
#let _dark-stroke(t) = inv(t.color.darken(t.stroke-d * 1%))

// 暗色 theorem-base（直写，不调 axi.theorem-base）
#let _dark-theorem-base(
  ctr,
  prefix,
  theme,
  title: none,
  numbered: true,
  body,
) = context {
  let number = if numbered {
    ctr.step()
    context ctr.display()
  }
  (
    block(
      width: 100%,
      fill: _dark-fill(theme),
      radius: _g-radius,
      stroke: _dark-stroke(theme),
      inset: (x: _g-inset-x, y: _g-inset-y),
    )[
      #text(fill: inv(black), weight: "bold")[#prefix #if numbered { number }]
      #if title != none [#text(fill: inv(black), style: "italic")[#title].]
      #v(0.5em)
      #body
    ]
      + v(theme.gap)
  )
}
}

// ⚡ 暗色模式开关
#let _is-dark = state("_pset-dark-mode", true)

// Problem（直调 showybox，暗色配色）
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
  if _is-dark.get() {
    let t = _theme-for(
      "problem",
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
      gap: gap,
    )
    let ix = if inset-x == auto { _g-inset-x } else { inset-x }
    let iy = if inset-y == auto { _g-inset-y } else { inset-y }
    if numbered {
      [== Problem #axi.problem-counter.step() #context axi.problem-counter.display()]
    }
    showybox(
      frame: (
        border-color: _dark-stroke(t),
        title-color: _dark-title(t),
        body-color: _dark-fill(t),
        body-inset: (x: ix, y: iy),
      ),
      title-style: (color: inv(black), weight: "bold"),
      breakable: true,
      title: title,
      body,
    )
    v(t.gap)
  } else {
    axi.problem(title: title, numbered: numbered, body)
  }
}

// Solution
#let solution(body) = axi.solution(body)

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
  if _is-dark.get() {
    _dark-theorem-base(
      axi.theorem-counter,
      "Theorem",
      _theme-for(
        "theorem",
        color: color,
        fill-l: fill-l,
        title-l: title-l,
        stroke-d: stroke-d,
        gap: gap,
      ),
      title: title,
      numbered: numbered,
      body,
    )
  } else {
    axi.theorem(title: title, numbered: numbered, body)
  }
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
  if _is-dark.get() {
    _dark-theorem-base(
      axi.lemma-counter,
      "Lemma",
      _theme-for(
        "lemma",
        color: color,
        fill-l: fill-l,
        title-l: title-l,
        stroke-d: stroke-d,
        gap: gap,
      ),
      title: title,
      numbered: numbered,
      body,
    )
  } else {
    axi.lemma(title: title, numbered: numbered, body)
  }
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
  if _is-dark.get() {
    _dark-theorem-base(
      axi.definition-counter,
      "Definition",
      _theme-for(
        "definition",
        color: color,
        fill-l: fill-l,
        title-l: title-l,
        stroke-d: stroke-d,
        gap: gap,
      ),
      title: title,
      numbered: numbered,
      body,
    )
  } else {
    axi.definition(title: title, numbered: numbered, body)
  }
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
  if _is-dark.get() {
    _dark-theorem-base(
      axi.proposition-counter,
      "Proposition",
      _theme-for(
        "proposition",
        color: color,
        fill-l: fill-l,
        title-l: title-l,
        stroke-d: stroke-d,
        gap: gap,
      ),
      title: title,
      numbered: numbered,
      body,
    )
  } else {
    axi.proposition(title: title, numbered: numbered, body)
  }
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
  if _is-dark.get() {
    _dark-theorem-base(
      axi.corollary-counter,
      "Corollary",
      _theme-for(
        "corollary",
        color: color,
        fill-l: fill-l,
        title-l: title-l,
        stroke-d: stroke-d,
        gap: gap,
      ),
      title: title,
      numbered: numbered,
      body,
    )
  } else {
    axi.corollary(title: title, numbered: numbered, body)
  }
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
  if _is-dark.get() {
    _dark-theorem-base(
      axi.example-counter,
      "Example",
      _theme-for(
        "example",
        color: color,
        fill-l: fill-l,
        title-l: title-l,
        stroke-d: stroke-d,
        gap: gap,
      ),
      title: title,
      numbered: numbered,
      body,
    )
  } else {
    axi.example(title: title, numbered: numbered, body)
  }
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
  if _is-dark.get() {
    _dark-theorem-base(
      axi.definition-counter,
      "Remark",
      _theme-for(
        "remark",
        color: color,
        fill-l: fill-l,
        title-l: title-l,
        stroke-d: stroke-d,
        gap: gap,
      ),
      title: title,
      numbered: numbered,
      body,
    )
  } else {
    axi.remark(title: title, numbered: numbered, body)
  }
}
"proposition",
color: color,
fill-l: fill-l,
title-l: title-l,
stroke-d: stroke-d,
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
  body,
) = {
  _dark-theorem-base(
    axi.corollary-counter,
    "Corollary",
    _theme-for(
      "corollary",
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
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
  body,
) = {
  _dark-theorem-base(
    axi.example-counter,
    "Example",
    _theme-for(
      "example",
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
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
  body,
) = {
  _dark-theorem-base(
    axi.definition-counter,
    "Remark",
    _theme-for(
      "remark",
      color: color,
      fill-l: fill-l,
      title-l: title-l,
      stroke-d: stroke-d,
    ),
    title: title,
    numbered: numbered,
    body,
  )
}

// Proof（无彩色填充，直接代理）
#let proof(body, title: [Proof.], qed-symbol: "fill") = axi.proof(
  body,
  title: title,
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

// ⚡ 暗色模式开关
#let style_apply(body) = {
  _is-dark.update(true)
  dark_mode(_base-style(body))
}
#let style_apply_light(body) = {
  _is-dark.update(false)
  _base-style(body)
}
