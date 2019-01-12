OCAMLC=ocamlopt
CSV=/usr/local/lib/ocaml/4.02.3/csv/
gen_attendance : attendance.ml
	$(OCAMLC) -I $(CSV) -c attendance.ml
	$(OCAMLC) -o gen_attendance $(CSV)csv.cmxa attendance.cmx

clean:
	rm *.cmo;
	rm *.cmi;
	rm gen_attendance;
