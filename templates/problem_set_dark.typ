// problem_set_dark.typ — axiomst + dark_mode 集成
// 直接 import 这个文件替代 problem_set.typ 即可
//
// 用法：
//   #import "../templates/problem_set_dark.typ": *
//   #show: style_apply
//   #show: dark_mode
//
// 原理：axiomst 的所有彩色框（problem/theorem/definition 等）
// 的 fill/stroke 都是从 color 参数派生的，只需把 color 换成
// 翻转后的值，所有派生颜色自动正确。

// 基础模板：导入原始 style_apply 作为 _base
#import "problem_set.typ": style_apply as _base-style

// 深色模式
#import "dark_mode.typ": dark_mode, inv

// ============================================================
// axiomst 函数的深色版本
// ============================================================
// 不依赖 axiomst 内部的 lighten/darken 派生，直接算最终暗色

#import "@preview/showybox:2.0.4": showybox

// axiomst 原始包（计数器、proof、instructions 等非颜色项）
#import "@preview/axiomst:0.2.1" as axi
// 颜色无关函数直接转发
#import "@preview/axiomst:0.2.1": *

// 默认暗色配色：取 axiomst 浅色方案 → inv() 翻转 → 暗色
#let _dark-fill(c) = inv(c.lighten(95%))   // body 背景
#let _dark-title(c) = inv(c.lighten(85%))  // 标题栏背景
#let _dark-stroke(c) = inv(c.darken(10%))  // 边框

// 暗色 theorem-base（直写，不调 axi.theorem-base）
#let _dark-theorem-base(
  ctr,
  prefix,
  title: none,
  numbered: true,
  color: blue.darken(20%),
  body,
) = context {
  let number = if numbered {
    ctr.step()
    context ctr.display()
  }
  block(
    width: 100%,
    fill: _dark-fill(color),
    radius: 4pt,
    stroke: _dark-stroke(color),
    inset: 0.6em,
  )[
    #text(fill: inv(black), weight: "bold")[#prefix #if numbered { number }]
    #if title != none [#text(fill: inv(black), style: "italic")[#title].]
    #v(0.5em)
    #body
  ]
}

// Problem（直调 showybox，暗色配色）
#let problem(
  title: "",
  color: blue.darken(20%),
  numbered: true,
  ..body,
) = {
  if numbered {
    [== Problem #axi.problem-counter.step() #context axi.problem-counter.display()]
  }
  showybox(
    frame: (
      border-color: _dark-stroke(color),
      title-color: _dark-title(color),
      body-color: _dark-fill(color),
    ),
    title-style: (
      color: inv(black),
      weight: "bold",
    ),
    breakable: true,
    title: title,
    ..body,
  )
}

// Solution
#let solution(body) = axi.solution(body)

// Theorem
#let theorem(title: none, numbered: true, color: blue.darken(20%), body) = {
  _dark-theorem-base(
    axi.theorem-counter,
    "Theorem",
    title: title,
    numbered: numbered,
    color: color,
    body,
  )
}

// Lemma
#let lemma(title: none, numbered: true, color: green.darken(20%), body) = {
  _dark-theorem-base(
    axi.lemma-counter,
    "Lemma",
    title: title,
    numbered: numbered,
    color: color,
    body,
  )
}

// Definition
#let definition(
  title: none,
  numbered: true,
  color: purple.darken(20%),
  body,
) = {
  _dark-theorem-base(
    axi.definition-counter,
    "Definition",
    title: title,
    numbered: numbered,
    color: color,
    body,
  )
}

// Proposition
#let proposition(title: none, numbered: true, color: red.darken(20%), body) = {
  _dark-theorem-base(
    axi.proposition-counter,
    "Proposition",
    title: title,
    numbered: numbered,
    color: color,
    body,
  )
}

// Corollary
#let corollary(title: none, numbered: true, color: orange.darken(20%), body) = {
  _dark-theorem-base(
    axi.corollary-counter,
    "Corollary",
    title: title,
    numbered: numbered,
    color: color,
    body,
  )
}

// Example
#let example(title: none, numbered: true, color: aqua.darken(20%), body) = {
  _dark-theorem-base(
    axi.example-counter,
    "Example",
    title: title,
    numbered: numbered,
    color: color,
    body,
  )
}

// Remark
#let remark(title: none, numbered: true, color: gray.darken(20%), body) = {
  _dark-theorem-base(
    axi.definition-counter,
    "Remark",
    title: title,
    numbered: numbered,
    color: color,
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

// style_apply = 原始版 + dark_mode，自动开启深色模式
#let style_apply(body) = {
  dark_mode(_base-style(body))
}
