##################################################################################################
#This file created by Huy Nguyen
#Created date: 7/1/2019
#Example run string: make {optional} TESTNAME={name_of_testcase} 
#		     make all TESTNAME=test_reg 
##################################################################################################
#Define variables
TESTNAME 	?= default_value_test
TB_NAME 	?= cpu_test
RADIX		?= hexadecimal
REGRESS_LIST	?= regress.list
SRCLIST_V_T	?= compile
#macro_en	?= +define+write_enable
macro_en	?=
#================================================================================================
all: build run
regression: build create_test_list regress report
regression_cov: build create_test_list regress_cov  gen_cov

build:
	mkdir -p log
	touch run_test.vt
	vlib.exe work
	vmap.exe work work
	vlog.exe -coveropt 3 +cover +acc +access+rwc -f $(SRCLIST_V_T).f
run:	
#	cp -rf tb/$(TESTNAME).vt run_test.vt
	vlog.exe $(macro_en) -f compile.f
	vsim.exe -l $(TESTNAME).log -voptargs=+acc+rwc -novopt -assertdebug -c $(TB_NAME) -do "log -r /*;run -all;"
	mv $(TESTNAME).log ./log
	cp -rf  vsim.wlf $(TESTNAME).wlf
	mv $(TESTNAME).wlf ./log
	ln -sf ./log/$(TESTNAME).log sim.log
#	vsim.exe -coverage -vopt work.test_counter -c -do "coverage save -onexit -directive -codeAll counter.ucdb;run -all"
#	vcover.exe report -html counter.ucdb
find:
	find tb
create_test_list:  
	find  tb -type f -printf "%f\n" |sed 's/.vt//' | tee $(REGRESS_LIST) | wc -l

regress:
	#make run TESTNAME=`cat $(REGRESS_LIST) |sed -n 1p $(REGRESS_LIST)`
	#make run TESTNAME=`cat $(REGRESS_LIST) |sed -n 2p $(REGRESS_LIST)`
	#make run TESTNAME=`cat $(REGRESS_LIST) |sed -n 3p $(REGRESS_LIST)`
	#make run TESTNAME=`cat $(REGRESS_LIST) |sed -n 4p $(REGRESS_LIST)`
	#make run TESTNAME=`cat $(REGRESS_LIST) |sed -n 5p $(REGRESS_LIST)`
	#make run TESTNAME=`cat $(REGRESS_LIST) |sed -n 6p $(REGRESS_LIST)`
	#make run TESTNAME=`cat $(REGRESS_LIST) |sed -n 7p $(REGRESS_LIST)`
	#make run TESTNAME=`cat $(REGRESS_LIST) |sed -n 8p $(REGRESS_LIST)`
	./run_all.sh run
	
regress_cov:
	#make run_cov TESTNAME=`cat $(REGRESS_LIST) |sed -n 1p $(REGRESS_LIST)`
	#make run_cov TESTNAME=`cat $(REGRESS_LIST) |sed -n 2p $(REGRESS_LIST)`
	#make run_cov TESTNAME=`cat $(REGRESS_LIST) |sed -n 3p $(REGRESS_LIST)`
	#make run_cov TESTNAME=`cat $(REGRESS_LIST) |sed -n 4p $(REGRESS_LIST)`
	#make run_cov TESTNAME=`cat $(REGRESS_LIST) |sed -n 5p $(REGRESS_LIST)`
	#make run_cov TESTNAME=`cat $(REGRESS_LIST) |sed -n 6p $(REGRESS_LIST)`
	#make run_cov TESTNAME=`cat $(REGRESS_LIST) |sed -n 7p $(REGRESS_LIST)`
	#make run_cov TESTNAME=`cat $(REGRESS_LIST) |sed -n 8p $(REGRESS_LIST)`
	./run_all.sh run_cov
wave:
	vsim.exe -i -view vsim.wlf -do "add wave vsim:/$(TB_NAME)/*; radix -$(RADIX)"

run_cov:
	cp -rf tb/$(TESTNAME).vt run_test.vt
	vlog.exe +cover=sbceftx -f compile.f
	vsim.exe -coverage -l $(TESTNAME).log -c $(TB_NAME) -voptargs="+cover=bcesfx" -novopt -assertdebug -do "coverage save -onexit $(TESTNAME).ucdb; log -r -d 6 /*;run -all"
	mv $(TESTNAME).log ./log
gen_cov:
	mkdir -p coverage
	vcover.exe merge IP.ucdb *.ucdb
	vcover.exe report IP.ucdb -file coverage/summary_report.txt
	vcover.exe report -zeros -details -code bcefsx -All -codeAll IP.ucdb -file coverage/detail_report.txt
clean:
	rm -rf work
	rm -rf log
	rm -rf *.ini
	rm -rf *.log
	rm -rf *.wlf
	rm -rf transcript
	rm -rf coverage
	rm -rf *.ucdb
	rm -rf *.list
	rm -rf *.vt
report:
	grep "passed" ./log/*.log -R 
