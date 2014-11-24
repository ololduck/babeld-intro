# data sources
md         := $(wildcard *.md)
graphs     := $(wildcard *.dot)
images     := $(wildcard *.png) $(wildcard *.jpg)
css        := $(wildcard css/*.css)
js         := $(wildcard js/*.js)

# options
cc         := markdown_py
exts       := $(addprefix -x ,extra admonition codehilite headerid \
	                          sane_lists toc)
ccopts     := $(exts)

# outputs
build_dir  := _build
css_dir    := $(build_dir)/css
js_dir     := $(build_dir)/js
graphs_png := $(addprefix $(build_dir)/,${graphs:.dot=.png})
images_out := $(addprefix $(build_dir)/,$(images))
out_html   := $(addprefix $(build_dir)/,${md:%.md=%.html})
out_pdf    := $(addprefix $(build_dir)/,babeld-intro.pdf)

all: ensure_build_dirs $(addprefix $(build_dir)/,$(js))\
	     $(addprefix $(build_dir)/,$(css))\
	     $(images_out) $(graphs_png) $(out_html)\
		 $(out_pdf)

$(build_dir)/%.html: %.md
	@echo "Compiling $< to $@"
	@$(cc) $(ccopts) $< |bin/res_include.py $(addprefix --link-css , $(css)) $(addprefix --link-js , $(js)) > $@

ensure_build_dirs:
	@if [ ! -d $(build_dir) ]; then mkdir -p $(build_dir);fi
	@if [ ! -d $(css_dir)   ]; then mkdir -p $(css_dir)  ;fi
	@if [ ! -d $(js_dir)    ]; then mkdir -p $(js_dir)   ;fi

$(css_dir)/%.css: css/%.css 
	@echo "Copying $< to $@"
	@cp $< $@

$(js_dir)/%.js: js/%.js 
	@echo "Copying $< to $@"
	@cp $< $@

$(build_dir)/%.png: %.dot
	@echo "Compiling $< to $@"
	@fdp -Tpng -o$@ $<

$(build_dir)/%.png: %.png
	@echo "Compiling $< to $@"
	@cp $< $@

$(build_dir)/%.jpg: %.jpg
	@echo "Compiling $< to $@"
	@cp $< $@

$(out_pdf): $(out_html)
	@echo "rendering $< to $@"
	@wkhtmltopdf -B 10 -T 10 $< $@


clean:
	@rm -rf $(out_html) $(images_png) $(build_dir)
