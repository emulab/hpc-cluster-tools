### makefile automatically created by makenek 07/07/2015 11:06:12 ###
BINNAME=nekkernel
CASEDIR:=/root/hpc-cluster-tools/nekbone_kernel-2.0/test
S:=/root/hpc-cluster-tools/nekbone_kernel-2.0/src
OPT_INCDIR:=./
OBJDIR=obj
F77:=gfortran
P:=-fcray-pointer -fdefault-real-8 -x f77-cpp-input
PPPO=
PPS= UNDERSCORE GLOBAL_LONG_LONG
G:=
OPT_FLAGS_STD=
USR:=
USR_LFLAGS:=

################################################################################

lFLAGS = $(USR_LFLAGS)

PPS_F = $(patsubst %,$(PPPO)-D%,$(PPS))

#NEW #########################################################################
EXTRA = driver.o mxm_wrapper.o semhat.o speclib.o math.o

################################################################################
# MXM 
MXM=mxm_std.o 

#####################################################################################
TMP0 = $(EXTRA) $(MXM)
NOBJS_F0 = $(patsubst %,$(OBJDIR)/%,$(TMP0))

NOBJS0 = $(NOBJS_F0) 
##############################################################################

L0=$(G) -O0
L2=$(G) -O2
L3=$(G) -O3
L4=$(L3)

FL0   = $(L0) $(P) $(PPS_F) -I$(CASEDIR) -I$S -I$(OPT_INCDIR)
FL2i4 = $(L0)      $(PPS_F) -I$(CASEDIR) -I$S -I$(OPT_INCDIR)
FL2   = $(L2) $(P) $(PPS_F) -I$(CASEDIR) -I$S -I$(OPT_INCDIR)
FL3   = $(L3) $(P) $(PPS_F) -I$(CASEDIR) -I$S -I$(OPT_INCDIR)
FL4   = $(L4) $(P) $(PPS_F) -I$(CASEDIR) -I$S -I$(OPT_INCDIR)

cFL0   = $(L0) $(PPS_C) 
cFL2   = $(L2) $(PPS_C) 
cFL3   = $(L3) $(PPS_C) 
cFL4   = $(L4) $(PPS_C) 
################################################################################
all : nekproxy

objdir: 
	@mkdir $(OBJDIR) 2>/dev/null; cat /dev/null 

nekproxy: 	objdir $(NOBJS0)
	$(F77) -o ${BINNAME} $G $(NOBJS0) $(lFLAGS)
	@if test -f ${BINNAME}; then \
	echo "#############################################################"; \
	echo "#                  Compilation successful!                  #"; \
	echo "#############################################################"; \
        size ${BINNAME}; \
        echo ""; \
	else \
	echo -e "\033[1;31;38m" "ERROR: Compilation failed!"; \
	echo -e "\033[0m"; \
	fi
clean:
	rm -rf ./obj ${BINNAME}

$(NOBJS_F0) : SIZE
# CORE      ############################################################################
$(OBJDIR)/driver.o	:$S/driver.f;			$(F77) -c $(FL4) $< -o $@
$(OBJDIR)/semhat.o	:$S/semhat.f;			$(F77) -c $(FL4) $< -o $@
$(OBJDIR)/math.o        :$S/math.f;                     $(F77) -c $(FL4) $< -o $@
$(OBJDIR)/speclib.o	:$S/speclib.f;			$(F77) -c $(FL2) $< -o $@
# MXM       ############################################################################
$(OBJDIR)/mxm_wrapper.o	  :$S/mxm_wrapper.f;		$(F77) -c $(FL2) $< -o $@ 
$(OBJDIR)/mxm_std.o	  :$S/mxm_std.f;		$(F77) -c $(FL4) $< -o $@
