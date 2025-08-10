## 介绍
Margin-mode 主要用来给不同的 major mode 的 buffer 所在的 window 设置左右 margin。众所周知，window margins 在当前窗口的 buffer 切换时就会失效，margin-mode 可以任何场景下都保持 margin。

除了保持 margin 不失效外，margin-mode 支持通过配置给不同的 major mode(及继承该模式的所有子模式)设置不同的左右 margin。当设置了 `margin-work-modes` 变量后，当前显示的窗口 margin 可以实时改变，无需重新加载 major mode。

## 使用
`margin-mode` 的使用非常简单，只需要设置 `margin-work-modes` 这个变量。这个变量是一个列表，其含义是哪些 major mode(及其子模式) 支持使用该包来设置 margin，同时可以具体设置不同的 mafor mode 使用不同的 margin 宽度。

下面的是该变量支持的多种格式及其含义：

1. 元素值是 major mode 符号
`(setq margin-work-modes '(markdown-mode org-mode))` 将 markdown-mode 和 org-mode 所在窗口的左右 margin 设置默认的 `margin-left-width` 和 `margin-right-width` 的值。

2. 元素值是 major mode 符号和一个数字组成的列表
`(setq margin-work-modes '(markdown-mode (org-mode 3)))` 将左右 margin 都设置为该数字的值：markdown-mode 的窗口左右 margin 宽度和第一种情况一致，org-mode 窗口的左右 margin 都设置为列表中指定的 3。

3. 元素值是 major mode 符号和两个数字组成的列表
`(setq margin-work-modes '(markdown-mode (org-mode 3 0)))` 将左右 margin 分别设置为这两个数字的值：markdown-mode 的窗口左右 margin 宽度和第一种情况一致，org-mode 窗口的左 margin 设置列表中指定的 3，右 margin 设置列表中指定的 0。

4. 子模式继承父模式的设置
比如 `(setq margin-work-modes '(fundamental-mode))` 表示所有模式窗口都设置默认的 margin; 

`(setq margin-work-modes '((text-mode 2 0)))` 表示所有 text-mode 的子模式(org-mode, markdown-mode...) 左右 margin 都设置为 2,0;

`(setq margin-work-modes '((prog-mode 1)))` 表示所有编程语言的模式 prog-mode 的子模式左右 margin 都设置为 1 ...

使用 `margin-major-mode-chain` 函数来获取当前 major-mode 继承自哪些父模式。

## 配置

下面是一个简单的配置实例：

    (use-package margin-mode
      :load-path "/path/to/margin-mode"
      :config
      (setq margin-work-modes '((org-mode 2 0) markdown-mode))
      (margin-mode 1))

## 注意
对于没有设置在 margin-work-modes 中的 major mode，该插件不会修改原本的默认 margin。对于已经设置在该变量中的 margin，该插件会覆盖原有的 margin, 且当关闭该 margin-mode 这个 minor mode 的时候，所有 margin 会被设置为 0。
