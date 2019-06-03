if exist "%USERPROFILE%\code\freud" (
cd "%USERPROFILE%\code\freud"
set "TBB_INCLUDE=%USERPROFILE%\Miniconda3\Library\include"
set "TBB_LINK=%USERPROFILE%\Miniconda3\Library\lib"
python setup.py install --ENABLE-CYTHON
) else (
echo "Did not find freud repository."
)
