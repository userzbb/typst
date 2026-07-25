#import "../templates/problem_set.typ": *

// ╔══════════════════════════════════════════════════════════╗
// ║  全量示例：所有组件 + 所有参数（深色模式）                    ║
// ╚══════════════════════════════════════════════════════════╝

#show: style_apply.with(
  // ── 透明度：共享 ──
  fill-l: 82,
  title-l: 62,
  stroke-d: 12,
  // ── 透明度：模式专属（优先于共享）──
  fill-l-dark: 78,
  fill-l-light: 96,
  title-l-dark: 58,
  title-l-light: 88,
  stroke-d-dark: 15,
  stroke-d-light: 8,
  // ── 颜色：共享 ──
  problem-color: blue.darken(10%),
  theorem-color: blue.darken(20%),
  lemma-color: green.darken(20%),
  definition-color: purple.darken(20%),
  proposition-color: red.darken(20%),
  corollary-color: orange.darken(20%),
  example-color: aqua.darken(20%),
  remark-color: gray.darken(20%),
  // ── 颜色：模式专属（优先于共享）──
  theorem-color-dark: teal.darken(15%),
  theorem-color-light: teal,
  lemma-color-dark: green.darken(30%),
  lemma-color-light: green,
  definition-color-dark: purple.darken(30%),
  definition-color-light: purple,
  // ── 圆角：共享 + 模式专属 ──
  radius: 8%,
  radius-dark: 12%,
  radius-light: 4pt,
  // ── 内边距：共享 + 模式专属 ──
  inset-x: 0.5em,
  inset-y: 0.8em,
  inset-x-dark: 0.8em,
  inset-x-light: 0.6em,
  inset-y-dark: 1.2em,
  inset-y-light: 0.6em,
  // ── 每块独立间距 ──
  problem-gap: 2em,
  theorem-gap: 1.5em,
  lemma-gap: 1.2em,
  definition-gap: 1em,
  proposition-gap: 0.9em,
  corollary-gap: 0.9em,
  example-gap: 0.9em,
  remark-gap: 1em,
  // ── 解答显示 ──
  show-solutions: true,
)

= 测试 1：深色模式 - 全组件默认渲染

#problem(title: "Problem 默认渲染")[
  这是一个 problem 块，测试默认参数下的渲染效果。
  包含多行内容以测试内边距和间距。
  第三行。
]

#solution[
  这是 problem 对应的解答内容。测试 solution 组件。
]

#theorem(title: "基本定理")[
  设 $f: A -> B$ 是从集合 $A$ 到集合 $B$ 的映射，若 $f$ 是双射，则 $f$ 存在逆映射 $f^(-1): B -> A$。
]

#lemma(title: "辅助引理")[
  任意有限非空集合 $S$ 的基数 $|S| >= 1$。
]

#definition(title: "群的定义")[
  一个群是一个有序对 $(G, *)$，其中 $G$ 是非空集合，$*$ 是 $G$ 上的二元运算，满足：封闭性、结合律、存在单位元、存在逆元。
]

#proposition(title: "命题示例")[
  若 $p$ 是素数且 $p | a b$，则 $p | a$ 或 $p | b$。
]

#corollary(title: "推论示例")[
  由此可得，$sqrt(2)$ 是无理数。
]

#example(title: "示例")[
  考虑函数 $f(x) = x^2$，当 $x = 3$ 时，$f(3) = 9$。
]

#remark(title: "备注")[
  上述定理的证明用到了 Zorn 引理。
]

#proof[
  对任意 $epsilon > 0$，存在 $delta > 0$，使得当 $0 < |x - a| < delta$ 时，$|f(x) - L| < epsilon$。证毕。
]

---

= 测试 2：行内参数覆盖（函数级传参）

#problem(title: "行内覆盖颜色", color: red)[
  这个 problem 块通过函数参数直接覆盖颜色为 red。
]

#problem(title: "行内覆盖透明度", fill-l: 50, title-l: 30)[
  这个 problem 块通过函数参数直接覆盖 fill-l=50, title-l=30。
]

#problem(title: "行内覆盖内边距", inset-x: 2em, inset-y: 2em)[
  这个 problem 块通过函数参数直接覆盖 inset-x=2em, inset-y=2em。
]

#theorem(title: "行内覆盖颜色+透明度", color: red, fill-l: 60, gap: 3em)[
  这个 theorem 块覆盖了 color=red, fill-l=60, gap=3em。
]

#lemma(title: "行内覆盖 stroke-d", stroke-d: 30)[
  这个 lemma 块覆盖了 stroke-d=30，边框应该更深。
]

---

= 测试 3：无标题编号渲染

#theorem(numbered: false)[
  这是一个没有编号也没有标题的定理。
]

#definition(numbered: false)[
  这是一个没有编号的定义。
]

#problem(title: "", numbered: false)[
  这是一个没有编号的题目。
]

---

= 测试 4：解答显示控制（show-solutions: true）

顶部配置了 `show-solutions: true`，以下 solution 正常显示。

#problem(title: "解答显示测试")[
  这个题目的 solution 应该可见。
]

#solution[
  ✓ 你能看到这段解答，说明 show-solutions: true 生效了。
]
