SRC=exacct

all:
	latexmk --enable-write18 -pdf ${SRC}

clean:
	latexmk -C
	-rm -r ${SRC} ${SRC}.run.xml ${SRC}.bbl tmp-*.pdf 2> /dev/null

check:
	-latex2html -split 0 -nonavigation -noimages -noinfo  -noaddress \
		-html_version 4 -unsegment ${SRC} > /dev/null 2>&1
	sed -E -e 's/(;SPMldquo;|;SPMrdquo;|#)//g' -e 's/~/ /g' ${SRC}/${SRC}.html | \
		languagetool -l en-GB --xmlfilter -u \
			-d EN_QUOTES,WHITESPACE_RULE - > ${SRC}.log
	rm -rf ${SRC}
