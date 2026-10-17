NAME = ft_ality

# Ficheros fuente, en orden de dependencia (un modulo solo puede usar los anteriores)
SRC = types.ml parser.ml automaton.ml trainer.ml terminal.ml main.ml
OBJDIR = obj
OBJ = $(addprefix $(OBJDIR)/, $(SRC:.ml=.cmx))

OCAMLOPT = ocamlopt -I $(OBJDIR)

DOCKER_IMAGE ?= ft-ality
GRAMMAR ?= grammars/arena.gmr

all: $(NAME)

$(NAME): $(OBJ)
	$(OCAMLOPT) -o $@ $(OBJ)

$(OBJDIR)/%.cmx: %.ml | $(OBJDIR)
	$(OCAMLOPT) -c -o $@ $<

$(OBJDIR):
	mkdir -p $@

# Dependencias entre modulos: si cambia types.ml, se recompilan los que lo usan
$(OBJDIR)/parser.cmx: $(OBJDIR)/types.cmx
$(OBJDIR)/automaton.cmx: $(OBJDIR)/types.cmx
$(OBJDIR)/trainer.cmx: $(OBJDIR)/automaton.cmx
$(OBJDIR)/main.cmx: $(OBJDIR)/parser.cmx $(OBJDIR)/automaton.cmx $(OBJDIR)/trainer.cmx $(OBJDIR)/terminal.cmx

clean:
	rm -rf $(OBJDIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

docker:
	docker build -t "$(DOCKER_IMAGE)" .
	docker run --rm -it "$(DOCKER_IMAGE)" "$(GRAMMAR)" || { status=$$?; [ "$$status" -eq 130 ] || exit "$$status"; }

docker-clean:
	docker image rm "$(DOCKER_IMAGE)"

.PHONY: all clean fclean re docker docker-clean
