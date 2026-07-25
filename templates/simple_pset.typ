#import "@preview/stux-assignment:0.1.0": *
#import "/templates/Components/dark_mode.typ": *
#show: dark_mode
#_theme-state.update((
  bg: rgb("#02121d"), // 題目框內部也是純黑，保持像素熄滅
  fr: rgb("#05216e")  // 題目框左側線條與標題：高亮度發光淺藍
))


#set text(
  font: (
    (name: "New Computer Modern", covers: "latin-in-cjk"),
    "Source Han Serif SC",
  ),
  lang: "zh",
  region: "cn",
  size: 18pt
)

#set text(top-edge: "ascender", bottom-edge: "descender")
#set par(
  justify: true,
  leading: 0.75em,
  first-line-indent: (amount: 2em, all: true),
)


#show raw: set text(font: (
  (name: "DejaVu Sans Mono", covers: "latin-in-cjk"),
  "Noto Sans CJK SC",
))








#problem()[
  State your first problem here. 张忠波
]

#solution[
  Write your solution here.
]

#problem(title: [— Bonus])[
  State your second problem here.
]

#solution[
  Write your solution here.
]