NAME = ft_ality

# Ficheros fuente, en orden de dependencia (un modulo solo puede usar los anteriores)
SRC = types.ml parser.ml automaton.ml
OBJ = $(SRC:.ml=.cmx)

OCAMLOPT = ocamlfind ocamlopt

all: $(NAME)

$(NAME): $(OBJ)
	$(OCAMLOPT) -o $@ $(OBJ)

%.cmx: %.ml
	$(OCAMLOPT) -c $<

clean:
	rm -f *.cmi *.cmx *.o

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
