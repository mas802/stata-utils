/*

dodrive.ado

A small utility to run google docs files as stata do files 
for easy collaboration on data analysis.

(c) 2013 Markus Schaffner

*/
cap program drop dodrive
program dodrive
	version 13
	syntax anything(name=gtoken)

	tempname inhandle
	tempname outhandle
	tempname val
	
	tempfile txtfile
	tempfile dofile
	
	// download the google docs as text

	copy "https://docs.google.com/document/export?format=txt&id=`gtoken'" `txtfile', replace text

	// get rid of the first three chars
	file open `inhandle' using `txtfile', read binary
	file seek `inhandle' 3
	file open `outhandle' using `dofile', write binary 
	file read `inhandle' %2bs `val'
	while r(eof)==0 {
	        file write `outhandle' %2bs (`val')
			file read `inhandle' %2bs `val'
	}
	file close `inhandle'
	file close `outhandle'

	do `dofile'
end
