@echo off
set MATLAB=G:\MATLAB\R2016a
set MATLAB_ARCH=win64
set MATLAB_BIN="G:\MATLAB\R2016a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=J_y_timeBased_RightStance_mex
set MEX_NAME=J_y_timeBased_RightStance_mex
set MEX_EXT=.mexw64
call setEnv.bat
echo # Make settings for J_y_timeBased_RightStance > J_y_timeBased_RightStance_mex.mki
echo COMPILER=%COMPILER%>> J_y_timeBased_RightStance_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> J_y_timeBased_RightStance_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> J_y_timeBased_RightStance_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> J_y_timeBased_RightStance_mex.mki
echo LINKER=%LINKER%>> J_y_timeBased_RightStance_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> J_y_timeBased_RightStance_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> J_y_timeBased_RightStance_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> J_y_timeBased_RightStance_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> J_y_timeBased_RightStance_mex.mki
echo BORLAND=%BORLAND%>> J_y_timeBased_RightStance_mex.mki
echo OMPFLAGS= >> J_y_timeBased_RightStance_mex.mki
echo OMPLINKFLAGS= >> J_y_timeBased_RightStance_mex.mki
echo EMC_COMPILER=msvc120>> J_y_timeBased_RightStance_mex.mki
echo EMC_CONFIG=optim>> J_y_timeBased_RightStance_mex.mki
"G:\MATLAB\R2016a\bin\win64\gmake" -B -f J_y_timeBased_RightStance_mex.mk
