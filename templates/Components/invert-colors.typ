// invert-colors.typ — 一键全局颜色反转（等效 tinymist --invert-colors=auto）
//
// 原理：Typst 内置 negate() = CSS filter: invert(1)，RGB 逐通道取反
//
// 用法：  #import "/templates/Components/invert-colors.typ": invert_colors
//         #show: invert_colors

// 安全取反：none/auto 原样
#let _n(c) = { if c == none or c == auto { c } else { c.negate() } }
#let _ns(s) = {
  if s == none or s == auto { return s }
  if type(s) == "color" { return s.negate() }
  if type(s) == "dictionary" and "paint" in s {
    return (paint: s.paint.negate(), ..s.removing("paint"))
  }
  if type(s) == "array" { return s.map(_ns) }
  s
}

// 文字颜色用 state 确保全局生效（不受 style_apply 等 set 规则覆盖）
#let _tc = state("_inv-text-color", black.negate())

#let invert_colors(body) = {
  set page(fill: white.negate())

  // 文字 — state 保证优先级最高
  show text: it => context { text(fill: _tc.get(), it) }

  // 数学
  show math.equation: it => context {
    set text(fill: _tc.get())
    it
  }

  // Block — Typst show 规则嵌套递归无解，需 block 反转请用 problem_set_dark.typ

  // Box → rect 取反（box 不嵌套，安全）
  show box: it => rect(
    fill: _n(it.fill),
    stroke: _ns(it.stroke),
    radius: it.radius,
    inset: it.inset,
    width: it.width,
    height: it.height,
    it,
  )

  // 表格 / 线条
  show table: it => table(
    fill: _n(it.fill),
    stroke: _ns(it.stroke),
    it,
  )
  show line: it => line(stroke: _ns(it.stroke), it)

  // 装饰
  show link: it => link(fill: _n(it.fill), it)
  show highlight: it => highlight(fill: _n(it.fill), it)
  show underline: it => underline(stroke: _ns(it.stroke), it)
  show strike: it => strike(stroke: _ns(it.stroke), it)
  show overline: it => overline(stroke: _ns(it.stroke), it)

  body
}
