// 浅色题集模板入口。
// 用户只需要在这里传当前浅色模板的参数，不需要理解深浅色覆盖关系。

#import "@preview/mitex:0.2.7": *
#import "problem_set.typ" as core

#let problem = core.problem
#let solution = core.solution
#let theorem = core.theorem
#let lemma = core.lemma
#let definition = core.definition
#let proposition = core.proposition
#let corollary = core.corollary
#let example = core.example
#let remark = core.remark
#let proof = core.proof
#let instructions = core.instructions

#let problem-counter = core.problem-counter
#let theorem-counter = core.theorem-counter
#let definition-counter = core.definition-counter
#let example-counter = core.example-counter
#let num-counter = core.num-counter
#let proposition-counter = core.proposition-counter
#let remark-counter = core.remark-counter

#let homework = core.homework
#let only = core.only
#let pause = core.pause
#let section-slide = core.section-slide
#let slide = core.slide
#let slides = core.slides
#let title-slide = core.title-slide
#let uncover = core.uncover
#let theorem-base = core.theorem-base

#let _get(dict, key, default: auto) = if key in dict { dict.at(key) } else { default }

#let style_apply(
  body,
  page-paper: "a4",
  page-margin: (top: 1%, rest: 5%),
  text-size: 12pt,
  block-radius: 4pt,
  block-inset: (x: 0.6em, y: 0.6em),
  fill-l: 95,
  title-l: 85,
  stroke-d: 10,
  colors: (:),
  gaps: (:),
  show-solutions: auto,
) = core.style_apply_light(
  body,
  page-paper: page-paper,
  page-margin: page-margin,
  text-size: text-size,
  show-solutions: show-solutions,
  radius: block-radius,
  inset-x: _get(block-inset, "x"),
  inset-y: _get(block-inset, "y"),
  fill-l: fill-l,
  title-l: title-l,
  stroke-d: stroke-d,
  problem-color: _get(colors, "problem"),
  theorem-color: _get(colors, "theorem"),
  lemma-color: _get(colors, "lemma"),
  definition-color: _get(colors, "definition"),
  proposition-color: _get(colors, "proposition"),
  corollary-color: _get(colors, "corollary"),
  example-color: _get(colors, "example"),
  remark-color: _get(colors, "remark"),
  problem-gap: _get(gaps, "problem"),
  theorem-gap: _get(gaps, "theorem"),
  lemma-gap: _get(gaps, "lemma"),
  definition-gap: _get(gaps, "definition"),
  proposition-gap: _get(gaps, "proposition"),
  corollary-gap: _get(gaps, "corollary"),
  example-gap: _get(gaps, "example"),
  remark-gap: _get(gaps, "remark"),
)
