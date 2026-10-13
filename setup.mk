# Entorno de desarrollo OCaml (WSL2/Ubuntu). Uso: make -f setup.mk
# No es el Makefile del proyecto; solo prepara la maquina de desarrollo.

# El proyecto solo necesita OCaml (ocamlopt) y se construye con el Makefile.
# TOOLS: herramientas de desarrollo, no se usan en el codigo entregado
# (ocaml-lsp-server trae dune como dependencia, pero no lo usamos)
TOOLS = ocaml-lsp-server utop

.PHONY: all apt opam tools check

all: apt opam tools check

apt:
	sudo apt update
	sudo apt install -y opam build-essential m4 pkg-config

# --disable-sandboxing: bubblewrap suele fallar en WSL2
opam:
	@if [ -d $(HOME)/.opam ]; then echo "opam ya inicializado"; \
	else opam init --disable-sandboxing --auto-setup -y; fi

# 'opam exec --' sustituye a 'eval $(opam env)', que no persiste entre recetas de make
tools:
	opam install -y $(TOOLS)

check:
	opam exec -- ocaml -version
	opam exec -- ocamlopt -version
	@echo "Listo. En tu terminal ejecuta: eval \$$(opam env)"
