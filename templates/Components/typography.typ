
// typography.typ — 排版设置（字体/页边距/段落等）
#let style_apply(body) = {
  set page(
    "a4",
    margin: (top: 1%, rest: 5%),
  )

  set text(
    font: (
      (name: "New Computer Modern", covers: "latin-in-cjk"),
      "Source Han Serif SC",
    ),
    lang: "zh",
    region: "cn",
    size: 12pt,
  )

  set text(top-edge: "ascender", bottom-edge: "descender")

  set par(
    justify: true,
    leading: 0.75em,
    first-line-indent: (amount: 2em, all: true),
  )

  show raw: set text(font: (
    (name: "Maple Mono Normal NL NF", covers: "latin-in-cjk"),
    "Source Han Serif SC",
  ))

  // 数学模式：主字体用 New Computer Modern Math（有 MATH table），
  // 中文自动回退到 Source Han Serif SC
  show math.equation: set text(
    font: (
      "New Computer Modern Math",
      "Source Han Serif SC",
    ),
  )

  body
}
