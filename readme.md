[中文文档](./readme_zh.md)

## Introduction
Margin-mode is designed to set left/right margins for windows displaying buffers in different major modes. As is well-known, window margins reset when switching buffers in the current window. Margin-mode ensures margins persist consistently across all scenarios.

Beyond maintaining margins, margin-mode supports configurable left/right margins for different major modes (and all their derived modes). When the margin-work-modesvariable is configured, window margins dynamically change without reloading the major mode.

## Usage
Using margin-mode is straight forward — configure the `margin-work-modes` variable. This variable is a list specifying which major modes (and derived modes) should apply margins and their specific margin widths.

Below are supported formats and their meanings:

1. Element is a major mode symbol
`(setq margin-work-modes '(markdown-mode org-mode))` sets default `margin-left-width` and `margin-right-width` for windows in markdown-mode and org-mode.

2. Element is a list of a major mode symbol and a number​​ 
`(setq margin-work-modes '(markdown-mode (org-mode 3)))` sets both left/right margins to the number: markdown-mode uses default margins, org-mode sets both margins to 3.

3. Element is a list of a major mode symbol and two numbers 
`(setq margin-work-modes '(markdown-mode (org-mode 3 0)))` sets left/right margins separately: markdown-mode uses default margins, org-mode sets left margin to 3, right margin to 0.

4. Submodes inherit parent mode settings
`(setq margin-work-modes '(fundamental-mode))` means all modes inherit default margins.

`(setq margin-work-modes '((text-mode 2 0)))` means all submodes of text-mode(e.g., org-mode, markdown-mode) set margins to 2(left) and 0(right).

`(setq margin-work-modes '((prog-mode 1)))` means all programming language submodes of prog-mode set both margins to 1.

Use `margin-major-mode-chain` to trace the parent mode inheritance of the current major mode.

## Configuration
Example configuration:

    (use-package margin-mode
      :load-path "/path/to/margin-mode"
      :config
      (setq margin-work-modes '((org-mode 2 0) markdown-mode))
      (margin-mode 1))
  
## Notes
For modes not in `margin-work-modes` retain their original margins. For modes in `margin-work-modes`, the plugin overrides existing margins. Disabling the margin-mode minor mode resets all margins to 0.
