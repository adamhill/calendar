# FILE #p"Makefile"

#0000000011111111112222222222333333333344444444445555555555666666666677777777778
#2345678901234567890123456789012345678901234567890123456789012345678901234567890
#----;-----------------------------------------------;------------------;------;

# EXTERNAL DEPENDENCIES: gron(1)

#  2026-09-23-cal-index.html
all:\
  data-col-info.gron \
  data-col-info.json \
  rooms.csv \
  tools.csv \
  cat-com-sig.csv \
  rooms.xml \
  tools.xml \
  cat-com-sig.xml
	# Not bash recipe. DONE.

# EXTERNAL DEPENDENCIES: gron(1)
data-col-info.gron: \
  data-col-info.json
	# bash recipe
	< data-col-info.json \
	gron \
	> data-col-info.gron \
	;
	# END bash recipe

data-col-info.json: \
  brute-force-col-names-json.lisp \
  ../tests/Fixture/CategoriesEventsFixture.php \
  ../tests/Fixture/CategoriesFixture.php \
  ../tests/Fixture/CommitteesFixture.php \
  ../tests/Fixture/ConfigFixture.php \
  ../tests/Fixture/ConfigurationsFixture.php \
  ../tests/Fixture/ContactsFixture.php \
  ../tests/Fixture/EventsFixture.php \
  ../tests/Fixture/EventsToolsFixture.php \
  ../tests/Fixture/FilesFixture.php \
  ../tests/Fixture/HonorariaFixture.php \
  ../tests/Fixture/PrerequisitesFixture.php \
  ../tests/Fixture/RegistrationsFixture.php \
  ../tests/Fixture/RoomsFixture.php \
  ../tests/Fixture/ToolsFixture.php \
  ../tests/Fixture/W9sFixture.php
	# bash recipe
	./brute-force-col-names-json.lisp \
	> data-col-info.json \
	;
	# END bash recipe


rooms.csv: \
  rooms-csv-from-html.lisp \
  rooms.xml
	# bash recipe
	./rooms-csv-from-html.lisp ;
	# END bash recipe

tools.csv: \
  tools-csv-from-html.lisp \
  tools.xml
	# bash recipe
	./tools-csv-from-html.lisp ;
	# END bash recipe

cat-com-sig.csv: \
  cat-com-sig-csv-from-html.lisp \
  cat-com-sig.xml
	# bash recipe
	./cat-com-sig-csv-from-html.lisp ;
	# END bash recipe

rooms.xml: \
  2026-09-23-cal-index.html
	# bash recipe
	grep \
	  '?room=' \
	  2026-09-23-cal-index.html \
	> rooms.xml \
	;
	# END bash recipe

tools.xml: \
  2026-09-23-cal-index.html
	# bash recipe
	grep \
	  '?tool=' \
	  2026-09-23-cal-index.html \
	> tools.xml \
	;
	# END bash recipe

cat-com-sig.xml: \
  2026-09-23-cal-index.html
	# bash recipe
	grep \
	  '?category=' \
	  2026-09-23-cal-index.html \
	> cat-com-sig.xml \
	;
	# END bash recipe

#2026-09-23-cal-index.html:
#	# bash recipe
#	wget \
#	    --output-document=2026-09-23-cal-index.html \
#	  calendar.dallasmakerspace.org \
#	;
#	# END bash recipe

.PHONY: clean
clean:
	# bash recipe
	# rm rooms.csv || true ;
	# rm tools.csv || true ;
	# rm cat-com-sig.csv || true ;
	rm rooms.xml || true ;
	rm tools.xml || true ;
	rm cat-com-sig.xml || true ;
	# rm 2026-09-23-cal-index.html || true ;
	# END bash recipe

# END OF FILE #p"Makefile"
