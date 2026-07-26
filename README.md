# Typst 数学题集模板

基于 [axiomst](https://github.com/rezaarezvan/axiomst) + 自建深色模式，提供独立的深色/浅色模板入口。

## 项目结构

```
├── examples/                # 全量参数示例
│   ├── dark_full_test.typ   # 深色模式全组件 + 全参数测试
│   └── light_full_test.typ  # 浅色模式全组件 + 全参数测试
├── problem_set/             # 题集源文件
│   └── 7.23credit.typ       # 示例文档
├── templates/               # 模板
│   ├── problem_set.typ       # 题集核心组件（公共实现）
│   ├── problem_set_dark.typ  # 深色模板入口（含 mitex）
│   ├── problem_set_light.typ # 浅色模板入口（含 mitex）
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


## 快速开始

### 新建文档（推荐）

```typst
#import "../templates/problem_set_dark.typ": *

#show: style_apply

= 标题
#problem(title: "例1")[
  题目内容……
]

#solution()[
  解答内容……
]
```

### 使用浅色模板

把导入文件改成 `problem_set_light.typ`，入口函数仍然是 `style_apply`：

```typst
#import "../templates/problem_set_light.typ": *
#show: style_apply
```

### 配色调整

通过 `style_apply.with(...)` 传参即可，不需要修改模板源码：

```typst
#show: style_apply.with(
  page-margin: (top: 1%, rest: 5%),
  text-size: 12pt,
  block-radius: 10%,
  block-inset: (x: 0.8em, y: 1em),
  fill-l: 80,     // body 淡度 (%)
  title-l: 60,    // 标题栏淡度 (%)
  stroke-d: 10,   // 边框深度 (%)
  colors: (
    problem: blue,
    theorem: teal,
    lemma: green,
    definition: purple,
    proposition: red,
    corollary: orange,
    example: aqua,
    remark: gray,
  ),
  gaps: (
    problem: 2em,
    theorem: 1em,
    lemma: 0.8em,
  ),
)
```

支持的全部参数：

| 参数 | 说明 |
| ---- | ---- |
| `page-margin` | 页面边距，如 `(top: 1%, rest: 5%)` |
| `text-size` | 正文字号 |
| `block-radius` | 所有题块圆角 |
| `block-inset` | 所有题块内边距，如 `(x: 0.8em, y: 1em)` |
| `fill-l` / `title-l` / `stroke-d` | 当前模板的块背景、标题栏和边框深浅 |
| `colors` | 按块名配置颜色：`problem`、`theorem`、`lemma`、`definition`、`proposition`、`corollary`、`example`、`remark` |
| `gaps` | 按块名配置块后间距 |

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
