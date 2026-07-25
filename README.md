# Typst 数学题集模板

基于 [axiomst](https://github.com/rezaarezvan/axiomst) + 自建深色模式，支持一键切换。

## 项目结构

```
├── examples/                # 全量参数示例
│   ├── dark_full_test.typ   # 深色模式全组件 + 全参数测试
│   └── light_full_test.typ  # 浅色模式全组件 + 全参数测试
├── problem_set/             # 题集源文件
│   └── 7.23credit.typ       # 示例文档
├── templates/               # 模板
│   ├── problem_set.typ          # 主模板（深色/浅色一键切换）
│   ├── simple_pset.typ       # 简单模板（无 axiomst）
│   └── Components/           # 核心组件
│       ├── typography.typ    # 排版设置（字体/页边距/段距）
│       ├── dark_mode.typ     # OKLCH 深色算法
│       └── invert-colors.typ # negate() 一键反转
└── target/                  # 编译输出（gitignore）
```

## 示例文件

`examples/` 目录下有完整的参数测试文件，覆盖所有组件和所有配置参数：

| 文件                           | 模式 | 内容                                   |
| ------------------------------ | ---- | -------------------------------------- |
| `examples/dark_full_test.typ`  | 深色 | 全组件渲染 + 行内参数覆盖 + 无标题编号 |
| `examples/light_full_test.typ` | 浅色 | 同上，浅色模式                         |

```bash
# 编译示例
typst compile --root . examples/dark_full_test.typ target/examples/dark.pdf
typst compile --root . examples/light_full_test.typ target/examples/light.pdf
```

## 快速开始

### 新建文档（推荐）

```typst
#import "../templates/problem_set.typ": *

#show: style_apply        // 深色模式（默认）
// #show: style_apply_light  // 浅色模式

= 标题
#problem(title: "例1")[
  题目内容……
]

#solution()[
  解答内容……
]
```

### 切换浅色

把 `#show: style_apply` 改成 `#show: style_apply_light`。
两种模式均支持下方全部配置参数，用法完全一致：

```typst
#show: style_apply_light.with(
  theorem-color: red,
  inset-x: 1.5em,
  problem-gap: 3em,
)
```

### 配色调整

三种方式，按需选择：

**① 通过 `style_apply.with(...)` 传参（推荐，不改模板源码）**

```typst
#show: style_apply.with(
  inset-x: 1.2em,           // 所有块左右内边距
  inset-y: 0.5em,            // 所有块上下内边距
  radius: 5%,                // 所有块圆角
  // ── 透明度（共享，深色浅色同时改）──
  fill-l: 85,                // body 淡度 (%)
  title-l: 65,               // 标题栏淡度 (%)
  // ── 透明度（模式专属，优先于共享）──
  fill-l-dark: 80,           // 仅深色模式 body 淡度
  fill-l-light: 95,          // 仅浅色模式 body 淡度
  title-l-dark: 60,          // 仅深色模式标题栏淡度
  title-l-light: 85,         // 仅浅色模式标题栏淡度
  stroke-d-dark: 10,         // 仅深色模式边框深度
  stroke-d-light: 10,        // 仅浅色模式边框深度
  // ── 颜色（共享，深色浅色同时改）──
  theorem-color: teal,
  lemma-color: green,
  // ── 颜色（模式专属，优先于共享）──
  theorem-color-dark: blue,  // 仅深色模式 theorem 颜色
  theorem-color-light: teal, // 仅浅色模式 theorem 颜色
  // ── 圆角 / 内边距（模式专属，优先于共享）──
  radius-dark: 10%,          // 仅深色模式圆角
  radius-light: 4pt,         // 仅浅色模式圆角
  inset-x-dark: 0em,         // 仅深色模式左右内边距
  inset-x-light: 0.6em,      // 仅浅色模式左右内边距
  inset-y-dark: 1em,         // 仅深色模式上下内边距
  inset-y-light: 0.6em,      // 仅浅色模式上下内边距
  // ── 每块独立间距 ──
  problem-gap: 2em,
  theorem-gap: 1em,
  lemma-gap: 0.8em,
  // ── 每块独立颜色（不改则保持默认）──
  problem-color: blue,
  definition-color: purple,
  proposition-color: red,
  corollary-color: orange,
  example-color: aqua,
  remark-color: gray,
)
```

支持的全部参数：

| 共享参数   | 说明           | 模式专属                 | 块专属 color        | 块专属 gap        |
| ---------- | -------------- | ------------------------ | ------------------- | ----------------- |
| `fill-l`   | body 淡度 (%)  | `fill-l-dark`/`-light`   | `problem-color`     | `problem-gap`     |
| `title-l`  | 标题栏淡度 (%) | `title-l-dark`/`-light`  | `theorem-color`     | `theorem-gap`     |
| `stroke-d` | 边框深度 (%)   | `stroke-d-dark`/`-light` | `lemma-color`       | `lemma-gap`       |
| `radius`   | 圆角           | `radius-dark`/`-light`   | `definition-color`  | `definition-gap`  |
| `inset-x`  | 左右内边距     | `inset-x-dark`/`-light`  | `proposition-color` | `proposition-gap` |
| `inset-y`  | 上下内边距     | `inset-y-dark`/`-light`  | `corollary-color`   | `corollary-gap`   |
|            |                |                          | `example-color`     | `example-gap`     |
|            |                |                          | `remark-color`      | `remark-gap`      |

每个块专属 color 同样支持模式专属变体：`problem-color-dark`/`problem-color-light` 等。

优先级统一为：**模式专属 key（`xxx-dark`/`xxx-light`）> 共享 key（`xxx`）> 模式默认值**

**② 编辑模板顶部面板**

```typst
#let _g-fill = 80     // 背景淡度（越大越淡）
#let _g-title = 60    // 标题栏淡度
#let _g-color = blue.darken(20%)  // 默认主题色
#let _g-radius = 4pt  // 圆角
```

每个框也可单独配：

```typst
_theme = (
  problem:    (color: ..., fill-l: ..., title-l: ..., gap: 1em),
  theorem:    (color: ..., fill-l: ..., title-l: ..., gap: 0.8em),
  definition: (color: ..., fill-l: ..., title-l: ..., gap: 0.8em),
  ...
)
```

## 可用组件

| 组件                                     | 用途                    |
| ---------------------------------------- | ----------------------- |
| `#problem(title: "", numbered: true)[…]` | 题目框（标题栏 + 底色） |
| `#solution()[…]`                         | 解答块                  |
| `#theorem(title: none)[…]`               | 定理                    |
| `#definition(title: none)[…]`            | 定义                    |
| `#lemma(title: none)[…]`                 | 引理                    |
| `#proposition(title: none)[…]`           | 命题                    |
| `#corollary(title: none)[…]`             | 推论                    |
| `#example(title: none)[…]`               | 示例                    |
| `#remark(title: none)[…]`                | 备注                    |
| `#proof(body, qed-symbol: "fill")`       | 证明                    |

## 单独使用深色模式

非 axiomst 文档也可用：

```typst
// OKLCH 精确算法
#import "/templates/Components/dark_mode.typ": dark_mode
#show: dark_mode

// 或 negate() 一键反转
#import "/templates/Components/invert-colors.typ": invert_colors
#show: invert_colors
```

## 编译

```bash
typst compile --root . problem_set/7.23credit.typ target/output.pdf
```

## tinymist 预览

预览默认启用了颜色反转。如果要和 PDF 保持一致，关掉：

```json
"tinymist.preview.background.args": [
  "--data-plane-host=127.0.0.1:23635",
  "--invert-colors=never"
]
```
