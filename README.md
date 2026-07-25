# Typst 数学题集模板

基于 [axiomst](https://github.com/rezaarezvan/axiomst) + 自建深色模式，支持一键切换。

## 项目结构

```
├── problem_set/              # 题集源文件
│   └── 7.23credit.typ        # 示例文档
├── templates/                # 模板
│   ├── problem_set_dark.typ  # 主模板（深色 + 浅色切换）
│   ├── simple_pset.typ       # 简单模板（无 axiomst）
│   └── Components/           # 核心组件
│       ├── typography.typ    # 排版设置（字体/页边距/段距）
│       ├── dark_mode.typ     # OKLCH 深色算法
│       └── invert-colors.typ # negate() 一键反转
└── target/                   # 编译输出（gitignore）
```

## 快速开始

### 新建文档（推荐）

```typst
#import "../templates/problem_set_dark.typ": *

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

### 配色调整

编辑 `templates/problem_set_dark.typ` 顶部面板：

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
