FC=gfortran
FCFLAGS=-c -fcheck=bounds -O2 -mtune=native
LDFLAGS=

OBJECTS=AERMET.o AERSURF2.o AERSURF.o ASOSREC.o AUDIT.o AUTCHK.o AVGCRD.o BANNER.o BULKRI.o CALMS.o CBLHT.o CHRCRD2.o CHRCRD.o CHROND.o CLHT.o CLMCRD.o CLOUDS.o COMPDT.o CUBIC.o CVG.o D028LV.o D144HD.o D144LV.o D3280H.o D3280L.o D6201H.o D6201L.o DATCRD.o DATER.o DEF256.o DEFINE.o DOCLDS.o DTCRD.o EQ_CCVR.o ERRHDL.o FDKEY.o FDPATH.o FETCH.o FLIWK1.o FLIWK2.o FLOPEN.o FLOS.o FLSDG.o FLSFC.o FLWRK1.o FLWRK2.o FMTCRD.o GEO.o GET620.o GETASOS.o GETFIL.o GETFLD.o GETFSL.o GETSFC.o GETWRD.o GMTLST.o GREG.o HDPROC.o HEADER.o HEAT.o HGTCRD.o HR0024.o HTCALC.o HTKEY.o HUMID.o HUSWX.o ICHRND.o INCRAD.o INTEQA.o INTHF.o ISHWX.o JBCARD.o LATLON.o LOCCRD.o LWRUPR.o MANDEL.o MDCARD.o MERGE.o MIDNITE.o mod_AsosCommDates.o MODEL.o MPCARD.o MPFIN.o MPHEAD.o MPMET.o MPOUT.o MPPBL.o MPPROC.o MPTEST.o MRCARD.o MRHDR.o MRPATH.o NETRAD.o NR_ANG.o NWSHGT.o OAUDIT.o OSCARD.o OSCHK.o OSDTCD.o OSDUMP.o OSFILL2.o OSFILL.o OSHRAV.o OSNEXT.o OSPATH.o OSPRNT.o OSQACK.o OSQAST.o OSRANGE.o OSREAD.o OSSMRY.o OSSUMS.o OSSWAP.o OSTEST.o OSTRA.o OSWRTE.o OTHHDR.o P2MSUB.o PRESET.o PTAREA.o PTGRAD.o RDHUSW.o RDISHD.o RDLREC.o RDSAMS.o READRL.o REALQA.o RHOCAL.o RNGCRD.o SAMWX.o SAUDIT.o SBLHT.o SCNGEN.o SECCRD2.o SECCRD.o SETHUS.o SETSAM.o SETUP.o SFCARD.o SFCCH2.o SFCCH.o SFCCRD2.o SFCCRD.o SFCHK.o SFCWXX.o SFEXST.o SFEXT.o SFPATH.o SFQASM.o SFQAST.o SFQATM.o SFTRA.o SMTHZI.o STONUM.o SUBST.o SUMHF.o SUMRY1.o SUMRY2.o SUNDAT.o TDPEST.o TEST.o THRESH1MIN.o UACARD.o UACHK.o UAEXST.o UAEXT.o UAMOVE.o UAPATH.o UAQASM.o UAQAST.o UATRA.o UAUDIT.o UAWNDW.o UCALCO.o UCALST.o VALCRD.o VARCRD.o VRCARD.o WRTCRD.o XDTCRD.o XTNDUA.o YR2TOYR4.o YR4TOYR2.o FNDCOMDT.o

all: $(OBJECTS)
	$(FC) $(LDFLAGS) $(OBJECTS) -o aermet

%.o: %.FOR
	$(FC) $(FCFLAGS) $<

clean:
	rm -rf *.o *.mod *.exe aermet
