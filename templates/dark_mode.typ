// dark_mode.typ — 通用 Chrome 风格深色模式（Typst 0.13+）
// 原理：OKLCH 颜色空间翻转 L 通道，保持色相和饱和度
// 用法：任何 .typ 文件加两行即可，不依赖任何第三方库
//   #import "dark_mode.typ": dark_mode
//   #show: dark_mode
//
// 导出工具：inv(color), shift(color, amount)

// ============================================================
// 核心颜色工具
// ============================================================

// 翻转亮度 — Chrome 风格强制深色模式
// OKLCH 空间翻转 L 通道，C（彩度）和 H（色相）保持不变
//
// 非线性亮度曲线（二次函数），三个锚点：
//   白色 L=1   → L' = 0     （纯黑，OLED 友好）
//   中灰 L=0.5 → L' = 0.5   （对称，中间色不偏暗）
//   黑色 L=0   → L' = #EEEEEE 的亮度（护眼不刺眼，Chrome 风格）
//
// 参数 max-light: 翻转后前景（原黑色）的目标亮度，0~1 之间的数字
//   默认 0.92 ≈ #EEEEEE（Chrome 风格）
//
// Typst 0.13 原生 API：
//   转换：oklch(color) — 任意颜色转 OKLCH
//   分量：color.components(alpha: true) → [l, c, h, alpha]
//   构造：oklch(l, c, h, alpha)
#let inv(c, max-light: 0.92) = {
  let p = oklch(c).components(alpha: true)
  // flipped = 1 - L（对称翻转后的亮度，0~1 纯数字）
  // components() 返回的是 ratio，除以 100% 得到纯数
  let flipped = (100% - p.at(0)) / 100%
  // 二次曲线：y = a*x² + b*x
  // 由 (0,0), (0.5,0.5), (1,max-light) 三点拟合
  let a = 2 * max-light - 2
  let b = 2 - max-light
  let new-l = a * flipped * flipped + b * flipped
  oklch(new-l * 100%, p.at(1), p.at(2), p.at(3))
}

// OKLCH 空间微调亮度（amount 是比例，如 5% 或 0.05）
#let shift(c, amount) = {
  let p = oklch(c).components(alpha: true)
  oklch(calc.clamp(p.at(0) + amount, 0%, 100%), p.at(1), p.at(2), p.at(3))
}

// 安全翻转：none / auto / 颜色 / stroke 字典 / 数组
#let _safe-inv(x) = {
  if x == none or x == auto { return none }
  if type(x) == "color" { return inv(x) }
  if type(x) == "dictionary" and "paint" in x {
    return (paint: inv(x.paint), ..x.removing("paint"))
  }
  if type(x) == "array" { return x.map(_safe-inv) }
  x
}

// 文字颜色状态：用 state 确保全局生效，不受 set 规则作用域影响
#let _text-color = state("_dark-text-color", inv(black))

// ============================================================
// 通用深色模式
// ============================================================

#let dark_mode(body) = {
  // 页面背景（白色翻转 = 纯黑 OLED）
  set page(fill: inv(white))

  // —— 文字 ——
  // state + context 保证颜色在所有作用域生效，不会被 style_apply 覆盖
  show text: it => context {
    text(fill: _text-color.get(), it)
  }

  // —— 数学公式 ——
  show math.equation: it => context {
    set text(fill: _text-color.get())
    it
  }

  // —— 链接 ——
  show link: it => context {
    link(fill: inv(link.fill), it)
  }

  // —— 高亮 ——
  show highlight: it => context {
    highlight(fill: inv(highlight.fill), it)
  }

  // —— Block / Box ——
  // show block / show box 不可用：在 Typst 中，容器元素
  // show 规则输出同类元素必然无限递归，counter/state
  // 在内容树构建之前不会生效，无法抑制递归。
  //
  // 对于 axiomst / showybox 等第三方库的彩色框，
  // 请在问题集专用文件（如 problem_set_dark.typ）中
  // 用 #let 重定义函数，替换配色参数。
  //
  // 通用深色模式覆盖的其他元素（text/raw/link/rect/
  // table/line 等）不受影响。
  show rect: it => context {
    let f = if rect.fill == none { none } else { inv(rect.fill) }
    let s = _safe-inv(rect.stroke)
    rect(fill: f, stroke: s, it)
  }

  // —— 正方形 ——
  show square: it => context {
    let f = if square.fill == none { none } else { inv(square.fill) }
    let s = _safe-inv(square.stroke)
    square(fill: f, stroke: s, it)
  }

  // —— 椭圆 ——
  show ellipse: it => context {
    let f = if ellipse.fill == none { none } else { inv(ellipse.fill) }
    let s = _safe-inv(ellipse.stroke)
    ellipse(fill: f, stroke: s, it)
  }

  // —— 圆形 ——
  show circle: it => context {
    let f = if circle.fill == none { none } else { inv(circle.fill) }
    let s = _safe-inv(circle.stroke)
    circle(fill: f, stroke: s, it)
  }

  // —— 多边形 ——
  show polygon: it => context {
    let f = if polygon.fill == none { none } else { inv(polygon.fill) }
    let s = _safe-inv(polygon.stroke)
    polygon(fill: f, stroke: s, it)
  }

  // —— 曲线 / 路径 ——
  show curve: it => context {
    let f = if curve.fill == none { none } else { inv(curve.fill) }
    let s = _safe-inv(curve.stroke)
    curve(fill: f, stroke: s, it)
  }

  // —— 表格 ——
  show table: it => context {
    let f = if table.fill == none { none } else { inv(table.fill) }
    let s = _safe-inv(table.stroke)
    table(
      fill: f,
      stroke: s,
      it,
    )
  }

  // —— 水平线 ——
  show line: it => context {
    line(stroke: _safe-inv(line.stroke), it)
  }

  // —— 下划线 ——
  show underline: it => context {
    underline(stroke: _safe-inv(underline.stroke), it)
  }

  // —— 删除线 ——
  show strike: it => context {
    strike(stroke: _safe-inv(strike.stroke), it)
  }

  // —— 上划线 ——
  show overline: it => context {
    overline(stroke: _safe-inv(overline.stroke), it)
  }

  // —— 图片 ——
  // Chrome 默认不翻转图片，保持原样

  body
}
